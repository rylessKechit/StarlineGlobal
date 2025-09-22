'use client';

import React, { useState } from 'react';
import { 
  Users, 
  Building, 
  Shield, 
  Search, 
  Filter,
  Plus,
  Edit,
  Trash2,
  Eye,
  Mail,
  Phone,
  Calendar,
  DollarSign,
  Star,
  AlertCircle,
  CheckCircle,
  X,
  UserPlus
} from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';

export default function UsersManagementPage() {
  const [activeTab, setActiveTab] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [showAddModal, setShowAddModal] = useState(false);
  const [selectedUser, setSelectedUser] = useState<any>(null);
  const [showEditModal, setShowEditModal] = useState(false);

  // Données simulées
  const users = [
    {
      id: 1,
      name: 'Alexandra Chen',
      email: 'alexandra.chen@example.com',
      phone: '+44 7934 123 456',
      type: 'client',
      status: 'active',
      joinDate: '2023-08-15',
      totalSpent: 2450,
      bookings: 12,
      lastActive: '2024-12-14',
      avatar: 'AC'
    },
    {
      id: 2,
      name: 'Monaco VIP Experiences',
      email: 'contact@monacoVIP.com',
      phone: '+377 97 98 12 34',
      type: 'prestataire',
      status: 'active',
      joinDate: '2022-03-20',
      totalRevenue: 45780,
      bookings: 156,
      lastActive: '2024-12-15',
      avatar: 'MVE',
      owner: 'Jean-Luc Martinez',
      location: 'Monaco'
    },
    {
      id: 3,
      name: 'David Kim',
      email: 'david.kim@example.com',
      phone: '+1 555 987 654',
      type: 'client',
      status: 'active',
      joinDate: '2024-01-10',
      totalSpent: 890,
      bookings: 3,
      lastActive: '2024-12-12',
      avatar: 'DK'
    },
    {
      id: 4,
      name: 'The Ritz Paris Spa',
      email: 'spa@ritzparis.com',
      phone: '+33 1 43 16 30 30',
      type: 'prestataire',
      status: 'active',
      joinDate: '2021-11-20',
      totalRevenue: 38920,
      bookings: 203,
      lastActive: '2024-12-13',
      avatar: 'RPS',
      owner: 'Marie Dubois',
      location: 'Paris'
    },
    {
      id: 5,
      name: 'Priya Sharma',
      email: 'priya.sharma@example.com',
      phone: '+44 7123 456 789',
      type: 'client',
      status: 'pending',
      joinDate: '2024-12-10',
      totalSpent: 0,
      bookings: 0,
      lastActive: '2024-12-10',
      avatar: 'PS'
    },
    {
      id: 6,
      name: 'African Luxury Safaris',
      email: 'info@africanluxurysafaris.com',
      phone: '+254 20 123 4567',
      type: 'prestataire',
      status: 'suspended',
      joinDate: '2023-01-10',
      totalRevenue: 67450,
      bookings: 89,
      lastActive: '2024-11-28',
      avatar: 'ALS',
      owner: 'James Wilson',
      location: 'Kenya'
    }
  ];

  const [newUser, setNewUser] = useState({
    name: '',
    email: '',
    phone: '',
    type: 'client',
    owner: '',
    location: ''
  });

  const filteredUsers = users.filter(user => {
    const matchesSearch = user.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         user.email.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesTab = activeTab === 'all' || user.type === activeTab || user.status === activeTab;
    return matchesSearch && matchesTab;
  });

  const StatusBadge = ({ status }: { status: string }) => {
    const styles = {
      'active': 'bg-green-100 text-green-800',
      'pending': 'bg-amber-100 text-amber-800',
      'suspended': 'bg-red-100 text-red-800',
      'inactive': 'bg-slate-100 text-slate-800'
    };
    
    const labels = {
      'active': 'Actif',
      'pending': 'En attente',
      'suspended': 'Suspendu',
      'inactive': 'Inactif'
    };
    
    return (
      <span className={`px-2 py-1 rounded-full text-xs font-medium ${styles[status as keyof typeof styles]}`}>
        {labels[status as keyof typeof labels]}
      </span>
    );
  };

  const UserTypeIcon = ({ type }: { type: string }) => {
    const styles = {
      'client': 'bg-blue-100 text-blue-600',
      'prestataire': 'bg-emerald-100 text-emerald-600',
      'admin': 'bg-purple-100 text-purple-600'
    };
    
    return (
      <div className={`w-8 h-8 rounded-full flex items-center justify-center ${styles[type as keyof typeof styles]}`}>
        {type === 'client' && <Users className="w-4 h-4" />}
        {type === 'prestataire' && <Building className="w-4 h-4" />}
        {type === 'admin' && <Shield className="w-4 h-4" />}
      </div>
    );
  };

  const handleAddUser = () => {
    const user = {
      id: users.length + 1,
      ...newUser,
      status: 'active',
      joinDate: new Date().toISOString().split('T')[0],
      totalSpent: 0,
      totalRevenue: 0,
      bookings: 0,
      lastActive: new Date().toISOString().split('T')[0],
      avatar: newUser.name.split(' ').map(n => n[0]).join('').toUpperCase()
    };
    
    alert(`Utilisateur ${newUser.name} créé avec succès !`);
    setShowAddModal(false);
    setNewUser({ name: '', email: '', phone: '', type: 'client', owner: '', location: '' });
  };

  const handleStatusChange = (userId: number, newStatus: string) => {
    alert(`Statut de l'utilisateur #${userId} changé vers: ${newStatus}`);
  };

  const handleDeleteUser = (userId: number) => {
    if (confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?')) {
      alert(`Utilisateur #${userId} supprimé`);
    }
  };

  const tabs = [
    { id: 'all', label: 'Tous', count: users.length },
    { id: 'client', label: 'Clients', count: users.filter(u => u.type === 'client').length },
    { id: 'prestataire', label: 'Prestataires', count: users.filter(u => u.type === 'prestataire').length },
    { id: 'pending', label: 'En attente', count: users.filter(u => u.status === 'pending').length }
  ];

  return (
    <div className="max-w-7xl mx-auto px-6 py-8 space-y-8">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-light text-slate-900">Gestion des utilisateurs</h1>
          <p className="text-slate-600">Gérez les comptes clients, prestataires et leurs accès</p>
        </div>
        <Button 
          onClick={() => setShowAddModal(true)}
          className="bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white"
        >
          <UserPlus className="w-4 h-4 mr-2" />
          Ajouter un utilisateur
        </Button>
      </div>

      {/* Filters */}
      <div className="flex flex-col md:flex-row gap-4 items-start md:items-center justify-between">
        {/* Search */}
        <div className="relative flex-1 max-w-md">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-slate-400" />
          <Input
            placeholder="Rechercher par nom ou email..."
            className="pl-10"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>

        {/* Tabs */}
        <div className="flex space-x-2">
          {tabs.map((tab) => (
            <button
              key={tab.id}
              onClick={() => setActiveTab(tab.id)}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                activeTab === tab.id
                  ? 'bg-blue-600 text-white'
                  : 'bg-white text-slate-600 hover:bg-slate-50 border border-slate-200'
              }`}
            >
              {tab.label} ({tab.count})
            </button>
          ))}
        </div>
      </div>

      {/* Users Table */}
      <Card className="border border-slate-200">
        <CardContent className="p-0">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-slate-50 border-b border-slate-200">
                <tr>
                  <th className="text-left py-4 px-6 font-medium text-slate-700">Utilisateur</th>
                  <th className="text-left py-4 px-6 font-medium text-slate-700">Type</th>
                  <th className="text-left py-4 px-6 font-medium text-slate-700">Contact</th>
                  <th className="text-left py-4 px-6 font-medium text-slate-700">Performance</th>
                  <th className="text-left py-4 px-6 font-medium text-slate-700">Statut</th>
                  <th className="text-left py-4 px-6 font-medium text-slate-700">Actions</th>
                </tr>
              </thead>
              <tbody>
                {filteredUsers.map((user) => (
                  <tr key={user.id} className="border-b border-slate-100 hover:bg-slate-50">
                    <td className="py-4 px-6">
                      <div className="flex items-center space-x-3">
                        <div className="w-10 h-10 bg-slate-200 rounded-full flex items-center justify-center">
                          <span className="text-slate-700 font-medium text-sm">{user.avatar}</span>
                        </div>
                        <div>
                          <h3 className="font-medium text-slate-900">{user.name}</h3>
                          {user.owner && <p className="text-sm text-slate-600">{user.owner}</p>}
                          <p className="text-xs text-slate-500">Membre depuis {user.joinDate}</p>
                        </div>
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <div className="flex items-center space-x-2">
                        <UserTypeIcon type={user.type} />
                        <div>
                          <p className="font-medium text-slate-900 capitalize">{user.type}</p>
                          {user.location && <p className="text-xs text-slate-500">{user.location}</p>}
                        </div>
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <div className="space-y-1">
                        <div className="flex items-center space-x-2 text-sm text-slate-600">
                          <Mail className="w-3 h-3" />
                          <span>{user.email}</span>
                        </div>
                        <div className="flex items-center space-x-2 text-sm text-slate-600">
                          <Phone className="w-3 h-3" />
                          <span>{user.phone}</span>
                        </div>
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <div className="space-y-1">
                        <div className="flex items-center space-x-2 text-sm">
                          <DollarSign className="w-3 h-3 text-emerald-600" />
                          <span className="font-medium text-slate-900">
                            {user.type === 'prestataire' 
                              ? `${user.totalRevenue?.toLocaleString()}€ revenus`
                              : `${user.totalSpent?.toLocaleString()}€ dépensés`
                            }
                          </span>
                        </div>
                        <div className="flex items-center space-x-2 text-sm text-slate-600">
                          <Calendar className="w-3 h-3" />
                          <span>{user.bookings} {user.type === 'prestataire' ? 'réservations' : 'commandes'}</span>
                        </div>
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <div className="space-y-2">
                        <StatusBadge status={user.status} />
                        <p className="text-xs text-slate-500">Actif: {user.lastActive}</p>
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <div className="flex items-center space-x-2">
                        <button 
                          onClick={() => {
                            setSelectedUser(user);
                            setShowEditModal(true);
                          }}
                          className="p-2 hover:bg-blue-100 rounded-lg transition-colors"
                        >
                          <Edit className="w-4 h-4 text-blue-600" />
                        </button>
                        <button className="p-2 hover:bg-slate-100 rounded-lg transition-colors">
                          <Eye className="w-4 h-4 text-slate-600" />
                        </button>
                        
                        {/* Status actions */}
                        {user.status === 'active' && (
                          <button 
                            onClick={() => handleStatusChange(user.id, 'suspended')}
                            className="p-2 hover:bg-red-100 rounded-lg transition-colors"
                          >
                            <AlertCircle className="w-4 h-4 text-red-600" />
                          </button>
                        )}
                        {user.status === 'suspended' && (
                          <button 
                            onClick={() => handleStatusChange(user.id, 'active')}
                            className="p-2 hover:bg-green-100 rounded-lg transition-colors"
                          >
                            <CheckCircle className="w-4 h-4 text-green-600" />
                          </button>
                        )}
                        {user.status === 'pending' && (
                          <button 
                            onClick={() => handleStatusChange(user.id, 'active')}
                            className="p-2 hover:bg-green-100 rounded-lg transition-colors"
                          >
                            <CheckCircle className="w-4 h-4 text-green-600" />
                          </button>
                        )}
                        
                        <button 
                          onClick={() => handleDeleteUser(user.id)}
                          className="p-2 hover:bg-red-100 rounded-lg transition-colors"
                        >
                          <Trash2 className="w-4 h-4 text-red-600" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>

      {/* Add User Modal */}
      {showAddModal && (
        <div className="fixed inset-0 z-50 flex items-center justify-center">
          <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" onClick={() => setShowAddModal(false)} />
          <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-md mx-4">
            <div className="flex items-center justify-between p-6 border-b border-slate-200">
              <h2 className="text-xl font-medium text-slate-900">Ajouter un utilisateur</h2>
              <button onClick={() => setShowAddModal(false)} className="p-2 hover:bg-slate-100 rounded-lg">
                <X className="w-5 h-5 text-slate-600" />
              </button>
            </div>
            
            <div className="p-6 space-y-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">Type d'utilisateur</label>
                <select
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                  value={newUser.type}
                  onChange={(e) => setNewUser({...newUser, type: e.target.value})}
                >
                  <option value="client">Client</option>
                  <option value="prestataire">Prestataire</option>
                </select>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">
                  {newUser.type === 'prestataire' ? 'Nom de l\'entreprise' : 'Nom complet'}
                </label>
                <Input
                  placeholder={newUser.type === 'prestataire' ? 'Monaco VIP Experiences' : 'Alexandra Chen'}
                  value={newUser.name}
                  onChange={(e) => setNewUser({...newUser, name: e.target.value})}
                />
              </div>
              
              {newUser.type === 'prestataire' && (
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">Propriétaire</label>
                  <Input
                    placeholder="Jean-Luc Martinez"
                    value={newUser.owner}
                    onChange={(e) => setNewUser({...newUser, owner: e.target.value})}
                  />
                </div>
              )}
              
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">Email</label>
                <Input
                  type="email"
                  placeholder="contact@example.com"
                  value={newUser.email}
                  onChange={(e) => setNewUser({...newUser, email: e.target.value})}
                />
              </div>
              
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">Téléphone</label>
                <Input
                  placeholder="+33 6 12 34 56 78"
                  value={newUser.phone}
                  onChange={(e) => setNewUser({...newUser, phone: e.target.value})}
                />
              </div>
              
              {newUser.type === 'prestataire' && (
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">Localisation</label>
                  <Input
                    placeholder="Paris, Monaco, Londres..."
                    value={newUser.location}
                    onChange={(e) => setNewUser({...newUser, location: e.target.value})}
                  />
                </div>
              )}
            </div>
            
            <div className="flex space-x-3 p-6 border-t border-slate-200">
              <Button variant="outline" onClick={() => setShowAddModal(false)} className="flex-1">
                Annuler
              </Button>
              <Button 
                onClick={handleAddUser} 
                className="flex-1 bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white"
                disabled={!newUser.name || !newUser.email}
              >
                Créer
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}