'use client';

import React, { useState } from 'react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { 
  Search, 
  Filter,
  Calendar,
  Users,
  Phone,
  Mail,
  MapPin,
  Clock,
  CheckCircle,
  AlertCircle,
  Eye
} from 'lucide-react';

export default function ProviderBookingsPage() {
  const [searchQuery, setSearchQuery] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');

  const bookings = [
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
      specialRequests: "Champagne et roses pour anniversaire",
      bookingDate: "2024-12-10"
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
      specialRequests: "Régime végétarien pour 2 personnes",
      bookingDate: "2024-12-12"
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
      specialRequests: "Transfer depuis Nice inclus",
      bookingDate: "2024-12-08"
    },
    {
      id: "BK008",
      activity: "Yacht Party Monaco",
      client: "Marcus Williams",
      clientPhone: "+33 6 12 34 56 78",
      clientEmail: "marcus.w@example.com",
      date: "2024-12-15",
      time: "19:00",
      guests: 6,
      status: "completed",
      amount: 5100,
      currency: "€",
      specialRequests: "Musique live demandée",
      bookingDate: "2024-11-20"
    },
    {
      id: "BK009",
      activity: "Casino VIP Night",
      client: "Sofia Rodriguez",
      clientPhone: "+34 612 345 678",
      clientEmail: "sofia.r@example.com",
      date: "2024-12-10",
      time: "21:00",
      guests: 2,
      status: "cancelled",
      amount: 900,
      currency: "€",
      specialRequests: "Annulé pour raisons personnelles",
      bookingDate: "2024-11-15"
    }
  ];

  const statusOptions = [
    { value: 'all', label: 'Toutes', count: bookings.length },
    { value: 'pending', label: 'En attente', count: bookings.filter(b => b.status === 'pending').length },
    { value: 'confirmed', label: 'Confirmées', count: bookings.filter(b => b.status === 'confirmed').length },
    { value: 'completed', label: 'Terminées', count: bookings.filter(b => b.status === 'completed').length },
    { value: 'cancelled', label: 'Annulées', count: bookings.filter(b => b.status === 'cancelled').length }
  ];

  const filteredBookings = bookings.filter(booking => {
    const matchesSearch = 
      booking.client.toLowerCase().includes(searchQuery.toLowerCase()) ||
      booking.activity.toLowerCase().includes(searchQuery.toLowerCase()) ||
      booking.id.toLowerCase().includes(searchQuery.toLowerCase());
    
    const matchesStatus = statusFilter === 'all' || booking.status === statusFilter;
    
    return matchesSearch && matchesStatus;
  });

  const StatusBadge = ({ status }: { status: string }) => {
    const styles = {
      'confirmed': 'bg-green-100 text-green-800',
      'pending': 'bg-amber-100 text-amber-800',
      'cancelled': 'bg-red-100 text-red-800',
      'completed': 'bg-slate-100 text-slate-800'
    };
    
    const labels = {
      'confirmed': 'Confirmé',
      'pending': 'En attente',
      'cancelled': 'Annulé',
      'completed': 'Terminé'
    };
    
    return (
      <span className={`px-3 py-1 rounded-full text-xs font-medium ${styles[status as keyof typeof styles]}`}>
        {labels[status as keyof typeof labels]}
      </span>
    );
  };

  const handleStatusChange = (bookingId: string, newStatus: string) => {
    alert(`Réservation ${bookingId} marquée comme ${newStatus}`);
  };

  return (
    <div className="max-w-7xl mx-auto px-6 py-8 space-y-8">
      {/* Header */}
      <div>
        <h1 className="text-2xl font-light text-slate-900">Réservations</h1>
        <p className="text-slate-600">Gérez toutes les réservations de vos activités</p>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-amber-100 rounded-lg flex items-center justify-center">
                <Clock className="w-6 h-6 text-amber-600" />
              </div>
              <div>
                <p className="text-2xl font-light text-slate-900">
                  {bookings.filter(b => b.status === 'pending').length}
                </p>
                <p className="text-sm text-slate-600">En attente</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                <CheckCircle className="w-6 h-6 text-green-600" />
              </div>
              <div>
                <p className="text-2xl font-light text-slate-900">
                  {bookings.filter(b => b.status === 'confirmed').length}
                </p>
                <p className="text-sm text-slate-600">Confirmées</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                <Calendar className="w-6 h-6 text-blue-600" />
              </div>
              <div>
                <p className="text-2xl font-light text-slate-900">
                  {bookings.filter(b => b.status === 'completed').length}
                </p>
                <p className="text-sm text-slate-600">Terminées</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-emerald-100 rounded-lg flex items-center justify-center">
                <Users className="w-6 h-6 text-emerald-600" />
              </div>
              <div>
                <p className="text-2xl font-light text-slate-900">
                  {bookings.reduce((sum, b) => sum + b.guests, 0)}
                </p>
                <p className="text-sm text-slate-600">Total invités</p>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Filters */}
      <div className="flex flex-col md:flex-row gap-4 items-start md:items-center justify-between">
        {/* Search */}
        <div className="relative flex-1 max-w-md">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 text-slate-400" />
          <Input
            placeholder="Rechercher par client, activité ou référence..."
            className="pl-10"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>

        {/* Status Filter */}
        <div className="flex space-x-2">
          {statusOptions.map((option) => (
            <button
              key={option.value}
              onClick={() => setStatusFilter(option.value)}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                statusFilter === option.value
                  ? 'bg-emerald-600 text-white'
                  : 'bg-white text-slate-600 hover:bg-slate-50 border border-slate-200'
              }`}
            >
              {option.label} ({option.count})
            </button>
          ))}
        </div>
      </div>

      {/* Bookings List */}
      <Card className="border border-slate-200">
        <CardContent className="p-0">
          <div className="space-y-0">
            {filteredBookings.map((booking) => (
              <div key={booking.id} className="border-b border-slate-100 last:border-0 p-6 hover:bg-slate-50 transition-colors">
                <div className="flex items-start justify-between mb-4">
                  <div className="flex-1">
                    <div className="flex items-center space-x-4 mb-3">
                      <h3 className="text-lg font-medium text-slate-900">{booking.activity}</h3>
                      <StatusBadge status={booking.status} />
                      <span className="text-xs text-slate-500">Réf: {booking.id}</span>
                    </div>
                    
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                      {/* Client Info */}
                      <div>
                        <p className="text-sm text-slate-500 mb-2">Client</p>
                        <p className="font-medium text-slate-900">{booking.client}</p>
                        <div className="space-y-1 mt-2">
                          <div className="flex items-center space-x-2 text-sm text-slate-600">
                            <Phone className="w-3 h-3" />
                            <span>{booking.clientPhone}</span>
                          </div>
                          <div className="flex items-center space-x-2 text-sm text-slate-600">
                            <Mail className="w-3 h-3" />
                            <span>{booking.clientEmail}</span>
                          </div>
                        </div>
                      </div>

                      {/* Event Details */}
                      <div>
                        <p className="text-sm text-slate-500 mb-2">Détails de l'événement</p>
                        <div className="space-y-1">
                          <div className="flex items-center space-x-2 text-sm">
                            <Calendar className="w-3 h-3 text-slate-400" />
                            <span className="font-medium text-slate-900">{booking.date}</span>
                            <Clock className="w-3 h-3 text-slate-400 ml-2" />
                            <span className="text-slate-600">{booking.time}</span>
                          </div>
                          <div className="flex items-center space-x-2 text-sm text-slate-600">
                            <Users className="w-3 h-3" />
                            <span>{booking.guests} personne{booking.guests > 1 ? 's' : ''}</span>
                          </div>
                          <p className="text-xs text-slate-500">Réservé le {booking.bookingDate}</p>
                        </div>
                      </div>

                      {/* Financial Info */}
                      <div>
                        <p className="text-sm text-slate-500 mb-2">Montant</p>
                        <p className="text-xl font-medium text-slate-900">{booking.amount}{booking.currency}</p>
                        <p className="text-xs text-slate-500">Commission: {Math.round(booking.amount * 0.12)}{booking.currency}</p>
                      </div>
                    </div>

                    {/* Special Requests */}
                    {booking.specialRequests && (
                      <div className="mt-4 p-3 bg-slate-50 rounded-lg">
                        <p className="text-sm text-slate-500 mb-1">Demandes spéciales :</p>
                        <p className="text-sm text-slate-700">{booking.specialRequests}</p>
                      </div>
                    )}
                  </div>
                </div>

                {/* Actions */}
                <div className="flex items-center justify-between pt-4 border-t border-slate-100">
                  <div className="flex space-x-3">
                    {booking.status === 'pending' && (
                      <>
                        <Button 
                          size="sm" 
                          className="bg-green-600 hover:bg-green-700 text-white"
                          onClick={() => handleStatusChange(booking.id, 'confirmed')}
                        >
                          <CheckCircle className="w-4 h-4 mr-1" />
                          Confirmer
                        </Button>
                        <Button 
                          size="sm" 
                          variant="outline" 
                          className="text-red-600 border-red-200 hover:bg-red-50"
                          onClick={() => handleStatusChange(booking.id, 'cancelled')}
                        >
                          Refuser
                        </Button>
                      </>
                    )}
                    
                    {booking.status === 'confirmed' && (
                      <>
                        <Button size="sm" variant="outline">
                          <Phone className="w-4 h-4 mr-1" />
                          Contacter client
                        </Button>
                        <Button 
                          size="sm" 
                          className="bg-blue-600 hover:bg-blue-700 text-white"
                          onClick={() => handleStatusChange(booking.id, 'completed')}
                        >
                          Marquer terminé
                        </Button>
                      </>
                    )}

                    <Button size="sm" variant="outline">
                      <Eye className="w-4 h-4 mr-1" />
                      Détails
                    </Button>
                  </div>

                  <div className="text-xs text-slate-500">
                    Dernière mise à jour: aujourd'hui
                  </div>
                </div>
              </div>
            ))}
          </div>
        </CardContent>
      </Card>

      {/* Empty State */}
      {filteredBookings.length === 0 && (
        <div className="text-center py-12">
          <div className="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <Calendar className="w-8 h-8 text-slate-400" />
          </div>
          <h3 className="text-lg font-medium text-slate-900 mb-2">Aucune réservation trouvée</h3>
          <p className="text-slate-600 mb-6">
            {searchQuery || statusFilter !== 'all' 
              ? 'Essayez de modifier vos critères de recherche.'
              : 'Vos réservations apparaîtront ici une fois que les clients auront réservé vos activités.'
            }
          </p>
        </div>
      )}
    </div>
  );
}