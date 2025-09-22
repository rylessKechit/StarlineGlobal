'use client';

import React, { createContext, useContext, useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';

interface User {
  role: string;
  name: string;
  email: string;
}

interface AuthContextType {
  user: User | null;
  login: (email: string, password: string, role: string) => boolean;
  logout: () => void;
  isLoading: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const router = useRouter();

  // Initialize auth state from cookies on mount
  useEffect(() => {
    const userRole = document.cookie
      .split('; ')
      .find(row => row.startsWith('userRole='))
      ?.split('=')[1];
    
    const userName = document.cookie
      .split('; ')
      .find(row => row.startsWith('userName='))
      ?.split('=')[1];

    const userEmail = document.cookie
      .split('; ')
      .find(row => row.startsWith('userEmail='))
      ?.split('=')[1];

    const isAuthenticated = document.cookie
      .split('; ')
      .find(row => row.startsWith('isAuthenticated='))
      ?.split('=')[1] === 'true';

    if (isAuthenticated && userRole && userName && userEmail) {
      setUser({
        role: userRole,
        name: decodeURIComponent(userName),
        email: decodeURIComponent(userEmail)
      });
    }
    
    setIsLoading(false);
  }, []);

  const login = (email: string, password: string, role: string): boolean => {
    // Mock authentication - replace with real auth logic
    const mockUsers = {
      'client@demo.com': { role: 'client', name: 'Alexandra Chen' },
      'prestataire@demo.com': { role: 'prestataire', name: 'Jean-Luc Martinez' },
      'admin@demo.com': { role: 'admin', name: 'Admin Starlane' }
    };

    const mockUser = mockUsers[email as keyof typeof mockUsers];
    
    if (mockUser && password === 'demo123') {
      const userData = {
        role: mockUser.role,
        name: mockUser.name,
        email: email
      };

      setUser(userData);

      // Set cookies for middleware
      document.cookie = `userRole=${userData.role}; path=/; max-age=86400`;
      document.cookie = `userName=${encodeURIComponent(userData.name)}; path=/; max-age=86400`;
      document.cookie = `userEmail=${encodeURIComponent(userData.email)}; path=/; max-age=86400`;
      document.cookie = `isAuthenticated=true; path=/; max-age=86400`;

      // Redirect to appropriate dashboard
      if (userData.role === 'client') {
        router.push('/client');
      } else if (userData.role === 'prestataire') {
        router.push('/provider');
      } else if (userData.role === 'admin') {
        router.push('/admin');
      }

      return true;
    }

    return false;
  };

  const logout = () => {
    setUser(null);
    
    // Clear cookies
    document.cookie = 'userRole=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT';
    document.cookie = 'userName=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT';
    document.cookie = 'userEmail=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT';
    document.cookie = 'isAuthenticated=; path=/; expires=Thu, 01 Jan 1970 00:00:01 GMT';
    
    router.push('/');
  };

  return (
    <AuthContext.Provider value={{ user, login, logout, isLoading }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
}