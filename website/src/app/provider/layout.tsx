'use client';

import React from 'react';
import Link from 'next/link';
import { useAuth } from '@/contexts/AuthContext';
import { usePathname } from 'next/navigation';
import { 
  Sparkles, 
  Calendar, 
  User, 
  Settings, 
  LogOut,
  Home,
  Activity,
  Plus,
  BarChart3
} from 'lucide-react';

export default function ProviderLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const { user, logout } = useAuth();
  const pathname = usePathname();

  const navigation = [
    {
      name: 'Dashboard',
      href: '/provider',
      icon: Home,
      current: pathname === '/provider'
    },
    {
      name: 'Mes activités',
      href: '/provider/activities',
      icon: Activity,
      current: pathname === '/provider/activities' || pathname.startsWith('/provider/activities/')
    },
    {
      name: 'Ajouter activité',
      href: '/provider/activities/new',
      icon: Plus,
      current: pathname === '/provider/activities/new'
    },
    {
      name: 'Réservations',
      href: '/provider/bookings',
      icon: Calendar,
      current: pathname === '/provider/bookings'
    },
    {
      name: 'Analytics',
      href: '/provider/analytics',
      icon: BarChart3,
      current: pathname === '/provider/analytics'
    }
  ];

  return (
    <div className="min-h-screen bg-slate-50">
      {/* Sidebar */}
      <div className="fixed inset-y-0 left-0 z-50 w-64 bg-white shadow-lg">
        {/* Logo */}
        <div className="flex items-center space-x-3 px-6 py-6 border-b border-slate-200">
          <div className="w-10 h-10 bg-gradient-to-r from-emerald-600 to-blue-600 rounded-lg flex items-center justify-center">
            <Sparkles className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-lg font-bold text-slate-900">STARLANE GLOBAL</h1>
            <p className="text-xs text-slate-600">Prestataire Dashboard</p>
          </div>
        </div>

        {/* Navigation */}
        <nav className="mt-6 px-4">
          <div className="space-y-2">
            {navigation.map((item) => {
              const IconComponent = item.icon;
              return (
                <Link
                  key={item.name}
                  href={item.href}
                  className={`flex items-center space-x-3 px-4 py-3 text-sm font-medium rounded-lg transition-colors ${
                    item.current
                      ? 'bg-emerald-100 text-emerald-700 border-r-2 border-emerald-500'
                      : 'text-slate-600 hover:text-slate-900 hover:bg-slate-100'
                  }`}
                >
                  <IconComponent className="w-5 h-5" />
                  <span>{item.name}</span>
                </Link>
              );
            })}
          </div>
        </nav>

        {/* User Info & Actions */}
        <div className="absolute bottom-0 left-0 right-0 p-4 border-t border-slate-200 bg-white">
          <div className="flex items-center space-x-3 mb-4">
            <div className="w-10 h-10 bg-emerald-600 rounded-full flex items-center justify-center">
              <span className="text-white font-medium text-sm">
                {user?.name?.split(' ').map(n => n[0]).join('').toUpperCase()}
              </span>
            </div>
            <div className="flex-1 min-w-0">
              <p className="text-sm font-medium text-slate-900 truncate">
                {user?.name}
              </p>
              <p className="text-xs text-slate-500 truncate">
                {user?.email}
              </p>
            </div>
          </div>
          
          <div className="flex space-x-2">
            <button className="flex-1 flex items-center justify-center space-x-2 px-3 py-2 text-sm text-slate-600 hover:text-slate-900 hover:bg-slate-100 rounded-lg transition-colors">
              <Settings className="w-4 h-4" />
              <span>Paramètres</span>
            </button>
            <button
              onClick={logout}
              className="flex-1 flex items-center justify-center space-x-2 px-3 py-2 text-sm text-red-600 hover:text-red-700 hover:bg-red-50 rounded-lg transition-colors"
            >
              <LogOut className="w-4 h-4" />
              <span>Déconnexion</span>
            </button>
          </div>
        </div>
      </div>

      {/* Main Content */}
      <div className="pl-64">
        <main>
          {children}
        </main>
      </div>
    </div>
  );
}