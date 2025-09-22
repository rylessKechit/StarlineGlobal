'use client';

import React, { useState } from 'react';
import { 
  Sparkles, 
  Mountain, 
  Plane, 
  Hotel, 
  Star, 
  MapPin, 
  Clock, 
  Users, 
  Filter,
  Search,
  Calendar,
  Heart,
  Share2,
  ChevronDown
} from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';

export default function ActivitiesPage() {
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [selectedLocation, setSelectedLocation] = useState('all');
  const [priceRange, setPriceRange] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');
  const [showFilters, setShowFilters] = useState(false);

  const categories = [
    { id: 'all', name: 'Toutes les activités', icon: Sparkles, count: 24 },
    { id: 'spa', name: 'Spa & Bien-être', icon: Sparkles, count: 8 },
    { id: 'safari', name: 'Safari & Nature', icon: Mountain, count: 6 },
    { id: 'travel', name: 'Voyages organisés', icon: Plane, count: 5 },
    { id: 'hotel', name: 'Hôtels de luxe', icon: Hotel, count: 5 }
  ];

  const activities = [
    {
      id: 1,
      category: 'spa',
      title: 'Spa Day au Ritz Paris',
      provider: 'The Ritz Paris',
      location: 'Paris, France',
      image: '/spa-ritz.jpg',
      rating: 4.9,
      reviews: 147,
      duration: '4 heures',
      groupSize: '1-2 personnes',
      price: 350,
      currency: '€',
      description: 'Journée détente complète au spa du prestigieux Ritz Paris avec soins premium et accès aux installations.',
      features: ['Massage 90min', 'Accès piscine', 'Champagne', 'Déjeuner inclus'],
      availability: 'Disponible aujourd\'hui',
      popular: true
    },
    {
      id: 2,
      category: 'safari',
      title: 'Safari privé au Kenya',
      provider: 'African Luxury Safaris',
      location: 'Masaï Mara, Kenya',
      image: '/safari-kenya.jpg',
      rating: 5.0,
      reviews: 89,
      duration: '3 jours',
      groupSize: '2-6 personnes',
      price: 2850,
      currency: '€',
      description: 'Safari exclusif de 3 jours dans la réserve du Masaï Mara avec guide privé et hébergement de luxe.',
      features: ['Guide privé', 'Hébergement 5*', 'Tous repas', 'Transfers inclus'],
      availability: 'Disponible en janvier',
      exclusive: true
    },
    {
      id: 3,
      category: 'travel',
      title: 'Weekend à Monaco Grand Prix',
      provider: 'Monaco VIP Experiences',
      location: 'Monaco',
      image: '/monaco-gp.jpg',
      rating: 4.8,
      reviews: 203,
      duration: '3 jours',
      groupSize: '1-4 personnes',
      price: 1250,
      currency: '€',
      description: 'Weekend VIP au Grand Prix de Monaco avec billets tribune, hôtel 5* et expériences exclusives.',
      features: ['Billets VIP', 'Hôtel 5*', 'Yacht party', 'Transfers privés'],
      availability: 'Mai 2025',
      popular: true
    },
    {
      id: 4,
      category: 'hotel',
      title: 'Suite Royal Savoy Londres',
      provider: 'The Savoy London',
      location: 'Londres, UK',
      image: '/savoy-suite.jpg',
      rating: 4.9,
      reviews: 324,
      duration: '2 nuits minimum',
      groupSize: '2 personnes',
      price: 980,
      currency: '£',
      description: 'Séjour d\'exception dans la suite royale du Savoy avec service de majordome et privilèges exclusifs.',
      features: ['Majordome 24/7', 'Vue Thames', 'Petit-déj. privé', 'Spa access'],
      availability: 'Disponible',
      popular: true
    },
    {
      id: 5,
      category: 'spa',
      title: 'Retraite Yoga Bali',
      provider: 'Bali Wellness Retreats',
      location: 'Ubud, Bali',
      image: '/yoga-bali.jpg',
      rating: 4.7,
      reviews: 156,
      duration: '7 jours',
      groupSize: '6-12 personnes',
      price: 1580,
      currency: '€',
      description: 'Retraite bien-être de 7 jours à Bali avec yoga quotidien, méditation et soins ayurvédiques.',
      features: ['Yoga 2x/jour', 'Méditation', 'Soins ayurvédiques', 'Cuisine bio'],
      availability: 'Mars 2025'
    },
    {
      id: 6,
      category: 'safari',
      title: 'Expédition Antarctique',
      provider: 'Polar Expeditions',
      location: 'Antarctique',
      image: '/antarctic.jpg',
      rating: 5.0,
      reviews: 67,
      duration: '12 jours',
      groupSize: '4-8 personnes',
      price: 8900,
      currency: '€',
      description: 'Expédition unique en Antarctique avec observation des baleines, pingouins et paysages glaciaires.',
      features: ['Yacht privé', 'Guide expert', 'Équipement fourni', 'Cuisine gastronomique'],
      availability: 'Décembre 2025',
      exclusive: true
    },
    {
      id: 7,
      category: 'travel',
      title: 'Tour gastronomique Tokyo',
      provider: 'Tokyo Culinary Masters',
      location: 'Tokyo, Japon',
      image: '/tokyo-food.jpg',
      rating: 4.9,
      reviews: 178,
      duration: '5 jours',
      groupSize: '2-4 personnes',
      price: 1890,
      currency: '€',
      description: 'Découverte culinaire de Tokyo avec chef privé, restaurants étoilés et cours de cuisine.',
      features: ['Chef privé', 'Restaurants Michelin', 'Cours cuisine', 'Marché Tsukiji'],
      availability: 'Disponible'
    },
    {
      id: 8,
      category: 'hotel',
      title: 'Villa privée Santorini',
      provider: 'Santorini Luxury Villas',
      location: 'Santorin, Grèce',
      image: '/santorini-villa.jpg',
      rating: 4.8,
      reviews: 89,
      duration: '4 nuits minimum',
      groupSize: '4-8 personnes',
      price: 750,
      currency: '€',
      description: 'Villa privée avec piscine infinity, vue mer exceptionnelle et service de conciergerie.',
      features: ['Piscine privée', 'Vue mer', 'Chef à domicile', 'Yacht disponible'],
      availability: 'Juin-Septembre'
    }
  ];

  const locations = [
    { id: 'all', name: 'Toutes destinations' },
    { id: 'paris', name: 'Paris' },
    { id: 'london', name: 'Londres' },
    { id: 'monaco', name: 'Monaco' },
    { id: 'international', name: 'International' }
  ];

  const priceRanges = [
    { id: 'all', name: 'Tous les prix' },
    { id: 'low', name: 'Moins de 500€' },
    { id: 'medium', name: '500€ - 1500€' },
    { id: 'high', name: '1500€ - 3000€' },
    { id: 'luxury', name: 'Plus de 3000€' }
  ];

  const filteredActivities = activities.filter(activity => {
    const matchesCategory = selectedCategory === 'all' || activity.category === selectedCategory;
    const matchesSearch = activity.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         activity.location.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesPrice = priceRange === 'all' ||
                        (priceRange === 'low' && activity.price < 500) ||
                        (priceRange === 'medium' && activity.price >= 500 && activity.price <= 1500) ||
                        (priceRange === 'high' && activity.price > 1500 && activity.price <= 3000) ||
                        (priceRange === 'luxury' && activity.price > 3000);
    
    return matchesCategory && matchesSearch && matchesPrice;
  });

  const ActivityCard = ({ activity }: { activity: any }) => (
    <Card className="border border-slate-200 hover:shadow-lg transition-all duration-300 group overflow-hidden">
      {/* Image */}
      <div className="relative aspect-[4/3] bg-gradient-to-br from-slate-200 to-slate-300 overflow-hidden">
        <div className="absolute inset-0 bg-gradient-to-t from-black/20 to-transparent" />
        
        {/* Badges */}
        <div className="absolute top-4 left-4 flex space-x-2">
          {activity.popular && (
            <Badge className="bg-amber-500 text-white">Populaire</Badge>
          )}
          {activity.exclusive && (
            <Badge className="bg-purple-600 text-white">Exclusif</Badge>
          )}
        </div>

        {/* Actions */}
        <div className="absolute top-4 right-4 flex space-x-2">
          <button className="w-8 h-8 bg-white/80 rounded-full flex items-center justify-center hover:bg-white transition-colors">
            <Heart className="w-4 h-4 text-slate-600" />
          </button>
          <button className="w-8 h-8 bg-white/80 rounded-full flex items-center justify-center hover:bg-white transition-colors">
            <Share2 className="w-4 h-4 text-slate-600" />
          </button>
        </div>

        {/* Category icon */}
        <div className="absolute bottom-4 left-4 w-10 h-10 bg-white rounded-full flex items-center justify-center">
          {activity.category === 'spa' && <Sparkles className="w-5 h-5 text-pink-600" />}
          {activity.category === 'safari' && <Mountain className="w-5 h-5 text-emerald-600" />}
          {activity.category === 'travel' && <Plane className="w-5 h-5 text-blue-600" />}
          {activity.category === 'hotel' && <Hotel className="w-5 h-5 text-purple-600" />}
        </div>
      </div>

      <CardContent className="p-6">
        {/* Header */}
        <div className="space-y-2 mb-4">
          <h3 className="font-medium text-slate-900 group-hover:text-blue-600 transition-colors line-clamp-1">
            {activity.title}
          </h3>
          <p className="text-sm text-slate-600">{activity.provider}</p>
          
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-1 text-sm text-slate-600">
              <MapPin className="w-4 h-4" />
              <span>{activity.location}</span>
            </div>
            <div className="flex items-center space-x-1">
              <Star className="w-4 h-4 text-amber-400 fill-current" />
              <span className="text-sm font-medium text-slate-900">{activity.rating}</span>
              <span className="text-sm text-slate-500">({activity.reviews})</span>
            </div>
          </div>
        </div>

        {/* Description */}
        <p className="text-sm text-slate-600 line-clamp-2 mb-4">
          {activity.description}
        </p>

        {/* Details */}
        <div className="grid grid-cols-2 gap-3 mb-4 text-xs text-slate-600">
          <div className="flex items-center space-x-1">
            <Clock className="w-3 h-3" />
            <span>{activity.duration}</span>
          </div>
          <div className="flex items-center space-x-1">
            <Users className="w-3 h-3" />
            <span>{activity.groupSize}</span>
          </div>
          <div className="col-span-2">
            <Calendar className="w-3 h-3 inline mr-1" />
            <span>{activity.availability}</span>
          </div>
        </div>

        {/* Features */}
        <div className="flex flex-wrap gap-1 mb-4">
          {activity.features.slice(0, 3).map((feature: string, index: number) => (
            <Badge key={index} variant="secondary" className="text-xs">
              {feature}
            </Badge>
          ))}
          {activity.features.length > 3 && (
            <Badge variant="secondary" className="text-xs">
              +{activity.features.length - 3}
            </Badge>
          )}
        </div>

        {/* Price & CTA */}
        <div className="flex items-center justify-between pt-4 border-t border-slate-100">
          <div>
            <span className="text-sm text-slate-500">À partir de</span>
            <div className="font-semibold text-slate-900 text-lg">
              {activity.price}{activity.currency}
              <span className="text-sm text-slate-500 font-normal"> /pers</span>
            </div>
          </div>
          <Button size="sm" className="bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white">
            Réserver
          </Button>
        </div>
      </CardContent>
    </Card>
  );

  return (
    <div className="max-w-7xl mx-auto px-6 py-8">
      {/* Header */}
      <div className="mb-8">
        <h1 className="text-3xl font-light text-slate-900 mb-4">
          Marketplace d'activités
        </h1>
        <p className="text-lg text-slate-600 max-w-3xl">
          Découvrez une sélection exclusive d'expériences premium proposées par nos partenaires 
          de confiance. De la détente aux aventures extraordinaires.
        </p>
      </div>

      {/* Search & Filters */}
      <div className="mb-8 space-y-4">
        {/* Search Bar */}
        <div className="relative">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-slate-400" />
          <Input
            placeholder="Rechercher une activité ou destination..."
            className="pl-10 h-12 text-base"
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>

        {/* Filter Toggle */}
        <div className="flex items-center justify-between">
          <div className="text-sm text-slate-600">
            {filteredActivities.length} activité{filteredActivities.length > 1 ? 's' : ''} trouvée{filteredActivities.length > 1 ? 's' : ''}
          </div>
          <Button
            variant="outline"
            size="sm"
            onClick={() => setShowFilters(!showFilters)}
            className="flex items-center space-x-2"
          >
            <Filter className="w-4 h-4" />
            <span>Filtres</span>
            <ChevronDown className={`w-4 h-4 transition-transform ${showFilters ? 'rotate-180' : ''}`} />
          </Button>
        </div>

        {/* Filters */}
        {showFilters && (
          <div className="bg-slate-50 rounded-lg p-6 space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">Catégorie</label>
                <select
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                  value={selectedCategory}
                  onChange={(e) => setSelectedCategory(e.target.value)}
                >
                  {categories.map(cat => (
                    <option key={cat.id} value={cat.id}>{cat.name} ({cat.count})</option>
                  ))}
                </select>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">Lieu</label>
                <select
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                  value={selectedLocation}
                  onChange={(e) => setSelectedLocation(e.target.value)}
                >
                  {locations.map(loc => (
                    <option key={loc.id} value={loc.id}>{loc.name}</option>
                  ))}
                </select>
              </div>
              
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">Prix</label>
                <select
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                  value={priceRange}
                  onChange={(e) => setPriceRange(e.target.value)}
                >
                  {priceRanges.map(range => (
                    <option key={range.id} value={range.id}>{range.name}</option>
                  ))}
                </select>
              </div>
            </div>
          </div>
        )}
      </div>

      {/* Category Tabs */}
      <div className="mb-8 overflow-x-auto">
        <div className="flex space-x-2 min-w-max">
          {categories.map((category) => {
            const IconComponent = category.icon;
            return (
              <button
                key={category.id}
                onClick={() => setSelectedCategory(category.id)}
                className={`flex items-center space-x-2 px-4 py-3 rounded-lg text-sm font-medium transition-all whitespace-nowrap ${
                  selectedCategory === category.id
                    ? 'bg-blue-600 text-white'
                    : 'bg-white text-slate-600 hover:bg-slate-50 border border-slate-200'
                }`}
              >
                <IconComponent className="w-4 h-4" />
                <span>{category.name}</span>
                <span className={`px-2 py-0.5 rounded-full text-xs ${
                  selectedCategory === category.id
                    ? 'bg-blue-500 text-white'
                    : 'bg-slate-200 text-slate-600'
                }`}>
                  {category.count}
                </span>
              </button>
            );
          })}
        </div>
      </div>

      {/* Activities Grid */}
      {filteredActivities.length > 0 ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-12">
          {filteredActivities.map((activity) => (
            <ActivityCard key={activity.id} activity={activity} />
          ))}
        </div>
      ) : (
        <div className="text-center py-12">
          <div className="w-16 h-16 bg-slate-100 rounded-full flex items-center justify-center mx-auto mb-4">
            <Search className="w-8 h-8 text-slate-400" />
          </div>
          <h3 className="text-lg font-medium text-slate-900 mb-2">Aucune activité trouvée</h3>
          <p className="text-slate-600 mb-4">
            Essayez de modifier vos critères de recherche ou de navigation.
          </p>
          <Button
            variant="outline"
            onClick={() => {
              setSelectedCategory('all');
              setSearchQuery('');
              setPriceRange('all');
            }}
          >
            Réinitialiser les filtres
          </Button>
        </div>
      )}

      {/* Call to Action */}
      <div className="bg-gradient-to-r from-blue-600 to-purple-600 rounded-xl p-8 text-white text-center">
        <h3 className="text-2xl font-light mb-4">
          Besoin d'une expérience sur mesure ?
        </h3>
        <p className="text-blue-100 mb-6 max-w-2xl mx-auto">
          Nos experts peuvent créer une expérience entièrement personnalisée selon vos goûts, 
          votre budget et vos disponibilités.
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Button variant="outline" className="border-white text-white hover:bg-white hover:text-blue-600">
            Demande personnalisée
          </Button>
          <Button variant="outline" className="border-white text-white hover:bg-white hover:text-blue-600">
            Parler à un expert
          </Button>
        </div>
      </div>
    </div>
  );
}