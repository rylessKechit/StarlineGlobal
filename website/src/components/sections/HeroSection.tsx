'use client';

import React from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import { ArrowRight, Phone, Mail, Clock } from 'lucide-react';

export default function HeroSection() {
  return (
    <section className="min-h-screen bg-white relative">
      <div className="container mx-auto px-4">
        <div className="grid grid-cols-1 lg:grid-cols-12 gap-16 items-center min-h-screen py-20">
          
          {/* Left side - Direct messaging like Amalfi */}
          <div className="lg:col-span-7 space-y-8">
            
            {/* Clean, powerful headline */}
            <div className="space-y-6 fade-in-up delay-200">
              <h1 className="text-5xl md:text-6xl lg:text-7xl font-light text-slate-900 leading-tight">
                Luxury services.
                <span className="block text-slate-700 font-normal">
                  Global access.
                </span>
                <span className="block text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600 font-light">
                  One standard.
                </span>
              </h1>
            </div>

            {/* Value proposition - Clear and direct */}
            <div className="space-y-6 max-w-2xl fade-in-up delay-400">
              <p className="text-xl md:text-2xl text-slate-700 leading-relaxed font-light">
                Starlane Global sets the standard for exceptional luxury experiences, 
                personalized service, and flexible solutions that adapt to your lifestyle.
              </p>
              
              <p className="text-lg text-slate-600 leading-relaxed">
                Enjoy consistent excellence across all services, with dedicated account management 
                that understands your specific needs and delivers beyond expectations.
              </p>
            </div>

            {/* Simple, confident CTA */}
            <div className="space-y-6 fade-in-up delay-600">
              <div className="flex flex-col sm:flex-row gap-4">
                <Button 
                  size="lg" 
                  className="bg-slate-900 hover:bg-black text-white px-8 py-4 text-lg font-medium group"
                >
                  Get Started Today
                  <ArrowRight className="ml-2 w-5 h-5 group-hover:translate-x-1 transition-transform" />
                </Button>
                <Button 
                  variant="outline" 
                  size="lg" 
                  className="border-slate-300 text-slate-700 hover:bg-slate-50 px-8 py-4 text-lg font-medium"
                >
                  Explore Services
                </Button>
              </div>
              
              <p className="text-sm text-slate-500">
                Premium concierge services available 24/7. Contact us for personalized consultation.
              </p>
            </div>

            {/* Contact info - Direct and accessible */}
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-6 pt-8 border-t border-slate-100 fade-in-up delay-800">
              <div className="flex items-center space-x-3 group cursor-pointer hover:bg-slate-50 p-3 rounded-lg transition-colors">
                <Phone className="w-5 h-5 text-blue-600" />
                <div>
                  <p className="text-sm font-medium text-slate-900">UK Office</p>
                  <p className="text-sm text-slate-600">+44 7934 858 048</p>
                </div>
              </div>
              
              <div className="flex items-center space-x-3 group cursor-pointer hover:bg-slate-50 p-3 rounded-lg transition-colors">
                <Mail className="w-5 h-5 text-emerald-600" />
                <div>
                  <p className="text-sm font-medium text-slate-900">Email</p>
                  <p className="text-sm text-slate-600">contact@starlaneglobal.com</p>
                </div>
              </div>

              <div className="flex items-center space-x-3 group cursor-pointer hover:bg-slate-50 p-3 rounded-lg transition-colors">
                <Clock className="w-5 h-5 text-purple-600" />
                <div>
                  <p className="text-sm font-medium text-slate-900">Availability</p>
                  <p className="text-sm text-slate-600">24/7 Global</p>
                </div>
              </div>
            </div>
          </div>

          {/* Right side - Clean visual with stats */}
          <div className="lg:col-span-5 fade-in-right delay-600">
            
            {/* Main visual card */}
            <Card className="border border-slate-200 shadow-xl overflow-hidden group hover:shadow-2xl transition-all duration-500">
              <div className="aspect-[4/5] bg-gradient-to-br from-slate-50 to-slate-100 relative">
                <div className="absolute inset-0 flex items-center justify-center">
                  <div className="text-center space-y-6">
                    <div className="space-y-4">
                      <h3 className="text-2xl font-light text-slate-900">Global Excellence</h3>
                      <p className="text-slate-600 max-w-xs">
                        Seamlessly access luxury services anywhere in the world, 
                        all with one company and one high standard.
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </Card>

            {/* Stats grid - Clean and minimal */}
            <div className="grid grid-cols-3 gap-4 mt-8">
              <Card className="border border-slate-200 hover:shadow-lg transition-all group">
                <CardContent className="p-6 text-center">
                  <div className="text-3xl font-light text-slate-900 mb-2 group-hover:text-blue-600 transition-colors">3</div>
                  <div className="text-sm text-slate-500">Cities</div>
                </CardContent>
              </Card>
              
              <Card className="border border-slate-200 hover:shadow-lg transition-all group">
                <CardContent className="p-6 text-center">
                  <div className="text-3xl font-light text-slate-900 mb-2 group-hover:text-emerald-600 transition-colors">1000+</div>
                  <div className="text-sm text-slate-500">Clients</div>
                </CardContent>
              </Card>
              
              <Card className="border border-slate-200 hover:shadow-lg transition-all group">
                <CardContent className="p-6 text-center">
                  <div className="text-3xl font-light text-slate-900 mb-2 group-hover:text-purple-600 transition-colors">24/7</div>
                  <div className="text-sm text-slate-500">Service</div>
                </CardContent>
              </Card>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}