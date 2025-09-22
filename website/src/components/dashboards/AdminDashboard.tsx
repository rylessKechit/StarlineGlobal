'use client';

import React, { useState } from 'react';
import { 
  Users, 
  DollarSign, 
  Calendar, 
  Star, 
  TrendingUp, 
  Activity,
  CheckCircle,
  Eye,
  Edit,
  Building,
  Shield
} from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';

interface AdminDashboardProps {
  onNavigate: (section: string) => void;
}

export default function AdminDashboard({ onNavigate }: AdminDashboardProps) {
  const [selectedPeriod, setSelectedPeriod] = useState('month');
  const [] = useState('');

  // Données simulées
  const adminStats = {
    totalUsers: 2847,
    totalProviders: 156,
    totalActivities: 89,
    activeBookings: 234,
    monthlyRevenue: 145780,
    avgRating: 4.8,
    conversionRate: 12.5,
    userGrowth: 18.2
  };

  const recentBookings = [
    {
      id: 'BK008',
      client: 'Alexandra Chen',
      provider: 'Monaco VIP Experiences',
      activity: 'Weekend Grand Prix Monaco',
      amount: 2500,
      currency: '€',
      date: '2024-12-15',
      status: 'confirmed',
      commission: 300
    },
    {
      id: 'BK009',
      client: 'David Kim',
      provider: 'The Ritz Paris Spa',
      activity: 'Spa Day Ritz Paris',
      amount: 700,
      currency: '€',
      date: '2024-12-14',
      status: 'completed',
      commission: 84
    },
    {
      id: 'BK010',
      client: 'Priya Sharma',
      provider: 'African Luxury Safaris',
      activity: 'Safari privé Kenya',
      amount: 5700,
      currency: '€',
      date: '2024-12-13',
      status: 'pending',
      commission: 684
    }
  ];

  const topProviders = [
    {
      id: 1,
      name: 'Monaco VIP Experiences',
      owner: 'Jean-Luc Martinez',
      location: 'Monaco',
      revenue: 45780,
      bookings: 156,
      rating: 4.8,
      status: 'active',
      joinDate: '2022-03-15'
    },
    {
      id: 2,
      name: 'The Ritz Paris Spa',
      owner: 'Marie Dubois',
      location: 'Paris',
      revenue: 38920,
      bookings: 203,
      rating: 4.9,
      status: 'active',
      joinDate: '2021-11-20'
    },
    {
      id: 3,
      name: 'African Luxury Safaris',
      owner: 'James Wilson',
      location: 'Kenya',
      revenue: 67450,
      bookings: 89,
      rating: 5.0,
      status: 'active',
      joinDate: '2023-01-10'
    }
  ];

  const recentUsers = [
    {
      id: 1,
      name: 'Isabella Rodriguez',
      email: 'isabella.r@example.com',
      type: 'client',
      joinDate: '2024-12-14',
      totalSpent: 0,
      bookings: 0,
      status: 'active'
    },
    {
      id: 2,
      name: 'Tokyo Culinary Masters',
      email: 'contact@tokyoculinary.com',
      type: 'prestataire',
      joinDate: '2024-12-13',
      totalSpent: 0,
      bookings: 0,
      status: 'pending'
    },
    {
      id: 3,
      name: 'Michael Johnson',
      email: 'michael.j@example.com',
      type: 'client',
      joinDate: '2024-12-12',
      totalSpent: 1250,
      bookings: 2,
      status: 'active'
    }
  ];

  const pendingApprovals = [
    {
      id: 1,
      type: 'activity',
      title: 'Helicopter Tour London',
      provider: 'London Sky Tours',
      submittedDate: '2024-12-14',
      category: 'travel'
    },
    {
      id: 2,
      type: 'provider',
      title: 'Santorini Luxury Villas',
      contact: 'contact@santorini-villas.com',
      submittedDate: '2024-12-13',
      category: 'hotel'
    }
  ];

  const StatusBadge = ({ status }: { status: string }) => {
    const styles = {
      'active': 'bg-green-100 text-green-800',
      'pending': 'bg-amber-100 text-amber-800',
      'confirmed': 'bg-blue-100 text-blue-800',
      'completed': 'bg-slate-100 text-slate-800',
      'cancelled': 'bg-red-100 text-red-800',
      'suspended': 'bg-orange-100 text-orange-800'
    };
    
    const labels = {
      'active': 'Actif',
      'pending': 'En attente',
      'confirmed': 'Confirmé',
      'completed': 'Terminé',
      'cancelled': 'Annulé',
      'suspended': 'Suspendu'
    };
    
    return (
      <span className={`px-2 py-1 rounded-full text-xs font-medium ${styles[status as keyof typeof styles]}`}>
        {labels[status as keyof typeof labels]}
      </span>
    );
  };

  const UserTypeIcon = ({ type }: { type: string }) => {
    switch(type) {
      case 'client': return <Users className="w-4 h-4 text-blue-600" />;
      case 'prestataire': return <Building className="w-4 h-4 text-emerald-600" />;
      case 'admin': return <Shield className="w-4 h-4 text-purple-600" />;
      default: return <Users className="w-4 h-4 text-slate-600" />;
    }
  };

  return (
    <div className="max-w-7xl mx-auto px-6 py-8 space-y-8">
      {/* Welcome Section */}
      <div className="bg-gradient-to-r from-purple-600 to-blue-600 rounded-xl p-8 text-white">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-2xl font-light mb-2">
              Dashboard Administrateur 🚀
            </h2>
            <p className="text-purple-100">
              Vue d'ensemble de la plateforme Starlane Global
            </p>
          </div>
          <div className="text-right">
            <p className="text-purple-100 text-sm">Période sélectionnée</p>
            <select 
              className="bg-white/20 text-white border-white/30 rounded-lg px-3 py-1 text-sm"
              value={selectedPeriod}
              onChange={(e) => setSelectedPeriod(e.target.value)}
            >
              <option value="week">Cette semaine</option>
              <option value="month">Ce mois</option>
              <option value="quarter">Ce trimestre</option>
              <option value="year">Cette année</option>
            </select>
          </div>
        </div>
      </div>

      {/* KPIs Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <Card className="border border-slate-200 hover:shadow-lg transition-shadow">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-4">
              <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                <Users className="w-6 h-6 text-blue-600" />
              </div>
              <div className="flex items-center space-x-1 text-green-600">
                <TrendingUp className="w-4 h-4" />
                <span className="text-sm font-medium">+{adminStats.userGrowth}%</span>
              </div>
            </div>
            <div>
              <p className="text-2xl font-light text-slate-900">{adminStats.totalUsers.toLocaleString()}</p>
              <p className="text-sm text-slate-600">Utilisateurs totaux</p>
            </div>
          </CardContent>
        </Card>

        <Card className="border border-slate-200 hover:shadow-lg transition-shadow">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-4">
              <div className="w-12 h-12 bg-emerald-100 rounded-lg flex items-center justify-center">
                <DollarSign className="w-6 h-6 text-emerald-600" />
              </div>
              <div className="flex items-center space-x-1 text-green-600">
                <TrendingUp className="w-4 h-4" />
                <span className="text-sm font-medium">+15.3%</span>
              </div>
            </div>
            <div>
              <p className="text-2xl font-light text-slate-900">{adminStats.monthlyRevenue.toLocaleString()}€</p>
              <p className="text-sm text-slate-600">Revenus ce mois</p>
            </div>
          </CardContent>
        </Card>

        <Card className="border border-slate-200 hover:shadow-lg transition-shadow">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-4">
              <div className="w-12 h-12 bg-amber-100 rounded-lg flex items-center justify-center">
                <Calendar className="w-6 h-6 text-amber-600" />
              </div>
              <div className="flex items-center space-x-1 text-green-600">
                <TrendingUp className="w-4 h-4" />
                <span className="text-sm font-medium">+8.7%</span>
              </div>
            </div>
            <div>
              <p className="text-2xl font-light text-slate-900">{adminStats.activeBookings}</p>
              <p className="text-sm text-slate-600">Réservations actives</p>
            </div>
          </CardContent>
        </Card>

        <Card className="border border-slate-200 hover:shadow-lg transition-shadow">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-4">
              <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
                <Star className="w-6 h-6 text-purple-600" />
              </div>
              <div className="flex items-center space-x-1 text-green-600">
                <TrendingUp className="w-4 h-4" />
                <span className="text-sm font-medium">+0.3</span>
              </div>
            </div>
            <div>
              <p className="text-2xl font-light text-slate-900">{adminStats.avgRating}</p>
              <p className="text-sm text-slate-600">Note moyenne</p>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Quick Actions & Alerts */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Pending Approvals */}
        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-medium text-slate-900">En attente d'approbation</h3>
              <Badge className="bg-amber-100 text-amber-800">
                {pendingApprovals.length}
              </Badge>
            </div>
            
            <div className="space-y-3">
              {pendingApprovals.map((item) => (
                <div key={item.id} className="border border-slate-200 rounded-lg p-3 hover:shadow-sm transition-shadow">
                  <div className="flex items-start justify-between mb-2">
                    <div className="flex-1">
                      <h4 className="font-medium text-slate-900 text-sm">{item.title}</h4>
                      <p className="text-xs text-slate-600">
                        {item.type === 'activity' ? item.provider : item.contact}
                      </p>
                      <p className="text-xs text-slate-500">{item.submittedDate}</p>
                    </div>
                    <Badge variant="secondary" className="text-xs">
                      {item.type}
                    </Badge>
                  </div>
                  
                  <div className="flex space-x-2">
                    <Button size="sm" className="bg-green-600 hover:bg-green-700 text-white flex-1">
                      <CheckCircle className="w-3 h-3 mr-1" />
                      Approuver
                    </Button>
                    <Button size="sm" variant="outline" className="text-red-600 border-red-200 hover:bg-red-50">
                      Refuser
                    </Button>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Quick Stats */}
        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <h3 className="text-lg font-medium text-slate-900 mb-4">Statistiques rapides</h3>
            
            <div className="space-y-4">
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <Building className="w-4 h-4 text-emerald-600" />
                  <span className="text-sm text-slate-700">Prestataires actifs</span>
                </div>
                <span className="font-medium text-slate-900">{adminStats.totalProviders}</span>
              </div>
              
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <Activity className="w-4 h-4 text-blue-600" />
                  <span className="text-sm text-slate-700">Activités en ligne</span>
                </div>
                <span className="font-medium text-slate-900">{adminStats.totalActivities}</span>
              </div>
              
              <div className="flex items-center justify-between">
                <div className="flex items-center space-x-2">
                  <TrendingUp className="w-4 h-4 text-purple-600" />
                  <span className="text-sm text-slate-700">Taux de conversion</span>
                </div>
                <span className="font-medium text-slate-900">{adminStats.conversionRate}%</span>
              </div>
              
              <div className="flex items-center justify-between pt-2 border-t border-slate-100">
                <span className="text-sm text-slate-500">Commission moyenne</span>
                <span className="font-medium text-emerald-600">12%</span>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Recent Activity */}
        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <h3 className="text-lg font-medium text-slate-900 mb-4">Activité récente</h3>
            
            <div className="space-y-3">
              <div className="flex items-center space-x-3 text-sm">
                <div className="w-2 h-2 bg-green-500 rounded-full"></div>
                <span className="text-slate-700">Nouvelle réservation</span>
                <span className="text-slate-500">il y a 2min</span>
              </div>
              
              <div className="flex items-center space-x-3 text-sm">
                <div className="w-2 h-2 bg-blue-500 rounded-full"></div>
                <span className="text-slate-700">Prestataire inscrit</span>
                <span className="text-slate-500">il y a 15min</span>
              </div>
              
              <div className="flex items-center space-x-3 text-sm">
                <div className="w-2 h-2 bg-amber-500 rounded-full"></div>
                <span className="text-slate-700">Activité soumise</span>
                <span className="text-slate-500">il y a 1h</span>
              </div>
              
              <div className="flex items-center space-x-3 text-sm">
                <div className="w-2 h-2 bg-purple-500 rounded-full"></div>
                <span className="text-slate-700">Avis client reçu</span>
                <span className="text-slate-500">il y a 2h</span>
              </div>
            </div>
            
            <Button 
              variant="outline" 
              size="sm" 
              className="w-full mt-4"
              onClick={() => onNavigate('activity-logs')}
            >
              Voir tous les logs
            </Button>
          </CardContent>
        </Card>
      </div>

      {/* Recent Bookings */}
      <Card className="border border-slate-200">
        <CardContent className="p-6">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-xl font-medium text-slate-900">Réservations récentes</h3>
            <Button 
              onClick={() => onNavigate('all-bookings')}
              variant="outline" 
              size="sm"
            >
              Voir toutes
            </Button>
          </div>
          
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-slate-200">
                  <th className="text-left py-3 px-4 font-medium text-slate-700">Référence</th>
                  <th className="text-left py-3 px-4 font-medium text-slate-700">Client</th>
                  <th className="text-left py-3 px-4 font-medium text-slate-700">Prestataire</th>
                  <th className="text-left py-3 px-4 font-medium text-slate-700">Activité</th>
                  <th className="text-left py-3 px-4 font-medium text-slate-700">Montant</th>
                  <th className="text-left py-3 px-4 font-medium text-slate-700">Commission</th>
                  <th className="text-left py-3 px-4 font-medium text-slate-700">Statut</th>
                  <th className="text-left py-3 px-4 font-medium text-slate-700">Actions</th>
                </tr>
              </thead>
              <tbody>
                {recentBookings.map((booking) => (
                  <tr key={booking.id} className="border-b border-slate-100 hover:bg-slate-50">
                    <td className="py-3 px-4 font-mono text-sm text-slate-600">{booking.id}</td>
                    <td className="py-3 px-4 font-medium text-slate-900">{booking.client}</td>
                    <td className="py-3 px-4 text-slate-700">{booking.provider}</td>
                    <td className="py-3 px-4 text-slate-700">{booking.activity}</td>
                    <td className="py-3 px-4 font-medium text-slate-900">
                      {booking.amount.toLocaleString()}{booking.currency}
                    </td>
                    <td className="py-3 px-4 font-medium text-emerald-600">
                      {booking.commission.toLocaleString()}€
                    </td>
                    <td className="py-3 px-4">
                      <StatusBadge status={booking.status} />
                    </td>
                    <td className="py-3 px-4">
                      <div className="flex space-x-2">
                        <button className="text-slate-400 hover:text-slate-600 transition-colors">
                          <Eye className="w-4 h-4" />
                        </button>
                        <button className="text-slate-400 hover:text-slate-600 transition-colors">
                          <Edit className="w-4 h-4" />
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

      {/* Users & Providers Overview */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Top Providers */}
        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-lg font-medium text-slate-900">Top Prestataires</h3>
              <Button 
                onClick={() => onNavigate('providers')}
                variant="outline" 
                size="sm"
              >
                Gérer tous
              </Button>
            </div>
            
            <div className="space-y-4">
              {topProviders.map((provider, index) => (
                <div key={provider.id} className="flex items-center justify-between p-3 border border-slate-200 rounded-lg hover:shadow-sm transition-shadow">
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-emerald-600 rounded-full flex items-center justify-center">
                      <span className="text-white font-medium text-sm">#{index + 1}</span>
                    </div>
                    <div>
                      <h4 className="font-medium text-slate-900 text-sm">{provider.name}</h4>
                      <p className="text-xs text-slate-600">{provider.owner} • {provider.location}</p>
                      <div className="flex items-center space-x-2 mt-1">
                        <div className="flex items-center space-x-1">
                          <Star className="w-3 h-3 text-amber-400 fill-current" />
                          <span className="text-xs text-slate-600">{provider.rating}</span>
                        </div>
                        <span className="text-xs text-slate-500">•</span>
                        <span className="text-xs text-slate-600">{provider.bookings} réservations</span>
                      </div>
                    </div>
                  </div>
                  <div className="text-right">
                    <p className="font-medium text-slate-900">{provider.revenue.toLocaleString()}€</p>
                    <p className="text-xs text-slate-500">revenus</p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Recent Users */}
        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-lg font-medium text-slate-900">Nouveaux utilisateurs</h3>
              <Button 
                onClick={() => onNavigate('users')}
                variant="outline" 
                size="sm"
              >
                Gérer tous
              </Button>
            </div>
            
            <div className="space-y-4">
              {recentUsers.map((user) => (
                <div key={user.id} className="flex items-center justify-between p-3 border border-slate-200 rounded-lg hover:shadow-sm transition-shadow">
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-slate-200 rounded-full flex items-center justify-center">
                      <UserTypeIcon type={user.type} />
                    </div>
                    <div>
                      <h4 className="font-medium text-slate-900 text-sm">{user.name}</h4>
                      <p className="text-xs text-slate-600">{user.email}</p>
                      <div className="flex items-center space-x-2 mt-1">
                        <Badge variant="secondary" className="text-xs">
                          {user.type}
                        </Badge>
                        <span className="text-xs text-slate-500">•</span>
                        <span className="text-xs text-slate-600">{user.joinDate}</span>
                      </div>
                    </div>
                  </div>
                  <div className="text-right">
                    <StatusBadge status={user.status} />
                    {user.totalSpent > 0 && (
                      <p className="text-xs text-slate-600 mt-1">{user.totalSpent}€ dépensé</p>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}