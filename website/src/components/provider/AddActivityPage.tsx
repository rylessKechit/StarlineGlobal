'use client';

import React, { useState } from 'react';
import { 
  ArrowLeft,
  Camera,
  Plus,
  X,
  MapPin,
  Clock,
  Users,
  DollarSign,
  Calendar,
  Star,
  Sparkles,
  Mountain,
  Plane,
  Hotel,
  Save,
  Eye
} from 'lucide-react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';

interface AddActivityPageProps {
  onNavigate: (section: string) => void;
}

export default function AddActivityPage({ onNavigate }: AddActivityPageProps) {
  const [currentStep, setCurrentStep] = useState(1);
  const [activityData, setActivityData] = useState({
    title: '',
    category: '',
    description: '',
    longDescription: '',
    location: '',
    address: '',
    duration: '',
    groupSize: { min: 1, max: 10 },
    price: '',
    currency: 'EUR',
    availability: '',
    features: [] as string[],
    images: [] as string[],
    requirements: '',
    inclusions: '',
    exclusions: '',
    cancellationPolicy: '',
    languages: [] as string[]
  });

  const [newFeature, setNewFeature] = useState('');
  const [previewMode, setPreviewMode] = useState(false);

  const categories = [
    { id: 'spa', name: 'Spa & Bien-être', icon: Sparkles, color: 'bg-pink-600', description: 'Massages, soins, détente' },
    { id: 'safari', name: 'Safari & Nature', icon: Mountain, color: 'bg-emerald-600', description: 'Aventures, nature, wildlife' },
    { id: 'travel', name: 'Voyages organisés', icon: Plane, color: 'bg-blue-600', description: 'Circuits, expériences, culture' },
    { id: 'hotel', name: 'Hôtels de luxe', icon: Hotel, color: 'bg-purple-600', description: 'Hébergements premium' }
  ];

  const currencies = [
    { code: 'EUR', symbol: '€', name: 'Euro' },
    { code: 'USD', symbol: '$', name: 'Dollar US' },
    { code: 'GBP', symbol: '£', name: 'Livre Sterling' },
    { code: 'CHF', symbol: 'CHF', name: 'Franc Suisse' }
  ];

  const availableLanguages = [
    'Français', 'English', 'Español', 'Deutsch', 'Italiano', 'Português', 'Русский', '中文', '日本語', 'العربية'
  ];

  const handleAddFeature = () => {
    if (newFeature.trim() && !activityData.features.includes(newFeature.trim())) {
      setActivityData({
        ...activityData,
        features: [...activityData.features, newFeature.trim()]
      });
      setNewFeature('');
    }
  };

  const handleRemoveFeature = (featureToRemove: string) => {
    setActivityData({
      ...activityData,
      features: activityData.features.filter(feature => feature !== featureToRemove)
    });
  };

  const handleLanguageToggle = (language: string) => {
    const updatedLanguages = activityData.languages.includes(language)
      ? activityData.languages.filter(lang => lang !== language)
      : [...activityData.languages, language];
    
    setActivityData({ ...activityData, languages: updatedLanguages });
  };

  const handleSaveActivity = () => {
    alert('Activité créée avec succès ! Elle sera en ligne après validation de notre équipe.');
    onNavigate('provider-dashboard');
  };

  const StepIndicator = ({ step, currentStep, title }: { step: number; currentStep: number; title: string }) => (
    <div className="flex items-center">
      <div className={`w-8 h-8 rounded-full flex items-center justify-center text-sm font-medium ${
        step <= currentStep ? 'bg-emerald-600 text-white' : 'bg-slate-200 text-slate-600'
      }`}>
        {step}
      </div>
      <div className="ml-3 hidden md:block">
        <p className={`text-sm font-medium ${step <= currentStep ? 'text-emerald-600' : 'text-slate-600'}`}>
          {title}
        </p>
      </div>
    </div>
  );

  if (previewMode) {
    const selectedCategory = categories.find(cat => cat.id === activityData.category);
    const selectedCurrency = currencies.find(curr => curr.code === activityData.currency);
    
    return (
      <div className="max-w-4xl mx-auto px-6 py-8">
        <div className="flex items-center justify-between mb-8">
          <button 
            onClick={() => setPreviewMode(false)}
            className="flex items-center space-x-2 text-slate-600 hover:text-slate-900 transition-colors"
          >
            <ArrowLeft className="w-5 h-5" />
            <span>Retour à l'édition</span>
          </button>
          <Button onClick={handleSaveActivity} className="bg-emerald-600 hover:bg-emerald-700 text-white">
            <Save className="w-4 h-4 mr-2" />
            Publier l'activité
          </Button>
        </div>

        {/* Preview Card */}
        <Card className="border border-slate-200 shadow-lg">
          <div className="relative aspect-[4/3] bg-gradient-to-br from-slate-200 to-slate-300 rounded-t-lg overflow-hidden">
            <div className="absolute inset-0 flex items-center justify-center">
              <Camera className="w-16 h-16 text-slate-400" />
            </div>
            <div className="absolute top-4 left-4">
              <Badge className="bg-emerald-600 text-white">Nouveau</Badge>
            </div>
            <div className="absolute bottom-4 left-4">
              {selectedCategory && <selectedCategory.icon className="w-8 h-8 text-white" />}
            </div>
          </div>

          <CardContent className="p-8">
            <div className="space-y-6">
              {/* Header */}
              <div>
                <h1 className="text-2xl font-medium text-slate-900 mb-2">{activityData.title || 'Titre de l\'activité'}</h1>
                <div className="flex items-center space-x-4 text-slate-600">
                  <div className="flex items-center space-x-1">
                    <MapPin className="w-4 h-4" />
                    <span>{activityData.location || 'Localisation'}</span>
                  </div>
                  <div className="flex items-center space-x-1">
                    <Star className="w-4 h-4 text-amber-400 fill-current" />
                    <span>Nouveau</span>
                  </div>
                </div>
              </div>

              {/* Description */}
              <p className="text-slate-700 leading-relaxed">
                {activityData.description || 'Description de l\'activité...'}
              </p>

              {/* Details */}
              <div className="grid grid-cols-2 md:grid-cols-3 gap-4 text-sm">
                <div className="flex items-center space-x-2">
                  <Clock className="w-4 h-4 text-slate-400" />
                  <span>{activityData.duration || 'Durée'}</span>
                </div>
                <div className="flex items-center space-x-2">
                  <Users className="w-4 h-4 text-slate-400" />
                  <span>{activityData.groupSize.min}-{activityData.groupSize.max} personnes</span>
                </div>
                <div className="flex items-center space-x-2">
                  <Calendar className="w-4 h-4 text-slate-400" />
                  <span>{activityData.availability || 'Disponibilité'}</span>
                </div>
              </div>

              {/* Features */}
              {activityData.features.length > 0 && (
                <div>
                  <h3 className="font-medium text-slate-900 mb-3">Inclus dans cette expérience</h3>
                  <div className="flex flex-wrap gap-2">
                    {activityData.features.map((feature, index) => (
                      <Badge key={index} variant="secondary" className="text-sm">
                        {feature}
                      </Badge>
                    ))}
                  </div>
                </div>
              )}

              {/* Price */}
              <div className="flex items-center justify-between pt-6 border-t border-slate-200">
                <div>
                  <span className="text-slate-500">À partir de</span>
                  <div className="text-2xl font-medium text-slate-900">
                    {activityData.price || '0'}{selectedCurrency?.symbol || '€'}
                    <span className="text-sm text-slate-500 font-normal"> /personne</span>
                  </div>
                </div>
                <Button className="bg-gradient-to-r from-emerald-600 to-blue-600 hover:from-emerald-700 hover:to-blue-700 text-white">
                  Réserver maintenant
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    );
  }

  return (
    <div className="max-w-4xl mx-auto px-6 py-8">
      {/* Header */}
      <div className="flex items-center justify-between mb-8">
        <button 
          onClick={() => onNavigate('provider-dashboard')}
          className="flex items-center space-x-2 text-slate-600 hover:text-slate-900 transition-colors"
        >
          <ArrowLeft className="w-5 h-5" />
          <span>Retour au dashboard</span>
        </button>
        <Button 
          onClick={() => setPreviewMode(true)}
          variant="outline"
        >
          <Eye className="w-4 h-4 mr-2" />
          Aperçu
        </Button>
      </div>

      <div className="mb-8">
        <h1 className="text-2xl font-light text-slate-900 mb-2">Créer une nouvelle activité</h1>
        <p className="text-slate-600">
          Ajoutez une nouvelle expérience à votre catalogue. Remplissez tous les détails pour attirer les clients.
        </p>
      </div>

      {/* Progress Steps */}
      <div className="flex items-center justify-between mb-8 p-6 bg-slate-50 rounded-lg">
        <StepIndicator step={1} currentStep={currentStep} title="Informations de base" />
        <div className="flex-1 h-px bg-slate-300 mx-4" />
        <StepIndicator step={2} currentStep={currentStep} title="Détails & Prix" />
        <div className="flex-1 h-px bg-slate-300 mx-4" />
        <StepIndicator step={3} currentStep={currentStep} title="Finalisation" />
      </div>

      <Card className="border border-slate-200">
        <CardContent className="p-8">
          {/* Étape 1: Informations de base */}
          {currentStep === 1 && (
            <div className="space-y-6">
              <h2 className="text-xl font-medium text-slate-900">Informations de base</h2>
              
              {/* Catégorie */}
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-3">Catégorie d'activité</label>
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  {categories.map((category) => {
                    const IconComponent = category.icon;
                    return (
                      <button
                        key={category.id}
                        onClick={() => setActivityData({...activityData, category: category.id})}
                        className={`p-4 border-2 rounded-lg text-left transition-all ${
                          activityData.category === category.id
                            ? 'border-emerald-500 bg-emerald-50'
                            : 'border-slate-200 hover:border-slate-300'
                        }`}
                      >
                        <div className="flex items-center space-x-3">
                          <div className={`w-10 h-10 ${category.color} rounded-lg flex items-center justify-center`}>
                            <IconComponent className="w-5 h-5 text-white" />
                          </div>
                          <div>
                            <h3 className="font-medium text-slate-900">{category.name}</h3>
                            <p className="text-sm text-slate-600">{category.description}</p>
                          </div>
                        </div>
                      </button>
                    );
                  })}
                </div>
              </div>

              {/* Titre */}
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">Titre de l'activité</label>
                <Input
                  placeholder="Ex: Spa Day au Ritz Paris"
                  value={activityData.title}
                  onChange={(e) => setActivityData({...activityData, title: e.target.value})}
                  className="w-full"
                />
                <p className="text-xs text-slate-500 mt-1">Un titre accrocheur qui décrit votre expérience</p>
              </div>

              {/* Description courte */}
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">Description courte</label>
                <textarea
                  placeholder="Description en 1-2 phrases qui donne envie..."
                  value={activityData.description}
                  onChange={(e) => setActivityData({...activityData, description: e.target.value})}
                  rows={3}
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg resize-none"
                />
                <p className="text-xs text-slate-500 mt-1">Maximum 200 caractères</p>
              </div>

              {/* Localisation */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">Ville/Région</label>
                  <Input
                    placeholder="Paris, Monaco, Londres..."
                    value={activityData.location}
                    onChange={(e) => setActivityData({...activityData, location: e.target.value})}
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">Adresse complète</label>
                  <Input
                    placeholder="Adresse précise du lieu"
                    value={activityData.address}
                    onChange={(e) => setActivityData({...activityData, address: e.target.value})}
                  />
                </div>
              </div>

              <div className="flex justify-end">
                <Button 
                  onClick={() => setCurrentStep(2)}
                  className="bg-emerald-600 hover:bg-emerald-700 text-white"
                  disabled={!activityData.category || !activityData.title || !activityData.description}
                >
                  Continuer
                </Button>
              </div>
            </div>
          )}

          {/* Étape 2: Détails & Prix */}
          {currentStep === 2 && (
            <div className="space-y-6">
              <h2 className="text-xl font-medium text-slate-900">Détails et tarification</h2>

              {/* Durée et taille du groupe */}
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">Durée</label>
                  <Input
                    placeholder="2 heures, 1 jour, 3 jours..."
                    value={activityData.duration}
                    onChange={(e) => setActivityData({...activityData, duration: e.target.value})}
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">Groupe min.</label>
                  <Input
                    type="number"
                    min="1"
                    value={activityData.groupSize.min}
                    onChange={(e) => setActivityData({
                      ...activityData, 
                      groupSize: { ...activityData.groupSize, min: parseInt(e.target.value) || 1 }
                    })}
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">Groupe max.</label>
                  <Input
                    type="number"
                    min="1"
                    value={activityData.groupSize.max}
                    onChange={(e) => setActivityData({
                      ...activityData, 
                      groupSize: { ...activityData.groupSize, max: parseInt(e.target.value) || 10 }
                    })}
                  />
                </div>
              </div>

              {/* Prix */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">Prix par personne</label>
                  <div className="relative">
                    <Input
                      type="number"
                      placeholder="0"
                      value={activityData.price}
                      onChange={(e) => setActivityData({...activityData, price: e.target.value})}
                      className="pr-12"
                    />
                    <span className="absolute right-3 top-1/2 transform -translate-y-1/2 text-slate-500">
                      {currencies.find(c => c.code === activityData.currency)?.symbol}
                    </span>
                  </div>
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">Devise</label>
                  <select
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg"
                    value={activityData.currency}
                    onChange={(e) => setActivityData({...activityData, currency: e.target.value})}
                  >
                    {currencies.map(currency => (
                      <option key={currency.code} value={currency.code}>
                        {currency.symbol} {currency.name}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              {/* Disponibilité */}
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">Disponibilité</label>
                <Input
                  placeholder="Ex: Toute l'année, Juin-Septembre, Sur réservation..."
                  value={activityData.availability}
                  onChange={(e) => setActivityData({...activityData, availability: e.target.value})}
                />
              </div>

              {/* Caractéristiques */}
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">Caractéristiques incluses</label>
                <div className="space-y-3">
                  <div className="flex space-x-2">
                    <Input
                      placeholder="Ex: Transport inclus, Repas, Guide privé..."
                      value={newFeature}
                      onChange={(e) => setNewFeature(e.target.value)}
                      onKeyPress={(e) => e.key === 'Enter' && handleAddFeature()}
                    />
                    <Button
                      type="button"
                      onClick={handleAddFeature}
                      variant="outline"
                    >
                      <Plus className="w-4 h-4" />
                    </Button>
                  </div>
                  
                  {activityData.features.length > 0 && (
                    <div className="flex flex-wrap gap-2">
                      {activityData.features.map((feature, index) => (
                        <div key={index} className="flex items-center space-x-1 bg-emerald-100 text-emerald-800 px-3 py-1 rounded-lg text-sm">
                          <span>{feature}</span>
                          <button
                            onClick={() => handleRemoveFeature(feature)}
                            className="text-emerald-600 hover:text-emerald-800"
                          >
                            <X className="w-3 h-3" />
                          </button>
                        </div>
                      ))}
                    </div>
                  )}
                </div>
              </div>

              <div className="flex justify-between">
                <Button 
                  variant="outline"
                  onClick={() => setCurrentStep(1)}
                >
                  Retour
                </Button>
                <Button 
                  onClick={() => setCurrentStep(3)}
                  className="bg-emerald-600 hover:bg-emerald-700 text-white"
                  disabled={!activityData.price || !activityData.duration}
                >
                  Continuer
                </Button>
              </div>
            </div>
          )}

          {/* Étape 3: Finalisation */}
          {currentStep === 3 && (
            <div className="space-y-6">
              <h2 className="text-xl font-medium text-slate-900">Finalisation</h2>

              {/* Description détaillée */}
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-2">Description détaillée</label>
                <textarea
                  placeholder="Décrivez en détail l'expérience, ce qui rend votre activité unique, le déroulé..."
                  value={activityData.longDescription}
                  onChange={(e) => setActivityData({...activityData, longDescription: e.target.value})}
                  rows={5}
                  className="w-full px-3 py-2 border border-slate-300 rounded-lg resize-none"
                />
              </div>

              {/* Langues parlées */}
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-3">Langues parlées</label>
                <div className="grid grid-cols-2 md:grid-cols-5 gap-2">
                  {availableLanguages.map(language => (
                    <button
                      key={language}
                      onClick={() => handleLanguageToggle(language)}
                      className={`px-3 py-2 text-sm rounded-lg border transition-all ${
                        activityData.languages.includes(language)
                          ? 'border-emerald-500 bg-emerald-50 text-emerald-700'
                          : 'border-slate-200 hover:border-slate-300'
                      }`}
                    >
                      {language}
                    </button>
                  ))}
                </div>
              </div>

              {/* Images */}
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-3">Photos de l'activité</label>
                <div className="border-2 border-dashed border-slate-300 rounded-lg p-8 text-center hover:border-slate-400 transition-colors cursor-pointer">
                  <Camera className="w-12 h-12 text-slate-400 mx-auto mb-4" />
                  <h3 className="text-sm font-medium text-slate-900 mb-1">Ajoutez des photos</h3>
                  <p className="text-sm text-slate-500">JPG, PNG jusqu'à 5MB. Première image = photo principale</p>
                  <Button variant="outline" className="mt-4">
                    <Plus className="w-4 h-4 mr-2" />
                    Choisir les fichiers
                  </Button>
                </div>
              </div>

              {/* Conditions */}
              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">Prérequis/Exigences</label>
                  <textarea
                    placeholder="Âge minimum, condition physique, équipement requis..."
                    value={activityData.requirements}
                    onChange={(e) => setActivityData({...activityData, requirements: e.target.value})}
                    rows={3}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg resize-none"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-2">Politique d'annulation</label>
                  <textarea
                    placeholder="Conditions d'annulation et de remboursement..."
                    value={activityData.cancellationPolicy}
                    onChange={(e) => setActivityData({...activityData, cancellationPolicy: e.target.value})}
                    rows={3}
                    className="w-full px-3 py-2 border border-slate-300 rounded-lg resize-none"
                  />
                </div>
              </div>

              {/* Informations importantes */}
              <div className="bg-blue-50 rounded-lg p-4">
                <h4 className="font-medium text-blue-900 mb-2">Avant publication</h4>
                <ul className="text-sm text-blue-800 space-y-1">
                  <li>• Votre activité sera vérifiée par notre équipe (24-48h)</li>
                  <li>• Vous recevrez une notification de validation par email</li>
                  <li>• Vous pourrez modifier votre activité à tout moment</li>
                  <li>• Commission de 12% sur chaque réservation</li>
                </ul>
              </div>

              <div className="flex justify-between">
                <Button 
                  variant="outline"
                  onClick={() => setCurrentStep(2)}
                >
                  Retour
                </Button>
                <div className="space-x-3">
                  <Button 
                    variant="outline"
                    onClick={() => setPreviewMode(true)}
                  >
                    <Eye className="w-4 h-4 mr-2" />
                    Aperçu
                  </Button>
                  <Button 
                    onClick={handleSaveActivity}
                    className="bg-emerald-600 hover:bg-emerald-700 text-white"
                  >
                    <Save className="w-4 h-4 mr-2" />
                    Créer l'activité
                  </Button>
                </div>
              </div>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}