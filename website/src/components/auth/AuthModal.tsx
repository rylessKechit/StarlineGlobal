'use client';

import React, { useState } from 'react';
import { X, Eye, EyeOff, User, Building, Shield } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

interface AuthModalProps {
  isOpen: boolean;
  onClose: () => void;
  mode: 'login' | 'register';
  onModeChange: (mode: 'login' | 'register') => void;
  onLogin: (email: string, password: string, role: string) => void;
}

export default function AuthModal({ isOpen, onClose, mode, onModeChange, onLogin }: AuthModalProps) {
  const [showPassword, setShowPassword] = useState(false);
  const [selectedRole, setSelectedRole] = useState('client');
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    firstName: '',
    lastName: '',
    phone: '',
    company: ''
  });

  const handleSubmit = () => {
    onLogin(formData.email, formData.password, selectedRole);
    onClose();
  };

  const roles = [
    { id: 'client', label: 'Client', icon: User, color: 'bg-blue-600', description: 'Réserver des services' },
    { id: 'prestataire', label: 'Prestataire', icon: Building, color: 'bg-emerald-600', description: 'Proposer des activités' },
    { id: 'admin', label: 'Admin', icon: Shield, color: 'bg-purple-600', description: 'Gérer la plateforme' }
  ];

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center">
      {/* Overlay */}
      <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" onClick={onClose} />
      
      {/* Modal */}
      <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-md mx-4 max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="flex items-center justify-between p-6 border-b border-slate-200">
          <div>
            <h2 className="text-2xl font-light text-slate-900">
              {mode === 'login' ? 'Se connecter' : 'Créer un compte'}
            </h2>
            <p className="text-sm text-slate-600 mt-1">
              {mode === 'login' ? 'Accédez à votre espace personnel' : 'Rejoignez Starlane Global'}
            </p>
          </div>
          <button
            onClick={onClose}
            className="p-2 hover:bg-slate-100 rounded-lg transition-colors"
          >
            <X className="w-5 h-5 text-slate-600" />
          </button>
        </div>

        <div className="p-6 space-y-6">
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
                      checked={selectedRole === role.id}
                      onChange={(e) => setSelectedRole(e.target.value)}
                      className="sr-only"
                    />
                    <div className={`flex items-center space-x-4 p-4 border-2 rounded-lg transition-all ${
                      selectedRole === role.id 
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

          {/* Form Fields */}
          {mode === 'register' && (
            <>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">
                    Prénom
                  </label>
                  <Input
                    type="text"
                    required
                    value={formData.firstName}
                    onChange={(e) => setFormData({...formData, firstName: e.target.value})}
                    className="w-full"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">
                    Nom
                  </label>
                  <Input
                    type="text"
                    required
                    value={formData.lastName}
                    onChange={(e) => setFormData({...formData, lastName: e.target.value})}
                    className="w-full"
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">
                  Téléphone
                </label>
                <Input
                  type="tel"
                  required
                  value={formData.phone}
                  onChange={(e) => setFormData({...formData, phone: e.target.value})}
                  className="w-full"
                  placeholder="+33 6 12 34 56 78"
                />
              </div>

              {selectedRole === 'prestataire' && (
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">
                    Entreprise
                  </label>
                  <Input
                    type="text"
                    required
                    value={formData.company}
                    onChange={(e) => setFormData({...formData, company: e.target.value})}
                    className="w-full"
                    placeholder="Nom de votre entreprise"
                  />
                </div>
              )}
            </>
          )}

          <div>
            <label className="block text-sm font-medium text-slate-700 mb-2">
              Email
            </label>
            <Input
              type="email"
              required
              value={formData.email}
              onChange={(e) => setFormData({...formData, email: e.target.value})}
              className="w-full"
              placeholder="votre@email.com"
            />
          </div>

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
                className="w-full pr-10"
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
            onClick={handleSubmit}
            className="w-full bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white py-3"
          >
            {mode === 'login' ? 'Se connecter' : 'Créer mon compte'}
          </Button>

          {/* Switch Mode */}
          <div className="text-center">
            <button
              type="button"
              onClick={() => onModeChange(mode === 'login' ? 'register' : 'login')}
              className="text-sm text-blue-600 hover:text-blue-700 font-medium"
            >
              {mode === 'login' 
                ? "Pas encore de compte ? S'inscrire" 
                : "Déjà un compte ? Se connecter"
              }
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}