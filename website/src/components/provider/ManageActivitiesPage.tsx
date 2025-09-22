'use client';

import React, { useState } from 'react';
import { 
  Plus, 
  Edit, 
  Trash2, 
  Eye, 
  Search,
  Filter,
  Calendar,
  Users,
  DollarSign,
  Star,
  Clock,
  MapPin,
  BarChart3,
  TrendingUp,
  Sparkles,
  Mountain,
  Plane,
  Hotel,
  ToggleLeft,
  ToggleRight,
  Camera,
  Copy,
  X
} from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';

interface ManageActivitiesPageProps {
  onNavigate: (section: string) => void;
}

export default function ManageActivitiesPage({ onNavigate }: ManageActivitiesPageProps) {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [selectedActivity, setSelectedActivity] = useState<any>(null);
  const [showDetailsModal, setShowDetailsModal] = useState(false);

  // Données simulées
  const activities = [
    {
      id: 1,
      title: 'Weekend Grand Prix Monaco',
      category: 'travel',
      description: 'Expérience VIP complète pour le Grand Prix de Monaco avec hébergement 5 étoiles',
      location: 'Monaco',
      price: 1250,
      currency: '€',
      duration: '3 jours',
      groupSize: { min: 1, max: 4 },
      status: 'active',
      visibility: true,
      bookings: 23,
      totalRevenue: 28750,
      rating: 4.8,
      reviews: 203,
      availability: 'Mai 2025',
      lastBooking: '2024-12-10',
      createdDate: '2024-01-15',
      features: ['Billets VIP', 'Hôtel 5*', 'Yacht party', 'Transfers privés'],
      images: 2
    },
    {
      id: 2,
      title: 'Yacht Party Monaco',
      category: 'travel', 
      description: 'Soirée exclusive sur yacht privé avec DJ et service premium',
      location: 'Monaco',
      price: 850,
      currency: '€',
      duration: '6 heures',
      groupSize: { min: 2, max: 12 },
      status: 'active',
      visibility: true,
      bookings: 15,
      totalRevenue: 12750,
      rating: 4.9,
      reviews: 87,
      availability: 'Disponible',
      lastBooking: '2024-12-08',
      createdDate: '2024-03-20',
      features: ['Yacht privé', 'DJ professionnel', 'Open bar', 'Catering premium'],
      images: 5
    },
    {
      id: 3,
      title: 'Casino VIP Night',
      category: 'travel',
      description: 'Soirée VIP au Casino de Monte-Carlo avec accès privilégié',
      location: 'Monaco',
      price: 450,
      currency: '€',
      duration: '4 heures',
      groupSize: { min: 1, max: 6 },
      status: 'paused',
      visibility: false,
      bookings: 8,
      totalRevenue: 3600,
      rating: 4.7,
      reviews: 34,
      availability: 'Suspendu',
      lastBooking: '2024-11-25',
      createdDate: '2023-09-10',
      features: ['Accès VIP', 'Champagne inclus', 'Guide privé', 'Transport inclus'],
      images: 3
    },
    {
      id: 4,
      title: 'Helicopter Tour Monaco',
      category: 'travel',
      description: 'Tour en hélicoptère de la Côte d\'Azur avec vue panoramique',
      location: 'Monaco',
      price: 320,
      currency: '€',
      duration: '45 minutes',
      groupSize: { min: 1, max: 3 },
      status: 'draft',
      visibility: false,
      bookings: 0,
      totalRevenue: 0,
      rating: 0,
      reviews: 0,
      availability: 'En préparation',
      lastBooking: null,
      createdDate: '2024-12-01',
      features: ['Hélicoptère privé', 'Pilote expérimenté', 'Photos incluses', 'Champagne à bord'],
      images: 1
    }
  ];

  const categories = [
    { id: 'all', name: 'Toutes', count: activities.length },
    { id: 'travel', name: 'Voyages', count: activities.filter(a => a.category === 'travel').length },
    { id: 'spa', name: 'Spa & Bien-être', count: 0 },
    { id: 'hotel', name: 'Hôtels', count: 0 }
  ];

  const filteredActivities = activities.filter(activity => {
    const matchesSearch = activity.title.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCategory = selectedCategory === 'all' || activity.category === selectedCategory;
    return matchesSearch && matchesCategory;
  });

  const StatusBadge = ({ status }: { status: string }) => {
    const styles = {
      'active': 'bg-green-100 text-green-800',
      'paused': 'bg-amber-100 text-amber-800',
      'draft': 'bg-slate-100 text-slate-800',
      'rejected': 'bg-red-100 text-red-800'
    };
    
    const labels = {
      'active': 'Actif',
      'paused': 'Suspendu',
      'draft': 'Brouillon',
      'rejected': 'Rejeté'
    };
    
    return (
      <span className={`px-3 py-1 rounded-full text-xs font-medium ${styles[status as keyof typeof styles]}`}>
        {labels[status as keyof typeof labels]}
      </span>
    );
  };

  const CategoryIcon = ({ category }: { category: string }) => {
    const icons = {
      'spa': Sparkles,
      'travel': Plane,
      'hotel': Hotel,
      'safari': Mountain
    };
    
    const IconComponent = icons[category as keyof typeof icons] || Plane;
    
    const colors = {
      'spa': 'text-pink-600',
      'travel': 'text-blue-600', 
      'hotel': 'text-purple-600',
      'safari': 'text-emerald-600'
    };
    
    return <IconComponent className={`w-5 h-5 ${colors[category as keyof typeof colors] || 'text-slate-600'}`} />;
  };

  const toggleActivityStatus = (activityId: number) => {
    const activity = activities.find(a => a.id === activityId);
    if (activity) {
      const newStatus = activity.status === 'active' ? 'paused' : 'active';
      alert(`Activité "${activity.title}" ${newStatus === 'active' ? 'activée' : 'suspendue'}`);
    }
  };

  const toggleVisibility = (activityId: number) => {
    const activity = activities.find(a => a.id === activityId);
    if (activity) {
      const newVisibility = !activity.visibility;
      alert(`Visibilité de "${activity.title}" ${newVisibility ? 'activée' : 'désactivée'}`);
    }
  };

  const duplicateActivity = (activityId: number) => {
    const activity = activities.find(a => a.id === activityId);
    if (activity) {
      alert(`Activité "${activity.title}" dupliquée avec succès !`);
    }
  };

  const deleteActivity = (activityId: number) => {
    const activity = activities.find(a => a.id === activityId);
    if (activity && confirm(`Êtes-vous sûr de vouloir supprimer "${activity.title}" ?`)) {
      alert('Activité supprimée');
    }
  };

  return (
    <div className="max-w-7xl mx-auto px-6 py-8 space-y-8">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-light text-slate-900">Mes activités</h1>
          <p className="text-slate-600">Gérez votre catalogue d'expériences et suivez leurs performances</p>
        </div>
        <Button 
          onClick={() => onNavigate('add-activity')}
          className="bg-gradient-to-r from-emerald-600 to-blue-600 hover:from-emerald-700 hover:to-blue-700 text-white"
        >
          <Plus className="w-4 h-4 mr-2" />
          Nouvelle activité
        </Button>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center">
                <BarChart3 className="w-6 h-6 text-blue-600" />
              </div>
              <div>
                <p className="text-2xl font-light text-slate-900">{activities.length}</p>
                <p className="text-sm text-slate-600">Total activités</p>
              </div>
            </div>
          </CardContent>
        </Card>
        
        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center">
                <TrendingUp className="w-6 h-6 text-green-600" />
              </div>
              <div>
                <p className="text-2xl font-light text-slate-900">{activities.filter(a => a.status === 'active').length}</p>
                <p className="text-sm text-slate-600">Activités actives</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-emerald-100 rounded-lg flex items-center justify-center">
                <DollarSign className="w-6 h-6 text-emerald-600" />
              </div>
              <div>
                <p className="text-2xl font-light text-slate-900">45,1K€</p>
                <p className="text-sm text-slate-600">Revenus totaux</p>
              </div>
            </div>
          </CardContent>
        </Card>

        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-amber-100 rounded-lg flex items-center justify-center">
                <Star className="w-6 h-6 text-amber-600" />
              </div>
              <div>
                <p className="text-2xl font-light text-slate-900">4.8</p>
                <p className="text-sm text-slate-600">Note moyenne</p>
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
            placeholder="Rechercher une activité..."
            className="pl-10"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>

        {/* Category Tabs */}
        <div className="flex space-x-2">
          {categories.map((category) => (
            <button
              key={category.id}
              onClick={() => setSelectedCategory(category.id)}
              className={`px-4 py-2 rounded-lg text-sm font-medium transition-all ${
                selectedCategory === category.id
                  ? 'bg-emerald-600 text-white'
                  : 'bg-white text-slate-600 hover:bg-slate-50 border border-slate-200'
              }`}
            >
              {category.name} ({category.count})
            </button>
          ))}
        </div>
      </div>

      {/* Activities Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 xl:grid-cols-3 gap-6">
        {filteredActivities.map((activity) => (
          <Card key={activity.id} className="border border-slate-200 hover:shadow-lg transition-shadow group">
            {/* Image Placeholder */}
            <div className="relative aspect-[4/3] bg-gradient-to-br from-slate-200 to-slate-300 rounded-t-lg overflow-hidden">
              <div className="absolute inset-0 flex items-center justify-center">
                <Camera className="w-12 h-12 text-slate-400" />
              </div>
              
              {/* Status Badge */}
              <div className="absolute top-4 left-4">
                <StatusBadge status={activity.status} />
              </div>

              {/* Actions Menu */}
              <div className="absolute top-4 right-4 flex space-x-2 opacity-0 group-hover:opacity-100 transition-opacity">
                <button 
                  onClick={() => toggleVisibility(activity.id)}
                  className="w-8 h-8 bg-white/80 rounded-full flex items-center justify-center hover:bg-white transition-colors"
                >
                  {activity.visibility ? <Eye className="w-4 h-4 text-slate-600" /> : <Eye className="w-4 h-4 text-slate-400" />}
                </button>
              </div>

              {/* Category Icon */}
              <div className="absolute bottom-4 left-4">
                <div className="w-8 h-8 bg-white/80 rounded-full flex items-center justify-center">
                  <CategoryIcon category={activity.category} />
                </div>
              </div>

              {/* Images Count */}
              {activity.images > 0 && (
                <div className="absolute bottom-4 right-4 bg-black/50 text-white px-2 py-1 rounded text-xs">
                  {activity.images} photo{activity.images > 1 ? 's' : ''}
                </div>
              )}
            </div>

            <CardContent className="p-6">
              <div className="space-y-4">
                {/* Header */}
                <div>
                  <h3 className="font-medium text-slate-900 line-clamp-1">{activity.title}</h3>
                  <div className="flex items-center justify-between mt-2">
                    <div className="flex items-center space-x-1 text-sm text-slate-600">
                      <MapPin className="w-3 h-3" />
                      <span>{activity.location}</span>
                    </div>
                    <div className="flex items-center space-x-1">
                      {activity.reviews > 0 ? (
                        <>
                          <Star className="w-3 h-3 text-amber-400 fill-current" />
                          <span className="text-sm text-slate-600">{activity.rating} ({activity.reviews})</span>
                        </>
                      ) : (
                        <span className="text-sm text-slate-500">Nouveau</span>
                      )}
                    </div>
                  </div>
                </div>

                {/* Performance Stats */}
                <div className="grid grid-cols-2 gap-4 py-3 border-t border-b border-slate-100">
                  <div className="text-center">
                    <p className="text-lg font-medium text-slate-900">{activity.bookings}</p>
                    <p className="text-xs text-slate-500">Réservations</p>
                  </div>
                  <div className="text-center">
                    <p className="text-lg font-medium text-emerald-600">{activity.totalRevenue.toLocaleString()}€</p>
                    <p className="text-xs text-slate-500">Revenus</p>
                  </div>
                </div>

                {/* Details */}
                <div className="space-y-2 text-sm text-slate-600">
                  <div className="flex items-center justify-between">
                    <span>Prix:</span>
                    <span className="font-medium text-slate-900">{activity.price}{activity.currency}</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span>Durée:</span>
                    <span>{activity.duration}</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span>Groupe:</span>
                    <span>{activity.groupSize.min}-{activity.groupSize.max} pers.</span>
                  </div>
                  <div className="flex items-center justify-between">
                    <span>Disponibilité:</span>
                    <span>{activity.availability}</span>
                  </div>
                </div>

                {/* Actions */}
                <div className="flex space-x-2 pt-4">
                  <Button 
                    variant="outline" 
                    size="sm" 
                    className="flex-1"
                    onClick={() => {
                      setSelectedActivity(activity);
                      setShowDetailsModal(true);
                    }}
                  >
                    <Eye className="w-3 h-3 mr-1" />
                    Voir
                  </Button>
                  <Button variant="outline" size="sm" className="flex-1">
                    <Edit className="w-3 h-3 mr-1" />
                    Modifier
                  </Button>
                  <Button 
                    variant="outline" 
                    size="sm"
                    onClick={() => toggleActivityStatus(activity.id)}
                  >
                    {activity.status === 'active' ? (
                      <ToggleRight className="w-4 h-4 text-green-600" />
                    ) : (
                      <ToggleLeft className="w-4 h-4 text-slate-400" />
                    )}
                  </Button>
                </div>

                {/* Secondary Actions */}
                <div className="flex justify-between text-xs">
                  <button 
                    onClick={() => duplicateActivity(activity.id)}
                    className="flex items-center space-x-1 text-slate-500 hover:text-slate-700 transition-colors"
                  >
                    <Copy className="w-3 h-3" />
                    <span>Dupliquer</span>
                  </button>
                  <button 
                    onClick={() => deleteActivity(activity.id)}
                    className="flex items-center space-x-1 text-red-500 hover:text-red-700 transition-colors"
                  >
                    <Trash2 className="w-3 h-3" />
                    <span>Supprimer</span>
                  </button>
                </div>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {/* Activity Details Modal */}
      {showDetailsModal && selectedActivity && (
        <div className="fixed inset-0 z-50 flex items-center justify-center">
          <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" onClick={() => setShowDetailsModal(false)} />
          <div className="relative bg-white rounded-2xl shadow-2xl w-full max-w-2xl mx-4 max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between p-6 border-b border-slate-200">
              <h2 className="text-xl font-medium text-slate-900">{selectedActivity.title}</h2>
              <button onClick={() => setShowDetailsModal(false)} className="p-2 hover:bg-slate-100 rounded-lg">
                <X className="w-5 h-5 text-slate-600" />
              </button>
            </div>
            
            <div className="p-6 space-y-6">
              {/* Performance Overview */}
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div className="text-center p-4 bg-slate-50 rounded-lg">
                  <p className="text-2xl font-medium text-slate-900">{selectedActivity.bookings}</p>
                  <p className="text-sm text-slate-600">Réservations</p>
                </div>
                <div className="text-center p-4 bg-emerald-50 rounded-lg">
                  <p className="text-2xl font-medium text-emerald-600">{selectedActivity.totalRevenue.toLocaleString()}€</p>
                  <p className="text-sm text-slate-600">Revenus</p>
                </div>
                <div className="text-center p-4 bg-amber-50 rounded-lg">
                  <p className="text-2xl font-medium text-amber-600">{selectedActivity.rating || 'N/A'}</p>
                  <p className="text-sm text-slate-600">Note moyenne</p>
                </div>
                <div className="text-center p-4 bg-blue-50 rounded-lg">
                  <p className="text-2xl font-medium text-blue-600">{selectedActivity.reviews}</p>
                  <p className="text-sm text-slate-600">Avis</p>
                </div>
              </div>

              {/* Activity Details */}
              <div className="space-y-4">
                <h3 className="font-medium text-slate-900">Détails de l'activité</h3>
                <div className="grid grid-cols-2 gap-4 text-sm">
                  <div>
                    <span className="text-slate-500">Prix:</span>
                    <p className="font-medium text-slate-900">{selectedActivity.price}{selectedActivity.currency} /personne</p>
                  </div>
                  <div>
                    <span className="text-slate-500">Durée:</span>
                    <p className="font-medium text-slate-900">{selectedActivity.duration}</p>
                  </div>
                  <div>
                    <span className="text-slate-500">Taille du groupe:</span>
                    <p className="font-medium text-slate-900">{selectedActivity.groupSize.min}-{selectedActivity.groupSize.max} personnes</p>
                  </div>
                  <div>
                    <span className="text-slate-500">Localisation:</span>
                    <p className="font-medium text-slate-900">{selectedActivity.location}</p>
                  </div>
                  <div>
                    <span className="text-slate-500">Disponibilité:</span>
                    <p className="font-medium text-slate-900">{selectedActivity.availability}</p>
                  </div>
                  <div>
                    <span className="text-slate-500">Dernière réservation:</span>
                    <p className="font-medium text-slate-900">{selectedActivity.lastBooking || 'Aucune'}</p>
                  </div>
                </div>
              </div>

              {/* Description */}
              <div>
                <h3 className="font-medium text-slate-900 mb-2">Description</h3>
                <p className="text-slate-700 leading-relaxed">{selectedActivity.description}</p>
              </div>

              {/* Features */}
              {selectedActivity.features && selectedActivity.features.length > 0 && (
                <div>
                  <h3 className="font-medium text-slate-900 mb-3">Caractéristiques incluses</h3>
                  <div className="flex flex-wrap gap-2">
                    {selectedActivity.features.map((feature: string, index: number) => (
                      <Badge key={index} variant="secondary" className="text-sm">
                        {feature}
                      </Badge>
                    ))}
                  </div>
                </div>
              )}
            </div>
            
            <div className="flex space-x-3 p-6 border-t border-slate-200">
              <Button variant="outline" onClick={() => setShowDetailsModal(false)} className="flex-1">
                Fermer
              </Button>
              <Button className="flex-1 bg-emerald-600 hover:bg-emerald-700 text-white">
                <Edit className="w-4 h-4 mr-2" />
                Modifier
              </Button>
            </div>
          </div>
        </div>
      )}

      {/* Empty State */}
      {filteredActivities.length === 0 && (
        <div className="text-center py-12">
          <div className="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <Plus className="w-8 h-8 text-slate-400" />
          </div>
          <h3 className="text-lg font-medium text-slate-900 mb-2">
            {searchQuery ? 'Aucune activité trouvée' : 'Aucune activité créée'}
          </h3>
          <p className="text-slate-600 mb-6 max-w-md mx-auto">
            {searchQuery 
              ? 'Essayez de modifier vos critères de recherche.'
              : 'Commencez par créer votre première expérience pour attirer des clients.'
            }
          </p>
          {!searchQuery && (
            <Button 
              onClick={() => onNavigate('add-activity')}
              className="bg-gradient-to-r from-emerald-600 to-blue-600 hover:from-emerald-700 hover:to-blue-700 text-white"
            >
              <Plus className="w-4 h-4 mr-2" />
              Créer ma première activité
            </Button>
          )}
        </div>
      )}
    </div>
  );
}