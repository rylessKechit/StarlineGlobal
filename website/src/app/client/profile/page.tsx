'use client';

import React, { useState } from 'react';
import { useAuth } from '@/contexts/AuthContext';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { 
  User, 
  Mail, 
  Phone, 
  MapPin, 
  Calendar,
  Star,
  Bell,
  Shield,
  CreditCard,
  Save,
  Edit
} from 'lucide-react';

export default function ClientProfilePage() {
  const { user } = useAuth();
  const [isEditing, setIsEditing] = useState(false);
  const [profileData, setProfileData] = useState({
    firstName: 'Alexandra',
    lastName: 'Chen',
    email: 'alexandra.chen@example.com',
    phone: '+44 7934 123 456',
    address: '123 Knightsbridge, London SW1X 7RJ',
    birthday: '1990-03-15',
    preferences: {
      language: 'English',
      currency: 'GBP',
      notifications: true,
      newsletter: true
    }
  });

  const membershipInfo = {
    level: 'Premium',
    since: '2023',
    totalSpent: 12450,
    bookingsCount: 47,
    favoriteServices: ['Transport', 'Spa & Wellness', 'Fine Dining']
  };

  const handleSave = () => {
    alert('Profil mis à jour avec succès !');
    setIsEditing(false);
  };

  return (
    <div className="max-w-4xl mx-auto px-6 py-8 space-y-8">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-light text-slate-900">Mon profil</h1>
          <p className="text-slate-600">Gérez vos informations personnelles et préférences</p>
        </div>
        <Button
          onClick={() => setIsEditing(!isEditing)}
          variant={isEditing ? "outline" : "default"}
          className="flex items-center space-x-2"
        >
          <Edit className="w-4 h-4" />
          <span>{isEditing ? 'Annuler' : 'Modifier'}</span>
        </Button>
      </div>

      {/* Profile Overview */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Left Column - Main Profile */}
        <div className="lg:col-span-2 space-y-6">
          {/* Personal Information */}
          <Card className="border border-slate-200">
            <CardContent className="p-6">
              <h3 className="text-lg font-medium text-slate-900 mb-6">Informations personnelles</h3>
              
              <div className="space-y-6">
                <div className="flex items-center space-x-6">
                  <div className="w-20 h-20 bg-blue-600 rounded-full flex items-center justify-center">
                    <span className="text-white font-medium text-xl">
                      {profileData.firstName.charAt(0)}{profileData.lastName.charAt(0)}
                    </span>
                  </div>
                  <div className="flex-1">
                    <h4 className="text-xl font-medium text-slate-900">
                      {profileData.firstName} {profileData.lastName}
                    </h4>
                    <p className="text-slate-600">Membre Premium depuis {membershipInfo.since}</p>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Prénom</label>
                    <Input
                      value={profileData.firstName}
                      onChange={(e) => setProfileData({...profileData, firstName: e.target.value})}
                      disabled={!isEditing}
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Nom</label>
                    <Input
                      value={profileData.lastName}
                      onChange={(e) => setProfileData({...profileData, lastName: e.target.value})}
                      disabled={!isEditing}
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Email</label>
                    <div className="relative">
                      <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-slate-400" />
                      <Input
                        className="pl-10"
                        value={profileData.email}
                        onChange={(e) => setProfileData({...profileData, email: e.target.value})}
                        disabled={!isEditing}
                      />
                    </div>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Téléphone</label>
                    <div className="relative">
                      <Phone className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-slate-400" />
                      <Input
                        className="pl-10"
                        value={profileData.phone}
                        onChange={(e) => setProfileData({...profileData, phone: e.target.value})}
                        disabled={!isEditing}
                      />
                    </div>
                  </div>
                  <div className="md:col-span-2">
                    <label className="block text-sm font-medium text-slate-700 mb-2">Adresse</label>
                    <div className="relative">
                      <MapPin className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-slate-400" />
                      <Input
                        className="pl-10"
                        value={profileData.address}
                        onChange={(e) => setProfileData({...profileData, address: e.target.value})}
                        disabled={!isEditing}
                      />
                    </div>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Date de naissance</label>
                    <div className="relative">
                      <Calendar className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-slate-400" />
                      <Input
                        type="date"
                        className="pl-10"
                        value={profileData.birthday}
                        onChange={(e) => setProfileData({...profileData, birthday: e.target.value})}
                        disabled={!isEditing}
                      />
                    </div>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Preferences */}
          <Card className="border border-slate-200">
            <CardContent className="p-6">
              <h3 className="text-lg font-medium text-slate-900 mb-6">Préférences</h3>
              
              <div className="space-y-6">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Langue</label>
                    <select 
                      className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                      value={profileData.preferences.language}
                      onChange={(e) => setProfileData({
                        ...profileData, 
                        preferences: {...profileData.preferences, language: e.target.value}
                      })}
                      disabled={!isEditing}
                    >
                      <option value="English">English</option>
                      <option value="Français">Français</option>
                      <option value="Español">Español</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Devise</label>
                    <select 
                      className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                      value={profileData.preferences.currency}
                      onChange={(e) => setProfileData({
                        ...profileData, 
                        preferences: {...profileData.preferences, currency: e.target.value}
                      })}
                      disabled={!isEditing}
                    >
                      <option value="GBP">GBP - British Pound</option>
                      <option value="EUR">EUR - Euro</option>
                      <option value="USD">USD - US Dollar</option>
                    </select>
                  </div>
                </div>

                <div className="space-y-4">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-3">
                      <Bell className="w-5 h-5 text-slate-600" />
                      <div>
                        <p className="font-medium text-slate-900">Notifications push</p>
                        <p className="text-sm text-slate-600">Recevoir des alertes sur votre téléphone</p>
                      </div>
                    </div>
                    <label className="relative inline-flex items-center cursor-pointer">
                      <input 
                        type="checkbox" 
                        checked={profileData.preferences.notifications}
                        onChange={(e) => setProfileData({
                          ...profileData, 
                          preferences: {...profileData.preferences, notifications: e.target.checked}
                        })}
                        disabled={!isEditing}
                        className="sr-only peer"
                      />
                      <div className="w-11 h-6 bg-slate-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                    </label>
                  </div>

                  <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-3">
                      <Mail className="w-5 h-5 text-slate-600" />
                      <div>
                        <p className="font-medium text-slate-900">Newsletter</p>
                        <p className="text-sm text-slate-600">Offres exclusives et actualités</p>
                      </div>
                    </div>
                    <label className="relative inline-flex items-center cursor-pointer">
                      <input 
                        type="checkbox"
                        checked={profileData.preferences.newsletter}
                        onChange={(e) => setProfileData({
                          ...profileData, 
                          preferences: {...profileData.preferences, newsletter: e.target.checked}
                        })}
                        disabled={!isEditing}
                        className="sr-only peer"
                      />
                      <div className="w-11 h-6 bg-slate-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-blue-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-slate-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-blue-600"></div>
                    </label>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Right Column - Stats & Quick Info */}
        <div className="space-y-6">
          {/* Membership Status */}
          <Card className="border border-slate-200 bg-gradient-to-br from-blue-50 to-purple-50">
            <CardContent className="p-6">
              <div className="text-center">
                <div className="w-16 h-16 bg-gradient-to-r from-blue-600 to-purple-600 rounded-full flex items-center justify-center mx-auto mb-4">
                  <Star className="w-8 h-8 text-white" />
                </div>
                <h3 className="text-lg font-medium text-slate-900 mb-2">
                  Membre {membershipInfo.level}
                </h3>
                <p className="text-slate-600 mb-4">Depuis {membershipInfo.since}</p>
                <Badge className="bg-gradient-to-r from-blue-600 to-purple-600 text-white">
                  Statut Actif
                </Badge>
              </div>
            </CardContent>
          </Card>

          {/* Statistics */}
          <Card className="border border-slate-200">
            <CardContent className="p-6">
              <h3 className="text-lg font-medium text-slate-900 mb-6">Statistiques</h3>
              
              <div className="space-y-4">
                <div className="flex items-center justify-between">
                  <span className="text-slate-600">Total dépensé</span>
                  <span className="font-medium text-slate-900">£{membershipInfo.totalSpent.toLocaleString()}</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-slate-600">Réservations</span>
                  <span className="font-medium text-slate-900">{membershipInfo.bookingsCount}</span>
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-slate-600">Satisfaction</span>
                  <div className="flex items-center space-x-1">
                    <Star className="w-4 h-4 text-amber-400 fill-current" />
                    <span className="font-medium text-slate-900">4.9/5</span>
                  </div>
                </div>
              </div>
            </CardContent>
          </Card>

          {/* Favorite Services */}
          <Card className="border border-slate-200">
            <CardContent className="p-6">
              <h3 className="text-lg font-medium text-slate-900 mb-4">Services favoris</h3>
              
              <div className="space-y-3">
                {membershipInfo.favoriteServices.map((service, index) => (
                  <div key={service} className="flex items-center space-x-3">
                    <div className="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center">
                      <span className="text-blue-600 font-medium text-sm">{index + 1}</span>
                    </div>
                    <span className="text-slate-700">{service}</span>
                  </div>
                ))}
              </div>
            </CardContent>
          </Card>

          {/* Quick Actions */}
          <Card className="border border-slate-200">
            <CardContent className="p-6">
              <h3 className="text-lg font-medium text-slate-900 mb-4">Actions rapides</h3>
              
              <div className="space-y-3">
                <Button variant="outline" size="sm" className="w-full justify-start">
                  <CreditCard className="w-4 h-4 mr-2" />
                  Moyens de paiement
                </Button>
                <Button variant="outline" size="sm" className="w-full justify-start">
                  <Shield className="w-4 h-4 mr-2" />
                  Sécurité & Confidentialité
                </Button>
                <Button variant="outline" size="sm" className="w-full justify-start">
                  <Bell className="w-4 h-4 mr-2" />
                  Préférences notifications
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>

      {/* Save Button */}
      {isEditing && (
        <div className="flex items-center justify-end space-x-4 pt-6 border-t border-slate-200">
          <Button variant="outline" onClick={() => setIsEditing(false)}>
            Annuler
          </Button>
          <Button onClick={handleSave} className="bg-blue-600 hover:bg-blue-700 text-white">
            <Save className="w-4 h-4 mr-2" />
            Enregistrer les modifications
          </Button>
        </div>
      )}
    </div>
  );
}