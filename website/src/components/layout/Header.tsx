'use client';

import React from 'react';
import Link from 'next/link';
import { useAuth } from '@/contexts/AuthContext';
import { Button } from '@/components/ui/button';
import { Sparkles, Menu } from 'lucide-react';

export default function Header() {
  const { user, isLoading } = useAuth();

  if (isLoading) {
    return null; // or loading skeleton
  }

  // If user is authenticated, they should not see this header
  // (they'll be redirected by middleware or be in dashboard)
  if (user) {
    return null;
  }

  return (
    <header className="sticky top-0 z-50 bg-white/95 backdrop-blur-sm border-b border-slate-200">
      <div className="container mx-auto px-4 py-4 flex items-center justify-between">
        <Link href="/" className="flex items-center space-x-2">
          <div className="w-10 h-10 bg-gradient-to-r from-blue-600 to-purple-600 rounded-lg flex items-center justify-center">
            <Sparkles className="w-6 h-6 text-white" />
          </div>
          <div>
            <h1 className="text-xl font-bold text-slate-900">STARLANE GLOBAL</h1>
            <p className="text-xs text-slate-600">Luxury Services & Lifestyle</p>
          </div>
        </Link>
        
        {/* Desktop Navigation */}
        <nav className="hidden md:flex items-center space-x-8">
          <a href="#services" className="text-slate-700 hover:text-blue-600 transition-colors font-medium">
            Services
          </a>
          <a href="#locations" className="text-slate-700 hover:text-purple-600 transition-colors font-medium">
            Locations
          </a>
          <a href="#about" className="text-slate-700 hover:text-emerald-600 transition-colors font-medium">
            About
          </a>
          <a href="#contact" className="text-slate-700 hover:text-amber-600 transition-colors font-medium">
            Contact
          </a>
          <Link href="/auth/login">
            <Button 
              variant="outline" 
              className="mr-2 border-slate-300 hover:border-blue-500 hover:text-blue-600"
            >
              Se connecter
            </Button>
          </Link>
          <Link href="/auth/register">
            <Button className="bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700">
              S'inscrire
            </Button>
          </Link>
        </nav>

        {/* Mobile Menu Button */}
        <button className="md:hidden p-2">
          <Menu className="w-6 h-6 text-slate-700" />
        </button>
      </div>
    </header>
  );
}