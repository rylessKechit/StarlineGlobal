'use client';

import React, { useState } from 'react';
import Link from 'next/link';
import { useAuth } from '@/contexts/AuthContext';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Card, CardContent } from '@/components/ui/card';
import { Sparkles, Eye, EyeOff, User, Building, Shield } from 'lucide-react';

export default function LoginPage() {
  const { login } = useAuth();
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    role: 'client'
  });
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState('');

  const roles = [
    { id: 'client', label: 'Client', icon: User, color: 'bg-blue-600', description: 'Accéder aux services' },
    { id: 'prestataire', label: 'Prestataire', icon: Building, color: 'bg-emerald-600', description: 'Gérer mes activités' },
    { id: 'admin', label: 'Admin', icon: Shield, color: 'bg-purple-600', description: 'Administrer la plateforme' }
  ];

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setError('');

    const success = login(formData.email, formData.password, formData.role);
    
    if (!success) {
      setError('Email ou mot de passe incorrect. Utilisez les comptes de démonstration.');
    }
  };

  return (
    <div className="min-h-screen bg-slate-50 flex items-center justify-center py-12 px-4">
      <div className="w-full max-w-md space-y-8">
        {/* Header */}
        <div className="text-center">
          <Link href="/" className="inline-flex items-center space-x-2 mb-8">
            <div className="w-12 h-12 bg-gradient-to-r from-blue-600 to-purple-600 rounded-lg flex items-center justify-center">
              <Sparkles className="w-7 h-7 text-white" />
            </div>
            <div>
              <h1 className="text-xl font-bold text-slate-900">STARLANE GLOBAL</h1>
            </div>
          </Link>
          <h2 className="text-2xl font-light text-slate-900">Connexion</h2>
          <p className="text-slate-600 mt-2">Accédez à votre espace personnel</p>
        </div>

        {/* Login Form */}
        <Card className="border border-slate-200 shadow-lg">
          <CardContent className="p-8">
            <form onSubmit={handleSubmit} className="space-y-6">
              {/* Role Selection */}
              <div className="space-y-3">
                <label className="block text-sm font-medium text-slate-700">
                  Je suis un
                </label>
                <div className="grid grid-cols-1 gap-3">
                  {roles.map((role) => {
                    const IconComponent = role.icon;
                    return (
                      <label key={role.id} className="cursor-pointer">
                        <input
                          type="radio"
                          name="role"
                          value={role.id}
                          checked={formData.role === role.id}
                          onChange={(e) => setFormData({...formData, role: e.target.value})}
                          className="sr-only"
                        />
                        <div className={`flex items-center space-x-4 p-4 border-2 rounded-lg transition-all ${
                          formData.role === role.id 
                            ? 'border-blue-500 bg-blue-50' 
                            : 'border-slate-200 hover:border-slate-300'
                        }`}>
                          <div className={`w-10 h-10 ${role.color} rounded-lg flex items-center justify-center`}>
                            <IconComponent className="w-5 h-5 text-white" />
                          </div>
                          <div className="flex-1">
                            <h3 className="font-medium text-slate-900">{role.label}</h3>
                            <p className="text-sm text-slate-600">{role.description}</p>
                          </div>
                        </div>
                      </label>
                    );
                  })}
                </div>
              </div>

              {/* Email */}
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">
                  Email
                </label>
                <Input
                  type="email"
                  required
                  value={formData.email}
                  onChange={(e) => setFormData({...formData, email: e.target.value})}
                  placeholder="votre@email.com"
                />
              </div>

              {/* Password */}
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">
                  Mot de passe
                </label>
                <div className="relative">
                  <Input
                    type={showPassword ? "text" : "password"}
                    required
                    value={formData.password}
                    onChange={(e) => setFormData({...formData, password: e.target.value})}
                    className="pr-10"
                    placeholder="••••••••"
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-3 top-1/2 transform -translate-y-1/2 text-slate-400 hover:text-slate-600"
                  >
                    {showPassword ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                  </button>
                </div>
              </div>

              {/* Error Message */}
              {error && (
                <div className="text-red-600 text-sm bg-red-50 p-3 rounded-lg">
                  {error}
                </div>
              )}

              {/* Demo Accounts */}
              <div className="bg-slate-50 rounded-lg p-4 space-y-2">
                <h4 className="text-sm font-medium text-slate-900">Comptes de démonstration :</h4>
                <div className="space-y-1 text-xs text-slate-600">
                  <p><strong>Client :</strong> client@demo.com / demo123</p>
                  <p><strong>Prestataire :</strong> prestataire@demo.com / demo123</p>
                  <p><strong>Admin :</strong> admin@demo.com / demo123</p>
                </div>
              </div>

              {/* Submit Button */}
              <Button
                type="submit"
                className="w-full bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white py-3"
              >
                Se connecter
              </Button>
            </form>

            {/* Register Link */}
            <div className="text-center mt-6">
              <p className="text-sm text-slate-600">
                Pas encore de compte ?{' '}
                <Link href="/auth/register" className="text-blue-600 hover:text-blue-700 font-medium">
                  S'inscrire
                </Link>
              </p>
            </div>
          </CardContent>
        </Card>

        {/* Back to Home */}
        <div className="text-center">
          <Link href="/" className="text-sm text-slate-500 hover:text-slate-700">
            ← Retour à l'accueil
          </Link>
        </div>
      </div>
    </div>
  );
}