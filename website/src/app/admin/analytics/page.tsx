'use client';

import React, { useState } from 'react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { 
  TrendingUp, 
  Users, 
  DollarSign, 
  Activity,
  Calendar,
  BarChart3,
  PieChart,
  Download,
  Filter,
  ArrowUp,
  ArrowDown
} from 'lucide-react';

export default function AdminAnalyticsPage() {
  const [timeRange, setTimeRange] = useState('month');
  const [selectedMetric, setSelectedMetric] = useState('revenue');

  const metrics = {
    totalUsers: { value: 2847, change: 18.2, trend: 'up' },
    totalRevenue: { value: 145780, change: 15.3, trend: 'up' },
    activeBookings: { value: 234, change: 8.7, trend: 'up' },
    avgRating: { value: 4.8, change: 0.3, trend: 'up' },
    conversionRate: { value: 12.5, change: -2.1, trend: 'down' },
    totalProviders: { value: 156, change: 12.8, trend: 'up' }
  };

  const revenueData = [
    { month: 'Jan', revenue: 87500, bookings: 145 },
    { month: 'Fév', revenue: 92300, bookings: 167 },
    { month: 'Mar', revenue: 98400, bookings: 189 },
    { month: 'Avr', revenue: 108200, bookings: 203 },
    { month: 'Mai', revenue: 125600, bookings: 234 },
    { month: 'Juin', revenue: 134800, bookings: 256 },
    { month: 'Juil', revenue: 142300, bookings: 278 },
    { month: 'Aoû', revenue: 138900, bookings: 267 },
    { month: 'Sep', revenue: 145200, bookings: 289 },
    { month: 'Oct', revenue: 148700, bookings: 298 },
    { month: 'Nov', revenue: 152400, bookings: 312 },
    { month: 'Déc', revenue: 145780, bookings: 298 }
  ];

  const topServices = [
    { name: 'Transport privé', bookings: 145, revenue: 45230, percentage: 31 },
    { name: 'Spa & Wellness', bookings: 98, revenue: 38940, percentage: 27 },
    { name: 'Expériences culinaires', bookings: 67, revenue: 28450, percentage: 20 },
    { name: 'Activités culturelles', bookings: 54, revenue: 21680, percentage: 15 },
    { name: 'Aventures outdoor', bookings: 32, revenue: 11480, percentage: 7 }
  ];

  const userGrowth = [
    { period: 'Jan 2024', clients: 1245, providers: 67 },
    { period: 'Fév 2024', clients: 1389, providers: 72 },
    { period: 'Mar 2024', clients: 1523, providers: 78 },
    { period: 'Avr 2024', clients: 1678, providers: 85 },
    { period: 'Mai 2024', clients: 1834, providers: 92 },
    { period: 'Juin 2024', clients: 1987, providers: 98 },
    { period: 'Juil 2024', clients: 2156, providers: 105 },
    { period: 'Aoû 2024', clients: 2298, providers: 112 },
    { period: 'Sep 2024', clients: 2445, providers: 123 },
    { period: 'Oct 2024', clients: 2598, providers: 134 },
    { period: 'Nov 2024', clients: 2734, providers: 148 },
    { period: 'Déc 2024', clients: 2847, providers: 156 }
  ];

  const MetricCard = ({ title, value, change, trend, icon: Icon, prefix = '', suffix = '' }: any) => (
    <Card className="border border-slate-200 hover:shadow-lg transition-shadow">
      <CardContent className="p-6">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className={`w-12 h-12 rounded-lg flex items-center justify-center ${
              trend === 'up' ? 'bg-green-100' : 'bg-red-100'
            }`}>
              <Icon className={`w-6 h-6 ${trend === 'up' ? 'text-green-600' : 'text-red-600'}`} />
            </div>
            <div>
              <p className="text-2xl font-light text-slate-900">
                {prefix}{typeof value === 'number' ? value.toLocaleString() : value}{suffix}
              </p>
              <p className="text-sm text-slate-600">{title}</p>
            </div>
          </div>
          <div className={`flex items-center space-x-1 ${
            trend === 'up' ? 'text-green-600' : 'text-red-600'
          }`}>
            {trend === 'up' ? <ArrowUp className="w-4 h-4" /> : <ArrowDown className="w-4 h-4" />}
            <span className="text-sm font-medium">{Math.abs(change)}%</span>
          </div>
        </div>
      </CardContent>
    </Card>
  );

  return (
    <div className="max-w-7xl mx-auto px-6 py-8 space-y-8">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-light text-slate-900">Analytics</h1>
          <p className="text-slate-600">Vue d'ensemble des performances de la plateforme</p>
        </div>
        <div className="flex items-center space-x-4">
          <select
            value={timeRange}
            onChange={(e) => setTimeRange(e.target.value)}
            className="px-4 py-2 border border-slate-300 rounded-lg"
          >
            <option value="week">Cette semaine</option>
            <option value="month">Ce mois</option>
            <option value="quarter">Ce trimestre</option>
            <option value="year">Cette année</option>
          </select>
          <Button variant="outline" className="flex items-center space-x-2">
            <Download className="w-4 h-4" />
            <span>Exporter</span>
          </Button>
        </div>
      </div>

      {/* Key Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <MetricCard
          title="Utilisateurs totaux"
          value={metrics.totalUsers.value}
          change={metrics.totalUsers.change}
          trend={metrics.totalUsers.trend}
          icon={Users}
        />
        <MetricCard
          title="Revenus totaux"
          value={metrics.totalRevenue.value}
          change={metrics.totalRevenue.change}
          trend={metrics.totalRevenue.trend}
          icon={DollarSign}
          suffix="€"
        />
        <MetricCard
          title="Réservations actives"
          value={metrics.activeBookings.value}
          change={metrics.activeBookings.change}
          trend={metrics.activeBookings.trend}
          icon={Calendar}
        />
        <MetricCard
          title="Note moyenne"
          value={metrics.avgRating.value}
          change={metrics.avgRating.change}
          trend={metrics.avgRating.trend}
          icon={Activity}
        />
        <MetricCard
          title="Taux de conversion"
          value={metrics.conversionRate.value}
          change={metrics.conversionRate.change}
          trend={metrics.conversionRate.trend}
          icon={TrendingUp}
          suffix="%"
        />
        <MetricCard
          title="Prestataires"
          value={metrics.totalProviders.value}
          change={metrics.totalProviders.change}
          trend={metrics.totalProviders.trend}
          icon={Users}
        />
      </div>

      {/* Charts Section */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Revenue Chart */}
        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-lg font-medium text-slate-900">Évolution du chiffre d'affaires</h3>
              <div className="flex items-center space-x-2">
                <Badge className="bg-green-100 text-green-800">+15.3%</Badge>
              </div>
            </div>
            
            {/* Simple Bar Chart Visualization */}
            <div className="space-y-4">
              {revenueData.slice(-6).map((data, index) => (
                <div key={data.month} className="space-y-2">
                  <div className="flex justify-between text-sm">
                    <span className="text-slate-600">{data.month}</span>
                    <span className="font-medium text-slate-900">{data.revenue.toLocaleString()}€</span>
                  </div>
                  <div className="w-full bg-slate-200 rounded-full h-2">
                    <div 
                      className="bg-gradient-to-r from-blue-600 to-purple-600 h-2 rounded-full transition-all"
                      style={{ width: `${(data.revenue / Math.max(...revenueData.map(d => d.revenue))) * 100}%` }}
                    />
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        {/* User Growth */}
        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-lg font-medium text-slate-900">Croissance des utilisateurs</h3>
              <div className="flex items-center space-x-2">
                <Badge className="bg-blue-100 text-blue-800">+18.2%</Badge>
              </div>
            </div>

            <div className="space-y-4">
              {userGrowth.slice(-6).map((data, index) => (
                <div key={data.period} className="flex items-center justify-between">
                  <span className="text-sm text-slate-600">{data.period}</span>
                  <div className="flex items-center space-x-4">
                    <div className="flex items-center space-x-2">
                      <div className="w-3 h-3 bg-blue-500 rounded-full"></div>
                      <span className="text-sm font-medium text-slate-900">{data.clients} clients</span>
                    </div>
                    <div className="flex items-center space-x-2">
                      <div className="w-3 h-3 bg-emerald-500 rounded-full"></div>
                      <span className="text-sm font-medium text-slate-900">{data.providers} prestataires</span>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Services Performance */}
      <Card className="border border-slate-200">
        <CardContent className="p-6">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-lg font-medium text-slate-900">Performance des services</h3>
            <Button variant="outline" size="sm">
              <Filter className="w-4 h-4 mr-2" />
              Filtres
            </Button>
          </div>

          <div className="overflow-x-auto">
            <table className="w-full">
              <thead>
                <tr className="border-b border-slate-200">
                  <th className="text-left py-3 px-4 font-medium text-slate-700">Service</th>
                  <th className="text-left py-3 px-4 font-medium text-slate-700">Réservations</th>
                  <th className="text-left py-3 px-4 font-medium text-slate-700">Revenus</th>
                  <th className="text-left py-3 px-4 font-medium text-slate-700">Part de marché</th>
                  <th className="text-left py-3 px-4 font-medium text-slate-700">Tendance</th>
                </tr>
              </thead>
              <tbody>
                {topServices.map((service, index) => (
                  <tr key={service.name} className="border-b border-slate-100 hover:bg-slate-50">
                    <td className="py-4 px-4">
                      <div className="flex items-center space-x-3">
                        <div className="w-8 h-8 bg-blue-100 rounded-lg flex items-center justify-center">
                          <span className="text-blue-600 font-medium text-sm">{index + 1}</span>
                        </div>
                        <span className="font-medium text-slate-900">{service.name}</span>
                      </div>
                    </td>
                    <td className="py-4 px-4 text-slate-900">{service.bookings}</td>
                    <td className="py-4 px-4 font-medium text-slate-900">{service.revenue.toLocaleString()}€</td>
                    <td className="py-4 px-4">
                      <div className="flex items-center space-x-2">
                        <div className="w-20 bg-slate-200 rounded-full h-2">
                          <div 
                            className="bg-gradient-to-r from-blue-600 to-purple-600 h-2 rounded-full"
                            style={{ width: `${service.percentage}%` }}
                          />
                        </div>
                        <span className="text-sm text-slate-600">{service.percentage}%</span>
                      </div>
                    </td>
                    <td className="py-4 px-4">
                      <div className="flex items-center space-x-1 text-green-600">
                        <TrendingUp className="w-4 h-4" />
                        <span className="text-sm">+{Math.floor(Math.random() * 15) + 5}%</span>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>

      {/* Geographic Distribution */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <h3 className="text-lg font-medium text-slate-900 mb-6">Répartition géographique</h3>
            
            <div className="space-y-4">
              {[
                { city: 'Londres', users: 1245, percentage: 44 },
                { city: 'Paris', users: 892, percentage: 31 },
                { city: 'New York', users: 567, percentage: 20 },
                { city: 'Monaco', users: 143, percentage: 5 }
              ].map((location) => (
                <div key={location.city} className="space-y-2">
                  <div className="flex justify-between text-sm">
                    <span className="text-slate-700">{location.city}</span>
                    <span className="font-medium text-slate-900">{location.users} utilisateurs</span>
                  </div>
                  <div className="w-full bg-slate-200 rounded-full h-2">
                    <div 
                      className="bg-gradient-to-r from-emerald-500 to-blue-500 h-2 rounded-full"
                      style={{ width: `${location.percentage}%` }}
                    />
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <h3 className="text-lg font-medium text-slate-900 mb-6">Satisfaction client</h3>
            
            <div className="text-center mb-6">
              <div className="text-4xl font-light text-slate-900 mb-2">4.8</div>
              <div className="flex items-center justify-center space-x-1 mb-2">
                {[...Array(5)].map((_, i) => (
                  <div key={i} className={`w-4 h-4 ${i < 5 ? 'text-amber-400' : 'text-slate-300'}`}>
                    ★
                  </div>
                ))}
              </div>
              <p className="text-sm text-slate-600">Basé sur 1,247 avis</p>
            </div>

            <div className="space-y-3">
              {[
                { stars: 5, count: 856, percentage: 69 },
                { stars: 4, count: 267, percentage: 21 },
                { stars: 3, count: 89, percentage: 7 },
                { stars: 2, count: 23, percentage: 2 },
                { stars: 1, count: 12, percentage: 1 }
              ].map((rating) => (
                <div key={rating.stars} className="flex items-center space-x-3">
                  <span className="text-sm text-slate-600 w-8">{rating.stars}★</span>
                  <div className="flex-1 bg-slate-200 rounded-full h-2">
                    <div 
                      className="bg-amber-400 h-2 rounded-full"
                      style={{ width: `${rating.percentage}%` }}
                    />
                  </div>
                  <span className="text-sm text-slate-600 w-12">{rating.count}</span>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        <Card className="border border-slate-200">
          <CardContent className="p-6">
            <h3 className="text-lg font-medium text-slate-900 mb-6">Activités récentes</h3>
            
            <div className="space-y-4">
              {[
                { action: 'Nouveau prestataire', details: 'Tokyo Culinary Masters', time: '2 min' },
                { action: 'Réservation confirmée', details: 'Spa Day Ritz Paris', time: '15 min' },
                { action: 'Nouvel utilisateur', details: 'Isabella Rodriguez', time: '32 min' },
                { action: 'Activité validée', details: 'Helicopter Tour London', time: '1h' },
                { action: 'Paiement reçu', details: '2,450€', time: '2h' }
              ].map((activity, index) => (
                <div key={index} className="flex items-start space-x-3">
                  <div className="w-2 h-2 bg-blue-500 rounded-full mt-2"></div>
                  <div className="flex-1">
                    <p className="text-sm font-medium text-slate-900">{activity.action}</p>
                    <p className="text-sm text-slate-600">{activity.details}</p>
                  </div>
                  <span className="text-xs text-slate-500">{activity.time}</span>
                </div>
              ))}
            </div>

            <Button variant="outline" size="sm" className="w-full mt-4">
              Voir toutes les activités
            </Button>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}