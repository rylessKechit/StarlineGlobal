'use client';

import React, { useState } from 'react';
import { 
  Plus, 
  Calendar, 
  Users, 
  DollarSign, 
  Star, 
  TrendingUp,
  Clock,
  CheckCircle,
  AlertCircle,
  Eye,
  Edit,
  Trash2,
  MapPin,
  Phone,
  Mail,
  Camera,
  Sparkles,
  Mountain,
  Plane,
  Hotel
} from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';

interface ProviderDashboardProps {
  onNavigate: (section: string) => void;
}

export default function ProviderDashboard({ onNavigate }: ProviderDashboardProps) {
  const [activeTab, setActiveTab] = useState('overview');

  // Données simulées du prestataire
  const providerData = {
    name: "Monaco VIP Experiences",
    owner: "Jean-Luc Martinez",
    email: "contact@monacoVIP.com",
    phone: "+377 97 98 12 34",
    location: "Monaco",
    memberSince: "2022",
    totalBookings: 156,
    rating: 4.8,
    totalRevenue: 45780
  };

  // Activités du prestataire
  const myActivities = [
    {
      id: 1,
      title: "Weekend Grand Prix Monaco",
      category: "travel",
      status: "active",
      price: 1250,
      currency: "€",
      bookings: 23,
      rating: 4.8,
      reviews: 203,
      availability: "Mai 2025",
      lastBooking: "2024-12-10",
      image: "/monaco-gp.jpg"
    },
    {
      id: 2,
      title: "Yacht Party Monaco",
      category: "travel", 
      status: "active",
      price: 850,
      currency: "€",
      bookings: 15,
      rating: 4.9,
      reviews: 87,
      availability: "Disponible",
      lastBooking: "2024-12-08",
      image: "/yacht-monaco.jpg"
    },
    {
      id: 3,
      title: "Casino VIP Night",
      category: "travel",
      status: "paused",
      price: 450,
      currency: "€",
      bookings: 8,
      rating: 4.7,
      reviews: 34,
      availability: "Suspendu",
      lastBooking: "2024-11-25",
      image: "/casino-monaco.jpg"
    }
  ];

  // Réservations en cours
  const currentBookings = [
    {
      id: "BK005",
      activity: "Weekend Grand Prix Monaco",
      client: "Alexandra Chen",
      clientPhone: "+44 7934 123 456",
      clientEmail: "alexandra.chen@example.com",
      date: "2024-12-22",
      time: "09:00",
      guests: 2,
      status: "confirmed",
      amount: 2500,
      currency: "€",
      specialRequests: "Champagne et roses pour anniversaire"
    },
    {
      id: "BK006",
      activity: "Yacht Party Monaco", 
      client: "David Kim",
      clientPhone: "+1 555 987 654",
      clientEmail: "david.kim@example.com",
      date: "2024-12-20",
      time: "18:00",
      guests: 4,
      status: "pending",
      amount: 3400,
      currency: "€",
      specialRequests: "Régime végétarien pour 2 personnes"
    },
    {
      id: "BK007",
      activity: "Weekend Grand Prix Monaco",
      client: "Priya Sharma",
      clientPhone: "+44 7123 456 789",
      clientEmail: "priya.sharma@example.com", 
      date: "2024-12-18",
      time: "10:00",
      guests: 3,
      status: "confirmed",
      amount: 3750,
      currency: "€",
      specialRequests: "Transfer depuis Nice inclus"
    }
  ];

  // Historique récent
  const recentHistory = [
    {
      id: "BK004",
      activity: "Yacht Party Monaco",
      client: "Marcus Williams",
      date: "2024-12-10",
      amount: 1700,
      currency: "€",
      status: "completed",
      rating: 5,
      review: "Expérience exceptionnelle, organisation parfaite !"
    },
    {
      id: "BK003",
      activity: "Weekend Grand Prix Monaco", 
      client: "Sofia Rodriguez",
      date: "2024-12-08",
      amount: 2500,
      currency: "€",
      status: "completed",
      rating: 4,
      review: "Très bien organisé, quelques petits détails à améliorer."
    }
  ];

  const StatusBadge = ({ status }: { status: string }) => {
    const styles = {
      'confirmed': 'bg-green-100 text-green-800',
      'pending': 'bg-amber-100 text-amber-800',
      'cancelled': 'bg-red-100 text-red-800',
      'completed': 'bg-slate-100 text-slate-800',
      'active': 'bg-blue-100 text-blue-800',
      'paused': 'bg-orange-100 text-orange-800'
    };
    
    const labels = {
      'confirmed': 'Confirmé',
      'pending': 'En attente',
      'cancelled': 'Annulé',
      'completed': 'Terminé',
      'active': 'Actif',
      'paused': 'Suspendu'
    };
    
    return (
      <span className={`px-3 py-1 rounded-full text-xs font-medium ${styles[status as keyof typeof styles]}`}>
        {labels[status as keyof typeof labels]}
      </span>
    );
  };

  const CategoryIcon = ({ category }: { category: string }) => {
    switch(category) {
      case 'spa': return <Sparkles className="w-4 h-4 text-pink-600" />;
      case 'safari': return <Mountain className="w-4 h-4 text-emerald-600" />;
      case 'travel': return <Plane className="w-4 h-4 text-blue-600" />;
      case 'hotel': return <Hotel className="w-4 h-4 text-purple-600" />;
      default: return <Calendar className="w-4 h-4 text-slate-600" />;
    }
  };

  return (
    <div className="max-w-7xl mx-auto px-6 py-8 space-y-8">
      {/* Welcome Section */}
      <div className="bg-gradient-to-r from-emerald-600 to-blue-600 rounded-xl p-8 text-white">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-2xl font-light mb-2">
              Bonjour Jean-Luc 👋
            </h2>
            <p className="text-emerald-100">
              {providerData.name} • Membre depuis {providerData.memberSince} • {providerData.totalBookings} réservations
            </p>
          </div>
          <div className="text-right">
            <div className="flex items-center space-x-1 mb-1">
              <Star className="w-4 h-4 text-amber-300 fill-current" />
              <span className="font-medium">{providerData.rating}</span>
            </div>
            <p className="text-emerald-100 text-sm">Note moyenne</p>
          </div>
        </div>
      </div>

      {/* Quick Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <Card className="border border-slate-200 hover:shadow-lg transition-shadow">
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                <Calendar className="w-6 h-6 text-green-600" />
              </div>
              <div>
                <p className="text-2xl font-light text-slate-900">{currentBookings.length}</p>
                <p className="text-sm text-slate-600">Réservations en cours</p>
              </div>
            </div>
          </CardContent>
        </Card>
        
        <Card className="border border-slate-200 hover:shadow-lg transition-shadow">
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                <Sparkles className="w-6 h-6 text-blue-600" />
              </div>
              <div>
                <p className="text-2xl font-light text-slate-900">{myActivities.filter(a => a.status === 'active').length}</p>
                <p className="text-sm text-slate-600">Activités actives</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="border border-slate-200 hover:shadow-lg transition-shadow">
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-amber-100 rounded-lg flex items-center justify-center">
                <DollarSign className="w-6 h-6 text-amber-600" />
              </div>
              <div>
                <p className="text-2xl font-light text-slate-900">9,650€</p>
                <p className="text-sm text-slate-600">Revenus ce mois</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="border border-slate-200 hover:shadow-lg transition-shadow cursor-pointer" onClick={() => onNavigate('add-activity')}>
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
                <Plus className="w-6 h-6 text-purple-600" />
              </div>
              <div>
                <p className="text-sm font-medium text-slate-900">Nouvelle</p>
                <p className="text-sm text-slate-600">activité</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Current Bookings */}
      <Card className="border border-slate-200">
        <CardContent className="p-6">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-xl font-medium text-slate-900">Réservations en cours</h3>
            <Button 
              onClick={() => onNavigate('all-bookings')}
              variant="outline" 
              size="sm"
            >
              Voir toutes
            </Button>
          </div>
          
          <div className="space-y-4">
            {currentBookings.map((booking) => (
              <div key={booking.id} className="border border-slate-200 rounded-lg p-4 hover:shadow-md transition-shadow">
                <div className="flex items-start justify-between mb-4">
                  <div className="flex-1">
                    <div className="flex items-center space-x-3 mb-2">
                      <h4 className="font-medium text-slate-900">{booking.activity}</h4>
                      <StatusBadge status={booking.status} />
                    </div>
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm text-slate-600">
                      <div>
                        <p className="text-slate-500 mb-1">Client</p>
                        <p className="font-medium text-slate-900">{booking.client}</p>
                        <div className="space-y-1">
                          <div className="flex items-center space-x-1">
                            <Phone className="w-3 h-3" />
                            <span>{booking.clientPhone}</span>
                          </div>
                          <div className="flex items-center space-x-1">
                            <Mail className="w-3 h-3" />
                            <span>{booking.clientEmail}</span>
                          </div>
                        </div>
                      </div>
                      
                      <div>
                        <p className="text-slate-500 mb-1">Date & Détails</p>
                        <p className="font-medium text-slate-900">{booking.date} à {booking.time}</p>
                        <div className="flex items-center space-x-1 mt-1">
                          <Users className="w-3 h-3" />
                          <span>{booking.guests} personne{booking.guests > 1 ? 's' : ''}</span>
                        </div>
                      </div>
                      
                      <div>
                        <p className="text-slate-500 mb-1">Montant</p>
                        <p className="font-medium text-slate-900 text-lg">{booking.amount}{booking.currency}</p>
                      </div>
                    </div>
                    
                    {booking.specialRequests && (
                      <div className="mt-3 p-3 bg-slate-50 rounded-lg">
                        <p className="text-sm text-slate-500 mb-1">Demandes spéciales :</p>
                        <p className="text-sm text-slate-700">{booking.specialRequests}</p>
                      </div>
                    )}
                  </div>
                </div>
                
                <div className="flex items-center justify-between pt-4 border-t border-slate-100">
                  <div className="flex space-x-3">
                    {booking.status === 'pending' && (
                      <>
                        <Button size="sm" className="bg-green-600 hover:bg-green-700 text-white">
                          <CheckCircle className="w-4 h-4 mr-1" />
                          Confirmer
                        </Button>
                        <Button size="sm" variant="outline" className="text-red-600 border-red-200 hover:bg-red-50">
                          Refuser
                        </Button>
                      </>
                    )}
                    {booking.status === 'confirmed' && (
                      <Button size="sm" variant="outline">
                        <Phone className="w-4 h-4 mr-1" />
                        Contacter client
                      </Button>
                    )}
                  </div>
                  <p className="text-xs text-slate-500">Réf: {booking.id}</p>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* My Activities */}
      <Card className="border border-slate-200">
        <CardContent className="p-6">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-xl font-medium text-slate-900">Mes activités</h3>
            <div className="flex space-x-3">
              <Button 
                onClick={() => onNavigate('manage-activities')}
                variant="outline"
                size="sm"
              >
                Gérer toutes
              </Button>
              <Button 
                onClick={() => onNavigate('add-activity')}
                className="bg-gradient-to-r from-emerald-600 to-blue-600 hover:from-emerald-700 hover:to-blue-700 text-white"
              >
                <Plus className="w-4 h-4 mr-2" />
                Ajouter une activité
              </Button>
            </div>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {myActivities.map((activity) => (
              <Card key={activity.id} className="border border-slate-200 hover:shadow-lg transition-shadow">
                <div className="relative aspect-[4/3] bg-gradient-to-br from-slate-200 to-slate-300 rounded-t-lg overflow-hidden">
                  <div className="absolute top-4 left-4">
                    <StatusBadge status={activity.status} />
                  </div>
                  <div className="absolute top-4 right-4 flex space-x-2">
                    <button className="w-8 h-8 bg-white/80 rounded-full flex items-center justify-center hover:bg-white transition-colors">
                      <Eye className="w-4 h-4 text-slate-600" />
                    </button>
                    <button className="w-8 h-8 bg-white/80 rounded-full flex items-center justify-center hover:bg-white transition-colors">
                      <Edit className="w-4 h-4 text-slate-600" />
                    </button>
                  </div>
                  <div className="absolute bottom-4 left-4">
                    <CategoryIcon category={activity.category} />
                  </div>
                </div>
                
                <CardContent className="p-4">
                  <div className="space-y-3">
                    <div>
                      <h4 className="font-medium text-slate-900 line-clamp-1">{activity.title}</h4>
                      <p className="text-sm text-slate-600">Dernière réservation: {activity.lastBooking}</p>
                    </div>
                    
                    <div className="grid grid-cols-2 gap-3 text-sm">
                      <div>
                        <span className="text-slate-500">Prix:</span>
                        <p className="font-medium text-slate-900">{activity.price}{activity.currency}</p>
                      </div>
                      <div>
                        <span className="text-slate-500">Réservations:</span>
                        <p className="font-medium text-slate-900">{activity.bookings}</p>
                      </div>
                      <div>
                        <span className="text-slate-500">Note:</span>
                        <div className="flex items-center space-x-1">
                          <Star className="w-3 h-3 text-amber-400 fill-current" />
                          <span className="font-medium text-slate-900">{activity.rating}</span>
                          <span className="text-slate-500">({activity.reviews})</span>
                        </div>
                      </div>
                      <div>
                        <span className="text-slate-500">Disponibilité:</span>
                        <p className="font-medium text-slate-900 text-xs">{activity.availability}</p>
                      </div>
                    </div>
                    
                    <div className="flex space-x-2 pt-3 border-t border-slate-100">
                      <Button size="sm" variant="outline" className="flex-1">
                        <Edit className="w-3 h-3 mr-1" />
                        Modifier
                      </Button>
                      <Button size="sm" variant="outline" className="text-red-600 border-red-200 hover:bg-red-50">
                        <Trash2 className="w-3 h-3" />
                      </Button>
                    </div>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Performance Stats */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Revenue Chart */}
        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-lg font-medium text-slate-900">Revenus mensuels</h3>
              <div className="flex items-center space-x-1 text-green-600">
                <TrendingUp className="w-4 h-4" />
                <span className="text-sm font-medium">+12%</span>
              </div>
            </div>
            
            <div className="space-y-4">
              {[
                { month: 'Novembre', amount: 8450, percentage: 85 },
                { month: 'Octobre', amount: 7250, percentage: 72 },
                { month: 'Septembre', amount: 9680, percentage: 97 },
                { month: 'Août', amount: 11200, percentage: 100 },
              ].map((data, index) => (
                <div key={index} className="space-y-2">
                  <div className="flex justify-between text-sm">
                    <span className="text-slate-600">{data.month}</span>
                    <span className="font-medium text-slate-900">{data.amount}€</span>
                  </div>
                  <div className="w-full bg-slate-200 rounded-full h-2">
                    <div 
                      className="bg-gradient-to-r from-emerald-600 to-blue-600 h-2 rounded-full transition-all"
                      style={{ width: `${data.percentage}%` }}
                    />
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* Recent Reviews */}
        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <h3 className="text-lg font-medium text-slate-900 mb-6">Avis récents</h3>
            
            <div className="space-y-4">
              {recentHistory.map((item) => (
                <div key={item.id} className="border-b border-slate-100 last:border-0 pb-4 last:pb-0">
                  <div className="flex items-start justify-between mb-2">
                    <div>
                      <h4 className="font-medium text-slate-900 text-sm">{item.activity}</h4>
                      <p className="text-sm text-slate-600">{item.client} • {item.date}</p>
                    </div>
                    <div className="flex items-center space-x-1">
                      {[...Array(5)].map((_, i) => (
                        <Star 
                          key={i} 
                          className={`w-3 h-3 ${i < item.rating ? 'text-amber-400 fill-current' : 'text-slate-300'}`} 
                        />
                      ))}
                    </div>
                  </div>
                  <p className="text-sm text-slate-700 italic">"{item.review}"</p>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}