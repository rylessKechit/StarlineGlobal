'use client';

import React, { useEffect, useRef } from 'react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { MapPin, Clock, Phone, Mail, ArrowRight } from 'lucide-react';

export default function LocationsSection() {
  const sectionRef = useRef(null);

  useEffect(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            const cards = entry.target.querySelectorAll('.service-card');
            cards.forEach((card, index) => {
              setTimeout(() => {
                card.classList.add('animate');
              }, index * 200);
            });
          }
        });
      },
      { threshold: 0.1 }
    );

    if (sectionRef.current) {
      observer.observe(sectionRef.current);
    }

    return () => observer.disconnect();
  }, []);

  const locations = [
    { 
      city: "London", 
      country: "UK", 
      timezone: "GMT",
      featured: true,
      description: "European headquarters in Fitzrovia",
      address: "45 Fitzroy Street, Fitzrovia, W1T 6EB",
      hours: "Mon-Thu: 08:00-18:00, Fri-Sun: 07:00-19:00",
      phone: "+44 7934 858 048",
      color: "text-blue-600",
      bgColor: "bg-blue-50"
    },
    { 
      city: "New York", 
      country: "USA", 
      timezone: "EST",
      description: "Americas financial hub",
      color: "text-emerald-600",
      bgColor: "bg-emerald-50"
    },
    { 
      city: "Paris", 
      country: "France", 
      timezone: "CET",
      description: "European luxury capital",
      phone: "+33 765 808 687",
      color: "text-purple-600",
      bgColor: "bg-purple-50"
    }
  ];

  return (
    <section ref={sectionRef} id="locations" className="py-20 px-4 bg-slate-50">
      <div className="container mx-auto max-w-7xl">
        
        {/* Header - Simple and direct */}
        <div className="text-center mb-16 fade-in-up delay-200">
          <h2 className="text-4xl md:text-5xl font-light text-slate-900 mb-6">
            Global presence.
            <span className="block text-slate-600">Local expertise.</span>
          </h2>
          <p className="text-xl text-slate-600 max-w-3xl mx-auto leading-relaxed">
            Operating in three prestigious cities, delivering consistent luxury experiences 
            with deep local knowledge and cultural understanding.
          </p>
        </div>

        {/* Locations Grid - Clean cards */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-16">
          {locations.map((location, index) => (
            <Card 
              key={location.city} 
              className={`group transition-all duration-300 hover:shadow-lg border border-slate-200 ${
                location.featured ? 'ring-1 ring-blue-200' : ''
              } service-card`}
              style={{ animationDelay: `${400 + index * 150}ms` }}
            >
              <CardContent className="p-6 space-y-4">
                
                {/* Header */}
                <div className="flex items-start justify-between">
                  <div>
                    <h3 className={`text-2xl font-light ${location.color} mb-1`}>
                      {location.city}
                    </h3>
                    <p className="text-slate-600 text-sm">{location.country}</p>
                  </div>
                  
                  <div className="text-right">
                    <div className="text-sm text-slate-500">Timezone</div>
                    <div className="text-sm font-medium text-slate-700">{location.timezone}</div>
                  </div>
                </div>

                {/* Description */}
                <p className="text-slate-700 leading-relaxed">{location.description}</p>
                
                {/* Details */}
                <div className="space-y-3 pt-2">
                  {location.address && (
                    <div className="flex items-start space-x-3">
                      <MapPin className="w-4 h-4 text-slate-400 mt-1 flex-shrink-0" />
                      <span className="text-sm text-slate-600">{location.address}</span>
                    </div>
                  )}
                  
                  {location.hours && (
                    <div className="flex items-start space-x-3">
                      <Clock className="w-4 h-4 text-slate-400 mt-1 flex-shrink-0" />
                      <span className="text-sm text-slate-600">{location.hours}</span>
                    </div>
                  )}
                  
                  {location.phone && (
                    <div className="flex items-center space-x-3">
                      <Phone className="w-4 h-4 text-slate-400 flex-shrink-0" />
                      <span className="text-sm text-slate-600 font-medium">{location.phone}</span>
                    </div>
                  )}
                </div>

                {/* Featured office action */}
                {location.featured && (
                  <div className="pt-4 border-t border-slate-100">
                    <Button 
                      variant="ghost" 
                      size="sm"
                      className={`${location.color} hover:bg-blue-50 p-0 font-medium group-hover:translate-x-1 transition-transform`}
                    >
                      Contact London Office <ArrowRight className="ml-2 w-3 h-3" />
                    </Button>
                  </div>
                )}
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Global reach section */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center fade-in-up delay-1000">
          
          {/* Left: Stats */}
          <div className="space-y-8">
            <div className="space-y-4">
              <h3 className="text-3xl font-light text-slate-900">
                Worldwide coverage.
                <span className="block text-slate-600">Seamless service.</span>
              </h3>
              <p className="text-lg text-slate-600 leading-relaxed">
                No matter where you are in the world, our global network ensures 
                consistent luxury experiences delivered with local expertise.
              </p>
            </div>

            {/* Key stats */}
            <div className="grid grid-cols-2 gap-6">
              <div className="space-y-2">
                <div className="text-3xl font-light text-slate-900">25+</div>
                <div className="text-sm text-slate-600">Countries served</div>
              </div>
              <div className="space-y-2">
                <div className="text-3xl font-light text-slate-900">24/7</div>
                <div className="text-sm text-slate-600">Global support</div>
              </div>
              <div className="space-y-2">
                <div className="text-3xl font-light text-slate-900">15min</div>
                <div className="text-sm text-slate-600">Response time</div>
              </div>
              <div className="space-y-2">
                <div className="text-3xl font-light text-slate-900">100%</div>
                <div className="text-sm text-slate-600">Confidential</div>
              </div>
            </div>
          </div>

          {/* Right: Contact CTA */}
          <Card className="border border-slate-200 shadow-lg">
            <CardContent className="p-8 space-y-6">
              <div className="space-y-4">
                <h4 className="text-2xl font-light text-slate-900">
                  Ready to connect?
                </h4>
                <p className="text-slate-600 leading-relaxed">
                  Regardless of your location, our global team is ready to provide 
                  exceptional service tailored to your specific needs.
                </p>
              </div>

              {/* Contact options */}
              <div className="space-y-4">
                <div className="flex items-center space-x-4 p-4 rounded-lg hover:bg-slate-50 transition-colors group cursor-pointer">
                  <div className="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center group-hover:bg-blue-200 transition-colors">
                    <Mail className="w-6 h-6 text-blue-600" />
                  </div>
                  <div>
                    <p className="font-medium text-slate-900">Email our team</p>
                    <p className="text-sm text-slate-600">contact@starlaneglobal.com</p>
                  </div>
                </div>

                <div className="flex items-center space-x-4 p-4 rounded-lg hover:bg-slate-50 transition-colors group cursor-pointer">
                  <div className="w-12 h-12 bg-emerald-100 rounded-full flex items-center justify-center group-hover:bg-emerald-200 transition-colors">
                    <Phone className="w-6 h-6 text-emerald-600" />
                  </div>
                  <div>
                    <p className="font-medium text-slate-900">Call directly</p>
                    <p className="text-sm text-slate-600">Available 24/7 worldwide</p>
                  </div>
                </div>
              </div>

              {/* CTA buttons */}
              <div className="flex flex-col sm:flex-row gap-4 pt-4">
                <Button 
                  className="bg-slate-900 hover:bg-black text-white flex-1 group"
                >
                  Contact Us <ArrowRight className="ml-2 w-4 h-4 group-hover:translate-x-1 transition-transform" />
                </Button>
                <Button 
                  variant="outline" 
                  className="border-slate-300 text-slate-700 hover:bg-slate-50 flex-1"
                >
                  Schedule Call
                </Button>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </section>
  );
}