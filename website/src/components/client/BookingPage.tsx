'use client';

import React, { useState } from 'react';
import { 
  Car, 
  User, 
  Plane, 
  Calendar, 
  Clock, 
  MapPin, 
  Phone,
  ArrowRight,
  Users,
  Star,
  CreditCard,
  ChevronLeft
} from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

export default function BookingPage() {
  const [activeService, setActiveService] = useState<string | null>(null);
  const [bookingStep, setBookingStep] = useState(1);
  const [bookingData, setBookingData] = useState({
    service: '',
    from: '',
    to: '',
    date: '',
    time: '',
    passengers: 1,
    vehicleType: '',
    flightNumber: '',
    specialRequests: '',
    contactName: '',
    contactPhone: ''
  });

  const services = [
    {
      id: 'transport',
      name: 'Chauffeur privé',
      icon: Car,
      color: 'bg-blue-600',
      colorLight: 'bg-blue-50',
      colorText: 'text-blue-600',
      description: 'Transport avec chauffeur professionnel et véhicule premium',
      startingPrice: '45€',
      features: ['Véhicules premium', 'Chauffeurs expérimentés', 'Suivi temps réel', 'Wi-Fi gratuit']
    },
    {
      id: 'meet-greet',
      name: 'Meet & Greet',
      icon: User,
      color: 'bg-emerald-600',
      colorLight: 'bg-emerald-50',
      colorText: 'text-emerald-600',
      description: 'Service d\'accueil personnalisé en aéroport, gare ou lieu de rendez-vous',
      startingPrice: '65£',
      features: ['Accueil personnalisé', 'Assistance bagages', 'Panneau nominatif', 'Suivi vol/train']
    },
    {
      id: 'flight',
      name: 'Réservation vols',
      icon: Plane,
      color: 'bg-purple-600',
      colorLight: 'bg-purple-50',
      colorText: 'text-purple-600',
      description: 'Recherche et réservation de vols avec assistance complète',
      startingPrice: 'Sur devis',
      features: ['Vols premium', 'Assistance complète', 'Modification gratuite', 'Assurance voyage']
    }
  ];

  const vehicleTypes = [
    { id: 'sedan', name: 'Berline', passengers: '1-3', price: '+0€', description: 'Mercedes Classe E, BMW Série 5' },
    { id: 'luxury', name: 'Luxe', passengers: '1-3', price: '+25€', description: 'Mercedes Classe S, BMW Série 7' },
    { id: 'van', name: 'Van', passengers: '4-7', price: '+40€', description: 'Mercedes Viano, BMW X7' },
    { id: 'premium-van', name: 'Van Luxe', passengers: '4-7', price: '+65€', description: 'Mercedes V-Class, Range Rover' }
  ];

  const availableDrivers = [
    { id: 'marcus', name: 'Marcus W.', rating: 4.9, trips: 1247, languages: ['FR', 'EN'], specialty: 'Aéroports' },
    { id: 'jean-luc', name: 'Jean-Luc M.', rating: 4.8, trips: 892, languages: ['FR', 'EN', 'IT'], specialty: 'Événements' },
    { id: 'david', name: 'David K.', rating: 5.0, trips: 534, languages: ['EN', 'DE'], specialty: 'Corporate' }
  ];

  const handleServiceSelect = (serviceId: string) => {
    setActiveService(serviceId);
    setBookingData({ ...bookingData, service: serviceId });
    setBookingStep(2);
  };

  const handleNext = () => {
    if (bookingStep < 4) {
      setBookingStep(bookingStep + 1);
    }
  };

  const handleBack = () => {
    if (bookingStep > 1) {
      setBookingStep(bookingStep - 1);
    } else {
      setActiveService(null);
    }
  };

  const handleConfirmBooking = () => {
    alert('Réservation confirmée ! Vous recevrez un SMS de confirmation dans quelques minutes.');
    setActiveService(null);
    setBookingStep(1);
    setBookingData({
      service: '',
      from: '',
      to: '',
      date: '',
      time: '',
      passengers: 1,
      vehicleType: '',
      flightNumber: '',
      specialRequests: '',
      contactName: '',
      contactPhone: ''
    });
  };

  if (activeService) {
    const currentService = services.find(s => s.id === activeService);
    if (!currentService) return null;

    return (
      <div className="max-w-4xl mx-auto px-6 py-8">
        {/* Header avec retour */}
        <div className="flex items-center space-x-4 mb-8">
          <button 
            onClick={handleBack}
            className="flex items-center space-x-2 text-slate-600 hover:text-slate-900 transition-colors"
          >
            <ChevronLeft className="w-5 h-5" />
            <span>Retour</span>
          </button>
          <div className="flex-1">
            <h1 className="text-2xl font-light text-slate-900">{currentService.name}</h1>
            <p className="text-slate-600">{currentService.description}</p>
          </div>
        </div>

        {/* Progress Steps */}
        <div className="flex items-center justify-center mb-8">
          {[1, 2, 3, 4].map((step) => (
            <div key={step} className="flex items-center">
              <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium ${
                step <= bookingStep 
                  ? `${currentService.color} text-white` 
                  : 'bg-slate-200 text-slate-600'
              }`}>
                {step}
              </div>
              {step < 4 && (
                <div className={`w-16 h-px ${
                  step < bookingStep ? currentService.color.replace('bg-', 'bg-') : 'bg-slate-200'
                }`} />
              )}
            </div>
          ))}
        </div>

        {/* Step Content */}
        <Card className="border border-slate-200">
          <CardContent className="p-8">
            {/* Étape 1: Détails du service */}
            {bookingStep === 1 && (
              <div className="space-y-6">
                <h3 className="text-xl font-medium text-slate-900">Détails de la réservation</h3>
                
                {activeService === 'transport' && (
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <label className="block text-sm font-medium text-slate-700 mb-2">Point de départ</label>
                      <div className="relative">
                        <MapPin className="absolute left-3 top-3 w-4 h-4 text-slate-400" />
                        <Input
                          className="pl-10"
                          placeholder="Adresse de départ"
                          value={bookingData.from}
                          onChange={(e) => setBookingData({...bookingData, from: e.target.value})}
                        />
                      </div>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-slate-700 mb-2">Destination</label>
                      <div className="relative">
                        <MapPin className="absolute left-3 top-3 w-4 h-4 text-slate-400" />
                        <Input
                          className="pl-10"
                          placeholder="Adresse d'arrivée"
                          value={bookingData.to}
                          onChange={(e) => setBookingData({...bookingData, to: e.target.value})}
                        />
                      </div>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-slate-700 mb-2">Date</label>
                      <div className="relative">
                        <Calendar className="absolute left-3 top-3 w-4 h-4 text-slate-400" />
                        <Input
                          type="date"
                          className="pl-10"
                          value={bookingData.date}
                          onChange={(e) => setBookingData({...bookingData, date: e.target.value})}
                        />
                      </div>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-slate-700 mb-2">Heure</label>
                      <div className="relative">
                        <Clock className="absolute left-3 top-3 w-4 h-4 text-slate-400" />
                        <Input
                          type="time"
                          className="pl-10"
                          value={bookingData.time}
                          onChange={(e) => setBookingData({...bookingData, time: e.target.value})}
                        />
                      </div>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-slate-700 mb-2">Passagers</label>
                      <select 
                        className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                        value={bookingData.passengers}
                        onChange={(e) => setBookingData({...bookingData, passengers: parseInt(e.target.value)})}
                      >
                        {[1,2,3,4,5,6,7,8].map(num => (
                          <option key={num} value={num}>{num} passager{num > 1 ? 's' : ''}</option>
                        ))}
                      </select>
                    </div>
                  </div>
                )}

                {activeService === 'meet-greet' && (
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div>
                      <label className="block text-sm font-medium text-slate-700 mb-2">Lieu de rendez-vous</label>
                      <div className="relative">
                        <MapPin className="absolute left-3 top-3 w-4 h-4 text-slate-400" />
                        <Input
                          className="pl-10"
                          placeholder="Aéroport, gare, hôtel..."
                          value={bookingData.from}
                          onChange={(e) => setBookingData({...bookingData, from: e.target.value})}
                        />
                      </div>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-slate-700 mb-2">Numéro de vol/train</label>
                      <div className="relative">
                        <Plane className="absolute left-3 top-3 w-4 h-4 text-slate-400" />
                        <Input
                          className="pl-10"
                          placeholder="BA 315, TGV 2344..."
                          value={bookingData.flightNumber}
                          onChange={(e) => setBookingData({...bookingData, flightNumber: e.target.value})}
                        />
                      </div>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-slate-700 mb-2">Date d'arrivée</label>
                      <div className="relative">
                        <Calendar className="absolute left-3 top-3 w-4 h-4 text-slate-400" />
                        <Input
                          type="date"
                          className="pl-10"
                          value={bookingData.date}
                          onChange={(e) => setBookingData({...bookingData, date: e.target.value})}
                        />
                      </div>
                    </div>
                    <div>
                      <label className="block text-sm font-medium text-slate-700 mb-2">Heure d'arrivée</label>
                      <div className="relative">
                        <Clock className="absolute left-3 top-3 w-4 h-4 text-slate-400" />
                        <Input
                          type="time"
                          className="pl-10"
                          value={bookingData.time}
                          onChange={(e) => setBookingData({...bookingData, time: e.target.value})}
                        />
                      </div>
                    </div>
                    <div className="md:col-span-2">
                      <label className="block text-sm font-medium text-slate-700 mb-2">Nom à afficher sur le panneau</label>
                      <Input
                        placeholder="Nom du passager"
                        value={bookingData.contactName}
                        onChange={(e) => setBookingData({...bookingData, contactName: e.target.value})}
                      />
                    </div>
                  </div>
                )}

                {activeService === 'flight' && (
                  <div className="space-y-6">
                    <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                      <div>
                        <label className="block text-sm font-medium text-slate-700 mb-2">Ville de départ</label>
                        <Input
                          placeholder="Paris, Londres, New York..."
                          value={bookingData.from}
                          onChange={(e) => setBookingData({...bookingData, from: e.target.value})}
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-slate-700 mb-2">Destination</label>
                        <Input
                          placeholder="Ville de destination"
                          value={bookingData.to}
                          onChange={(e) => setBookingData({...bookingData, to: e.target.value})}
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-slate-700 mb-2">Date de départ</label>
                        <Input
                          type="date"
                          value={bookingData.date}
                          onChange={(e) => setBookingData({...bookingData, date: e.target.value})}
                        />
                      </div>
                      <div>
                        <label className="block text-sm font-medium text-slate-700 mb-2">Passagers</label>
                        <select 
                          className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                          value={bookingData.passengers}
                          onChange={(e) => setBookingData({...bookingData, passengers: parseInt(e.target.value)})}
                        >
                          {[1,2,3,4,5,6,7,8].map(num => (
                            <option key={num} value={num}>{num} passager{num > 1 ? 's' : ''}</option>
                          ))}
                        </select>
                      </div>
                    </div>
                    
                    <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                      <button className="p-4 border-2 border-blue-500 bg-blue-50 rounded-lg text-left">
                        <h4 className="font-medium text-blue-900">Économique</h4>
                        <p className="text-sm text-blue-700">Vols standards, bon rapport qualité/prix</p>
                      </button>
                      <button className="p-4 border-2 border-slate-200 rounded-lg text-left hover:border-purple-500 hover:bg-purple-50">
                        <h4 className="font-medium text-slate-900">Premium</h4>
                        <p className="text-sm text-slate-600">Plus de confort et services</p>
                      </button>
                      <button className="p-4 border-2 border-slate-200 rounded-lg text-left hover:border-amber-500 hover:bg-amber-50">
                        <h4 className="font-medium text-slate-900">Business</h4>
                        <p className="text-sm text-slate-600">Expérience luxe complète</p>
                      </button>
                    </div>
                  </div>
                )}

                <Button onClick={handleNext} className={`${currentService.color} hover:${currentService.color.replace('600', '700')} text-white w-full md:w-auto`}>
                  Continuer <ArrowRight className="ml-2 w-4 h-4" />
                </Button>
              </div>
            )}

            {/* Étape 2: Choix du véhicule (pour transport) ou prestataire */}
            {bookingStep === 2 && activeService === 'transport' && (
              <div className="space-y-6">
                <h3 className="text-xl font-medium text-slate-900">Choisir le véhicule</h3>
                
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  {vehicleTypes.map((vehicle) => (
                    <button
                      key={vehicle.id}
                      onClick={() => setBookingData({...bookingData, vehicleType: vehicle.id})}
                      className={`p-4 border-2 rounded-lg text-left transition-all ${
                        bookingData.vehicleType === vehicle.id
                          ? 'border-blue-500 bg-blue-50'
                          : 'border-slate-200 hover:border-slate-300'
                      }`}
                    >
                      <div className="flex items-center justify-between mb-2">
                        <h4 className="font-medium text-slate-900">{vehicle.name}</h4>
                        <span className="text-sm font-medium text-slate-900">{vehicle.price}</span>
                      </div>
                      <p className="text-sm text-slate-600 mb-2">{vehicle.description}</p>
                      <div className="flex items-center space-x-2">
                        <Users className="w-4 h-4 text-slate-400" />
                        <span className="text-sm text-slate-600">{vehicle.passengers} passagers</span>
                      </div>
                    </button>
                  ))}
                </div>
                
                <div className="flex space-x-4">
                  <Button variant="outline" onClick={handleBack}>
                    Retour
                  </Button>
                  <Button 
                    onClick={handleNext} 
                    className={`${currentService.color} hover:${currentService.color.replace('600', '700')} text-white`}
                    disabled={!bookingData.vehicleType}
                  >
                    Continuer <ArrowRight className="ml-2 w-4 h-4" />
                  </Button>
                </div>
              </div>
            )}

            {/* Étape 2 alternative pour meet-greet et flight */}
            {bookingStep === 2 && (activeService === 'meet-greet' || activeService === 'flight') && (
              <div className="space-y-6">
                <h3 className="text-xl font-medium text-slate-900">
                  {activeService === 'meet-greet' ? 'Choisir votre hôte' : 'Préférences de vol'}
                </h3>
                
                {activeService === 'meet-greet' && (
                  <div className="space-y-4">
                    {availableDrivers.map((host) => (
                      <div key={host.id} className="border border-slate-200 rounded-lg p-4 hover:shadow-md transition-shadow cursor-pointer">
                        <div className="flex items-center justify-between">
                          <div className="flex items-center space-x-4">
                            <div className="w-12 h-12 bg-emerald-600 rounded-full flex items-center justify-center">
                              <span className="text-white font-medium">{host.name.split(' ').map(n => n[0]).join('')}</span>
                            </div>
                            <div>
                              <h4 className="font-medium text-slate-900">{host.name}</h4>
                              <div className="flex items-center space-x-3 text-sm text-slate-600">
                                <span className="flex items-center space-x-1">
                                  <Star className="w-4 h-4 text-amber-400 fill-current" />
                                  <span>{host.rating}</span>
                                </span>
                                <span>{host.trips} missions</span>
                                <span>{host.languages.join(', ')}</span>
                              </div>
                              <p className="text-sm text-slate-600">Spécialité: {host.specialty}</p>
                            </div>
                          </div>
                          <Button size="sm" variant="outline">Choisir</Button>
                        </div>
                      </div>
                    ))}
                  </div>
                )}

                {activeService === 'flight' && (
                  <div className="space-y-4">
                    <div className="bg-slate-50 rounded-lg p-4">
                      <h4 className="font-medium text-slate-900 mb-2">Vos préférences</h4>
                      <div className="space-y-3">
                        <label className="flex items-center space-x-2">
                          <input type="checkbox" className="rounded" />
                          <span className="text-sm text-slate-700">Vol direct préféré</span>
                        </label>
                        <label className="flex items-center space-x-2">
                          <input type="checkbox" className="rounded" />
                          <span className="text-sm text-slate-700">Bagage en soute inclus</span>
                        </label>
                        <label className="flex items-center space-x-2">
                          <input type="checkbox" className="rounded" />
                          <span className="text-sm text-slate-700">Siège préférentiel</span>
                        </label>
                        <label className="flex items-center space-x-2">
                          <input type="checkbox" className="rounded" />
                          <span className="text-sm text-slate-700">Assurance annulation</span>
                        </label>
                      </div>
                    </div>
                  </div>
                )}
                
                <div className="flex space-x-4">
                  <Button variant="outline" onClick={handleBack}>
                    Retour
                  </Button>
                  <Button onClick={handleNext} className={`${currentService.color} hover:${currentService.color.replace('600', '700')} text-white`}>
                    Continuer <ArrowRight className="ml-2 w-4 h-4" />
                  </Button>
                </div>
              </div>
            )}

            {/* Étape 3: Informations de contact */}
            {bookingStep === 3 && (
              <div className="space-y-6">
                <h3 className="text-xl font-medium text-slate-900">Informations de contact</h3>
                
                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Nom complet</label>
                    <Input
                      placeholder="Votre nom complet"
                      value={bookingData.contactName}
                      onChange={(e) => setBookingData({...bookingData, contactName: e.target.value})}
                    />
                  </div>
                  <div>
                    <label className="block text-sm font-medium text-slate-700 mb-2">Téléphone</label>
                    <div className="relative">
                      <Phone className="absolute left-3 top-3 w-4 h-4 text-slate-400" />
                      <Input
                        className="pl-10"
                        placeholder="+33 6 12 34 56 78"
                        value={bookingData.contactPhone}
                        onChange={(e) => setBookingData({...bookingData, contactPhone: e.target.value})}
                      />
                    </div>
                  </div>
                </div>
                
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">Demandes spéciales (optionnel)</label>
                  <textarea
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg resize-none"
                    rows={4}
                    placeholder="Informations complémentaires, besoins spéciaux..."
                    value={bookingData.specialRequests}
                    onChange={(e) => setBookingData({...bookingData, specialRequests: e.target.value})}
                  />
                </div>
                
                <div className="flex space-x-4">
                  <Button variant="outline" onClick={handleBack}>
                    Retour
                  </Button>
                  <Button 
                    onClick={handleNext} 
                    className={`${currentService.color} hover:${currentService.color.replace('600', '700')} text-white`}
                    disabled={!bookingData.contactName || !bookingData.contactPhone}
                  >
                    Continuer <ArrowRight className="ml-2 w-4 h-4" />
                  </Button>
                </div>
              </div>
            )}

            {/* Étape 4: Confirmation et paiement */}
            {bookingStep === 4 && (
              <div className="space-y-6">
                <h3 className="text-xl font-medium text-slate-900">Confirmation de la réservation</h3>
                
                {/* Résumé de la réservation */}
                <div className="bg-slate-50 rounded-lg p-6 space-y-4">
                  <div className="flex items-center space-x-3">
                    <currentService.icon className={`w-6 h-6 ${currentService.colorText}`} />
                    <h4 className="font-medium text-slate-900">{currentService.name}</h4>
                  </div>
                  
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
                    {activeService === 'transport' && (
                      <>
                        <div>
                          <span className="text-slate-500">Trajet:</span>
                          <p className="font-medium text-slate-900">{bookingData.from} → {bookingData.to}</p>
                        </div>
                        <div>
                          <span className="text-slate-500">Véhicule:</span>
                          <p className="font-medium text-slate-900">
                            {vehicleTypes.find(v => v.id === bookingData.vehicleType)?.name || 'Non sélectionné'}
                          </p>
                        </div>
                      </>
                    )}
                    
                    {activeService === 'meet-greet' && (
                      <>
                        <div>
                          <span className="text-slate-500">Lieu:</span>
                          <p className="font-medium text-slate-900">{bookingData.from}</p>
                        </div>
                        <div>
                          <span className="text-slate-500">Vol/Train:</span>
                          <p className="font-medium text-slate-900">{bookingData.flightNumber}</p>
                        </div>
                      </>
                    )}
                    
                    <div>
                      <span className="text-slate-500">Date:</span>
                      <p className="font-medium text-slate-900">{bookingData.date}</p>
                    </div>
                    <div>
                      <span className="text-slate-500">Heure:</span>
                      <p className="font-medium text-slate-900">{bookingData.time}</p>
                    </div>
                    <div>
                      <span className="text-slate-500">Contact:</span>
                      <p className="font-medium text-slate-900">{bookingData.contactName}</p>
                      <p className="text-slate-600">{bookingData.contactPhone}</p>
                    </div>
                  </div>
                </div>

                {/* Prix estimé */}
                <div className="border border-slate-200 rounded-lg p-6">
                  <h4 className="font-medium text-slate-900 mb-4">Détail du prix</h4>
                  <div className="space-y-2 text-sm">
                    <div className="flex justify-between">
                      <span>Service de base</span>
                      <span>{currentService.startingPrice}</span>
                    </div>
                    {activeService === 'transport' && bookingData.vehicleType && (
                      <div className="flex justify-between">
                        <span>Supplément véhicule</span>
                        <span>{vehicleTypes.find(v => v.id === bookingData.vehicleType)?.price}</span>
                      </div>
                    )}
                    <div className="flex justify-between border-t border-slate-200 pt-2 font-medium">
                      <span>Total estimé</span>
                      <span>85€</span>
                    </div>
                  </div>
                </div>

                {/* Conditions */}
                <div className="bg-blue-50 rounded-lg p-4">
                  <h4 className="font-medium text-blue-900 mb-2">Conditions</h4>
                  <ul className="text-sm text-blue-800 space-y-1">
                    <li>• Confirmation par SMS dans les 15 minutes</li>
                    <li>• Modification gratuite jusqu'à 2h avant</li>
                    <li>• Annulation gratuite jusqu'à 24h avant</li>
                    <li>• Paiement sécurisé par carte bancaire</li>
                  </ul>
                </div>

                {/* Boutons de confirmation */}
                <div className="flex space-x-4">
                  <Button variant="outline" onClick={handleBack}>
                    Retour
                  </Button>
                  <Button 
                    onClick={handleConfirmBooking}
                    className={`${currentService.color} hover:${currentService.color.replace('600', '700')} text-white flex-1 md:flex-none`}
                  >
                    <CreditCard className="mr-2 w-4 h-4" />
                    Confirmer et payer
                  </Button>
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    );
  }

  // Vue principale - sélection de service
  return (
    <div className="max-w-6xl mx-auto px-6 py-8">
      <div className="text-center mb-12">
        <h1 className="text-3xl font-light text-slate-900 mb-4">
          Réserver un service
        </h1>
        <p className="text-lg text-slate-600 max-w-2xl mx-auto">
          Choisissez le service dont vous avez besoin. Nos experts s'occupent de tout 
          pour vous offrir une expérience exceptionnelle.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
        {services.map((service) => {
          const IconComponent = service.icon;
          return (
            <Card 
              key={service.id}
              className="border border-slate-200 hover:shadow-xl transition-all duration-300 cursor-pointer group"
              onClick={() => handleServiceSelect(service.id)}
            >
              <CardContent className="p-8">
                <div className="text-center space-y-6">
                  {/* Icon */}
                  <div className={`w-16 h-16 ${service.colorLight} rounded-2xl flex items-center justify-center mx-auto group-hover:scale-110 transition-transform`}>
                    <IconComponent className={`w-8 h-8 ${service.colorText}`} />
                  </div>

                  {/* Title & Description */}
                  <div>
                    <h3 className="text-xl font-medium text-slate-900 mb-2">
                      {service.name}
                    </h3>
                    <p className="text-slate-600 leading-relaxed">
                      {service.description}
                    </p>
                  </div>

                  {/* Features */}
                  <div className="space-y-2">
                    {service.features.map((feature, index) => (
                      <div key={index} className="flex items-center space-x-2 text-sm text-slate-600">
                        <div className={`w-1.5 h-1.5 ${service.color} rounded-full`} />
                        <span>{feature}</span>
                      </div>
                    ))}
                  </div>

                  {/* Price */}
                  <div className="pt-4 border-t border-slate-100">
                    <div className="flex items-center justify-between">
                      <span className="text-sm text-slate-500">À partir de</span>
                      <span className="text-lg font-medium text-slate-900">
                        {service.startingPrice}
                      </span>
                    </div>
                  </div>

                  {/* CTA Button */}
                  <Button 
                    className={`w-full ${service.color} hover:${service.color.replace('600', '700')} text-white group-hover:scale-105 transition-all`}
                  >
                    Réserver maintenant
                    <ArrowRight className="ml-2 w-4 h-4" />
                  </Button>
                </div>
              </CardContent>
            </Card>
          );
        })}
      </div>

      {/* Section information supplémentaire */}
      <div className="mt-16 grid grid-cols-1 md:grid-cols-3 gap-8">
        <Card className="border border-slate-200">
          <CardContent className="p-6 text-center">
            <div className="w-12 h-12 bg-green-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <Clock className="w-6 h-6 text-green-600" />
            </div>
            <h4 className="font-medium text-slate-900 mb-2">Réservation rapide</h4>
            <p className="text-sm text-slate-600">
              Confirmation en moins de 15 minutes avec tous les détails de votre service.
            </p>
          </CardContent>
        </Card>

        <Card className="border border-slate-200">
          <CardContent className="p-6 text-center">
            <div className="w-12 h-12 bg-blue-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <Phone className="w-6 h-6 text-blue-600" />
            </div>
            <h4 className="font-medium text-slate-900 mb-2">Support 24/7</h4>
            <p className="text-sm text-slate-600">
              Notre équipe est disponible à tout moment pour vous assister et répondre à vos questions.
            </p>
          </CardContent>
        </Card>

        <Card className="border border-slate-200">
          <CardContent className="p-6 text-center">
            <div className="w-12 h-12 bg-purple-100 rounded-lg flex items-center justify-center mx-auto mb-4">
              <Star className="w-6 h-6 text-purple-600" />
            </div>
            <h4 className="font-medium text-slate-900 mb-2">Qualité garantie</h4>
            <p className="text-sm text-slate-600">
              Tous nos prestataires sont sélectionnés et évalués pour garantir un service d'excellence.
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Contact d'urgence */}
      <div className="mt-12 bg-gradient-to-r from-slate-800 to-slate-900 rounded-xl p-8 text-white text-center">
        <h3 className="text-xl font-light mb-4">Besoin urgent ?</h3>
        <p className="text-slate-300 mb-6">
          Pour une réservation immédiate ou une demande spécifique, contactez-nous directement.
        </p>
        <div className="flex flex-col sm:flex-row gap-4 justify-center">
          <Button variant="outline" className="border-white text-white hover:bg-white hover:text-slate-900">
            <Phone className="mr-2 w-4 h-4" />
            +44 7934 858 048
          </Button>
          <Button variant="outline" className="border-white text-white hover:bg-white hover:text-slate-900">
            <Phone className="mr-2 w-4 h-4" />
            +33 765 808 687
          </Button>
        </div>
      </div>
    </div>
  );
}