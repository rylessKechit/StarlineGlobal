'use client';

import React from 'react';
import { 
  Car, 
  Plane, 
  Calendar, 
  Clock,
  User, 
  Star,
  Plus,
  Phone,
  Navigation,
  Sparkles,
  CheckCircle
} from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';

interface ClientDashboardProps {
  onNavigate: (section: string) => void;
}

export default function ClientDashboard({ onNavigate }: ClientDashboardProps) {
  // Données simulées
  const clientData = {
    name: "Alexandra Chen",
    email: "alexandra.chen@example.com",
    phone: "+44 7934 123 456",
    memberSince: "2023",
    totalBookings: 47,
    favoriteDriver: "Marcus W."
  };

  const currentBookings = [
    {
      id: "BK001",
      type: "transport",
      service: "Chauffeur privé",
      from: "Hôtel Ritz Paris",
      to: "CDG Terminal 2E",
      date: "2024-12-15",
      time: "14:30",
      status: "confirmed",
      driver: "Jean-Luc M.",
      vehicle: "Mercedes Classe S",
      price: "€85"
    },
    {
      id: "BK002", 
      type: "meet-greet",
      service: "Meet & Greet",
      location: "Heathrow Terminal 5",
      date: "2024-12-16",
      time: "16:45",
      status: "confirmed",
      host: "Emily R.",
      flight: "BA 315",
      price: "£65"
    }
  ];

  const upcomingActivities = [
    {
      id: "AC001",
      type: "spa",
      name: "Spa Day at The Ritz",
      date: "2024-12-18",
      time: "10:00",
      location: "London",
      price: "£350",
      status: "confirmed"
    },
    {
      id: "AC002",
      type: "travel",
      name: "Weekend à Monaco",
      date: "2024-12-22",
      time: "09:00",
      location: "Monaco",
      price: "€2,450",
      status: "in-progress"
    }
  ];

  const recentHistory = [
    {
      id: "BK003",
      service: "Transport aéroport",
      date: "2024-12-10",
      price: "£55",
      status: "completed",
      rating: 5
    },
    {
      id: "BK004",
      service: "Spa & Wellness",
      date: "2024-12-08",
      price: "€280",
      status: "completed",
      rating: 5
    }
  ];

  const ServiceIcon = ({ type }: { type: string }) => {
    switch(type) {
      case 'transport': return <Car className="w-5 h-5 text-blue-600" />;
      case 'meet-greet': return <User className="w-5 h-5 text-emerald-600" />;
      case 'travel': return <Plane className="w-5 h-5 text-purple-600" />;
      case 'spa': return <Sparkles className="w-5 h-5 text-pink-600" />;
      default: return <Calendar className="w-5 h-5 text-slate-600" />;
    }
  };

  const StatusBadge = ({ status }: { status: string }) => {
    const styles = {
      'confirmed': 'bg-green-100 text-green-800',
      'completed': 'bg-slate-100 text-slate-800', 
      'in-progress': 'bg-amber-100 text-amber-800',
      'cancelled': 'bg-red-100 text-red-800'
    };
    
    const labels = {
      'confirmed': 'Confirmé',
      'completed': 'Terminé',
      'in-progress': 'En cours',
      'cancelled': 'Annulé'
    };
    
    return (
      <span className={`px-3 py-1 rounded-full text-xs font-medium ${styles[status as keyof typeof styles]}`}>
        {labels[status as keyof typeof labels]}
      </span>
    );
  };

  return (
    <div className="max-w-7xl mx-auto px-6 py-8 space-y-8">
      {/* Welcome Section */}
      <div className="bg-gradient-to-r from-blue-600 to-purple-600 rounded-xl p-8 text-white">
        <div className="flex items-center justify-between">
          <div>
            <h2 className="text-2xl font-light mb-2">
              Bonjour Alexandra 👋
            </h2>
            <p className="text-blue-100">
              Membre Premium depuis {clientData.memberSince} • {clientData.totalBookings} prestations
            </p>
          </div>
          <div className="text-right">
            <p className="text-blue-100 text-sm">Chauffeur favori</p>
            <p className="font-medium">{clientData.favoriteDriver}</p>
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
                <p className="text-2xl font-light text-slate-900">2</p>
                <p className="text-sm text-slate-600">Prochaines réservations</p>
              </div>
            </div>
          </CardContent>
        </Card>
        
        <Card className="border border-slate-200 hover:shadow-lg transition-shadow">
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                <Star className="w-6 h-6 text-blue-600" />
              </div>
              <div>
                <p className="text-2xl font-light text-slate-900">4.9</p>
                <p className="text-sm text-slate-600">Satisfaction moyenne</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="border border-slate-200 hover:shadow-lg transition-shadow">
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center">
                <Sparkles className="w-6 h-6 text-purple-600" />
              </div>
              <div>
                <p className="text-2xl font-light text-slate-900">2</p>
                <p className="text-sm text-slate-600">Activités ce mois</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="border border-slate-200 hover:shadow-lg transition-shadow cursor-pointer" onClick={() => onNavigate('new-booking')}>
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-amber-100 rounded-lg flex items-center justify-center">
                <Plus className="w-6 h-6 text-amber-600" />
              </div>
              <div>
                <p className="text-sm font-medium text-slate-900">Nouvelle</p>
                <p className="text-sm text-slate-600">réservation</p>
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
              onClick={() => onNavigate('bookings')}
              variant="outline" 
              size="sm"
            >
              Voir tout
            </Button>
          </div>
          
          <div className="space-y-4">
            {currentBookings.map((booking) => (
              <div key={booking.id} className="border border-slate-200 rounded-lg p-4 hover:shadow-md transition-shadow">
                <div className="flex items-center justify-between mb-3">
                  <div className="flex items-center space-x-4">
                    <ServiceIcon type={booking.type} />
                    <div>
                      <h4 className="font-medium text-slate-900">{booking.service}</h4>
                      <div className="flex items-center space-x-4 text-sm text-slate-600 mt-1">
                        <span className="flex items-center space-x-1">
                          <Calendar className="w-4 h-4" />
                          <span>{booking.date}</span>
                        </span>
                        <span className="flex items-center space-x-1">
                          <Clock className="w-4 h-4" />
                          <span>{booking.time}</span>
                        </span>
                      </div>
                    </div>
                  </div>
                  <StatusBadge status={booking.status} />
                </div>
                
                <div className="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm mb-4">
                  <div>
                    <p className="text-slate-500 mb-1">Itinéraire</p>
                    {booking.from && booking.to ? (
                      <p className="text-slate-900 flex items-center space-x-1">
                        <span>{booking.from}</span>
                        <Navigation className="w-3 h-3 text-slate-400" />
                        <span>{booking.to}</span>
                      </p>
                    ) : (
                      <p className="text-slate-900">{booking.location}</p>
                    )}
                  </div>
                  
                  <div>
                    <p className="text-slate-500 mb-1">Prestataire</p>
                    <p className="text-slate-900 font-medium">
                      {booking.driver || booking.host}
                    </p>
                    {booking.vehicle && <p className="text-slate-600">{booking.vehicle}</p>}
                    {booking.flight && <p className="text-slate-600">Vol {booking.flight}</p>}
                  </div>
                  
                  <div>
                    <p className="text-slate-500 mb-1">Prix</p>
                    <p className="text-slate-900 font-medium text-lg">{booking.price}</p>
                  </div>
                </div>
                
                <div className="flex items-center justify-between pt-4 border-t border-slate-100">
                  <div className="flex space-x-4">
                    <button className="flex items-center space-x-2 text-blue-600 hover:text-blue-700 text-sm font-medium">
                      <Navigation className="w-4 h-4" />
                      <span>Suivre en temps réel</span>
                    </button>
                    <button className="flex items-center space-x-2 text-emerald-600 hover:text-emerald-700 text-sm font-medium">
                      <Phone className="w-4 h-4" />
                      <span>Contacter</span>
                    </button>
                  </div>
                  <p className="text-xs text-slate-500">Réf: {booking.id}</p>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Upcoming Activities */}
      <Card className="border border-slate-200">
        <CardContent className="p-6">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-xl font-medium text-slate-900">Activités à venir</h3>
            <Button 
              onClick={() => onNavigate('activities')}
              variant="outline" 
              size="sm"
            >
              Explorer plus
            </Button>
          </div>
          
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {upcomingActivities.map((activity) => (
              <div key={activity.id} className="border border-slate-200 rounded-lg p-4 hover:shadow-md transition-shadow">
                <div className="flex items-start justify-between mb-3">
                  <div className="flex items-center space-x-3">
                    <ServiceIcon type={activity.type} />
                    <div>
                      <h4 className="font-medium text-slate-900">{activity.name}</h4>
                      <p className="text-sm text-slate-600">{activity.location}</p>
                    </div>
                  </div>
                  <StatusBadge status={activity.status} />
                </div>
                
                <div className="flex items-center justify-between text-sm">
                  <div className="flex items-center space-x-4 text-slate-600">
                    <span className="flex items-center space-x-1">
                      <Calendar className="w-4 h-4" />
                      <span>{activity.date}</span>
                    </span>
                    <span className="flex items-center space-x-1">
                      <Clock className="w-4 h-4" />
                      <span>{activity.time}</span>
                    </span>
                  </div>
                  <p className="font-medium text-slate-900">{activity.price}</p>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Recent History */}
      <Card className="border border-slate-200">
        <CardContent className="p-6">
          <h3 className="text-xl font-medium text-slate-900 mb-6">Historique récent</h3>
          
          <div className="space-y-3">
            {recentHistory.map((item) => (
              <div key={item.id} className="flex items-center justify-between py-3 border-b border-slate-100 last:border-0">
                <div className="flex items-center space-x-4">
                  <CheckCircle className="w-5 h-5 text-green-600" />
                  <div>
                    <h4 className="font-medium text-slate-900">{item.service}</h4>
                    <p className="text-sm text-slate-600">{item.date}</p>
                  </div>
                </div>
                <div className="text-right">
                  <p className="font-medium text-slate-900">{item.price}</p>
                  <div className="flex items-center space-x-1">
                    {[...Array(item.rating)].map((_, i) => (
                      <Star key={i} className="w-3 h-3 text-amber-400 fill-current" />
                    ))}
                  </div>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>
    </div>
  );
}