'use client';

import React, { useEffect, useRef } from 'react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { ArrowRight } from 'lucide-react';

export default function ServicesOverview() {
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

  return (
    <section ref={sectionRef} className="py-20 px-4 bg-slate-50 overflow-hidden">
      <div className="container mx-auto max-w-7xl">
        
        {/* Header */}
        <div className="mb-16 text-center max-w-3xl mx-auto fade-in-up delay-200">
          <h2 className="text-4xl md:text-5xl font-light text-slate-900 mb-6">
            Comprehensive luxury services.
            <span className="block text-blue-700">Delivered seamlessly.</span>
          </h2>
          <p className="text-xl text-slate-600 leading-relaxed">
            From real estate to private security, experience consistent excellence 
            across all our premium services in London, Paris, and New York.
          </p>
        </div>

        {/* Services Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-16">
          
          {/* Real Estate */}
          <Card className="service-card bg-white border-0 shadow-lg overflow-hidden group hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3">
            <div className="aspect-[4/3] bg-gradient-to-br from-amber-100 to-amber-200 relative overflow-hidden">
              <div className="absolute inset-0 bg-gradient-to-t from-amber-500/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
              <div className="absolute top-4 left-4 transform -translate-x-4 group-hover:translate-x-0 transition-transform duration-300">
                <div className="bg-amber-600 text-white px-3 py-1 rounded-full text-xs font-medium">
                  REAL ESTATE
                </div>
              </div>
              <div className="absolute bottom-4 right-4 w-3 h-3 bg-amber-400 rounded-full opacity-30 group-hover:opacity-60 transition-opacity"></div>
            </div>
            <CardContent className="p-8">
              <h3 className="text-xl font-medium text-slate-900 mb-3 group-hover:text-amber-700 transition-colors duration-300">
                Exclusive Properties
              </h3>
              <p className="text-slate-600 leading-relaxed mb-6">
                Access to the world's most prestigious addresses. From London townhouses 
                to Manhattan penthouses, we curate exceptional real estate opportunities.
              </p>
              <Button 
                variant="ghost" 
                className="text-amber-700 hover:text-amber-800 hover:bg-amber-50 p-0 font-medium group-hover:translate-x-2 transition-all duration-300"
              >
                Explore Properties <ArrowRight className="ml-2 w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </Button>
            </CardContent>
          </Card>

          {/* Air Travel */}
          <Card className="service-card bg-white border-0 shadow-lg overflow-hidden group hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3">
            <div className="aspect-[4/3] bg-gradient-to-br from-blue-100 to-blue-200 relative overflow-hidden">
              <div className="absolute inset-0 bg-gradient-to-t from-blue-500/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
              <div className="absolute top-4 left-4 transform -translate-x-4 group-hover:translate-x-0 transition-transform duration-300">
                <div className="bg-blue-600 text-white px-3 py-1 rounded-full text-xs font-medium">
                  AIR TRAVEL
                </div>
              </div>
              <div className="absolute top-1/2 right-4 w-6 h-6 bg-blue-600 rounded-full opacity-20 float"></div>
              <div className="absolute bottom-6 left-1/2 w-2 h-2 bg-blue-400 rounded-full opacity-40 animate-pulse"></div>
            </div>
            <CardContent className="p-8">
              <h3 className="text-xl font-medium text-slate-900 mb-3 group-hover:text-blue-700 transition-colors duration-300">
                Private Aviation
              </h3>
              <p className="text-slate-600 leading-relaxed mb-6">
                Experience seamless travel with our private jet charter services, 
                VIP airport lounges, and expedited customs clearance worldwide.
              </p>
              <Button 
                variant="ghost" 
                className="text-blue-700 hover:text-blue-800 hover:bg-blue-50 p-0 font-medium group-hover:translate-x-2 transition-all duration-300"
              >
                Book Flight <ArrowRight className="ml-2 w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </Button>
            </CardContent>
          </Card>

          {/* Transport */}
          <Card className="service-card bg-white border-0 shadow-lg overflow-hidden group hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3">
            <div className="aspect-[4/3] bg-gradient-to-br from-emerald-100 to-emerald-200 relative overflow-hidden">
              <div className="absolute inset-0 bg-gradient-to-t from-emerald-500/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
              <div className="absolute top-4 left-4 transform -translate-x-4 group-hover:translate-x-0 transition-transform duration-300">
                <div className="bg-emerald-600 text-white px-3 py-1 rounded-full text-xs font-medium">
                  TRANSPORT
                </div>
              </div>
              <div className="absolute bottom-4 right-4 w-4 h-1 bg-emerald-400 rounded-full opacity-40"></div>
            </div>
            <CardContent className="p-8">
              <h3 className="text-xl font-medium text-slate-900 mb-3 group-hover:text-emerald-700 transition-colors duration-300">
                Luxury Transportation
              </h3>
              <p className="text-slate-600 leading-relaxed mb-6">
                Professional chauffeur services with premium vehicles. Reliable, 
                discrete, and comfortable transportation for all your needs.
              </p>
              <Button 
                variant="ghost" 
                className="text-emerald-700 hover:text-emerald-800 hover:bg-emerald-50 p-0 font-medium group-hover:translate-x-2 transition-all duration-300"
              >
                Reserve Transport <ArrowRight className="ml-2 w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </Button>
            </CardContent>
          </Card>

          {/* Corporate */}
          <Card className="service-card bg-white border-0 shadow-lg overflow-hidden group hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3">
            <div className="aspect-[4/3] bg-gradient-to-br from-purple-100 to-purple-200 relative overflow-hidden">
              <div className="absolute inset-0 bg-gradient-to-t from-purple-500/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
              <div className="absolute top-4 left-4 transform -translate-x-4 group-hover:translate-x-0 transition-transform duration-300">
                <div className="bg-purple-600 text-white px-3 py-1 rounded-full text-xs font-medium">
                  CORPORATE
                </div>
              </div>
              <div className="absolute top-1/2 right-6 w-8 h-px bg-purple-400 opacity-30"></div>
            </div>
            <CardContent className="p-8">
              <h3 className="text-xl font-medium text-slate-900 mb-3 group-hover:text-purple-700 transition-colors duration-300">
                Business Solutions
              </h3>
              <p className="text-slate-600 leading-relaxed mb-6">
                Comprehensive corporate services including executive support, 
                event management, and business logistics across global markets.
              </p>
              <Button 
                variant="ghost" 
                className="text-purple-700 hover:text-purple-800 hover:bg-purple-50 p-0 font-medium group-hover:translate-x-2 transition-all duration-300"
              >
                Corporate Services <ArrowRight className="ml-2 w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </Button>
            </CardContent>
          </Card>

          {/* Lifestyle */}
          <Card className="service-card bg-white border-0 shadow-lg overflow-hidden group hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3">
            <div className="aspect-[4/3] bg-gradient-to-br from-rose-100 to-rose-200 relative overflow-hidden">
              <div className="absolute inset-0 bg-gradient-to-t from-rose-500/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
              <div className="absolute top-4 left-4 transform -translate-x-4 group-hover:translate-x-0 transition-transform duration-300">
                <div className="bg-rose-600 text-white px-3 py-1 rounded-full text-xs font-medium">
                  LIFESTYLE
                </div>
              </div>
              <div className="absolute top-6 right-6 w-2 h-2 bg-rose-400 rounded-full animate-ping"></div>
              <div className="absolute bottom-8 right-8 w-1 h-1 bg-rose-500 rounded-full animate-pulse"></div>
              <div className="absolute top-1/2 left-6 w-1 h-1 bg-rose-300 rounded-full animate-pulse delay-400"></div>
            </div>
            <CardContent className="p-8">
              <h3 className="text-xl font-medium text-slate-900 mb-3 group-hover:text-rose-700 transition-colors duration-300">
                Personal Concierge
              </h3>
              <p className="text-slate-600 leading-relaxed mb-6">
                From restaurant reservations to personal shopping, our lifestyle 
                management services handle every detail of your daily life.
              </p>
              <Button 
                variant="ghost" 
                className="text-rose-700 hover:text-rose-800 hover:bg-rose-50 p-0 font-medium group-hover:translate-x-2 transition-all duration-300"
              >
                Lifestyle Services <ArrowRight className="ml-2 w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </Button>
            </CardContent>
          </Card>

          {/* Events */}
          <Card className="service-card bg-white border-0 shadow-lg overflow-hidden group hover:shadow-2xl transition-all duration-500 transform hover:-translate-y-3">
            <div className="aspect-[4/3] bg-gradient-to-br from-indigo-100 to-indigo-200 relative overflow-hidden">
              <div className="absolute inset-0 bg-gradient-to-t from-indigo-500/20 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
              <div className="absolute top-4 left-4 transform -translate-x-4 group-hover:translate-x-0 transition-transform duration-300">
                <div className="bg-indigo-600 text-white px-3 py-1 rounded-full text-xs font-medium">
                  EVENTS
                </div>
              </div>
              <div className="absolute bottom-4 left-4 w-3 h-3 border border-indigo-400 rounded-full opacity-40"></div>
            </div>
            <CardContent className="p-8">
              <h3 className="text-xl font-medium text-slate-900 mb-3 group-hover:text-indigo-700 transition-colors duration-300">
                Exclusive Access
              </h3>
              <p className="text-slate-600 leading-relaxed mb-6">
                VIP access to fashion shows, sporting events, galas, and private 
                cultural experiences around the world.
              </p>
              <Button 
                variant="ghost" 
                className="text-indigo-700 hover:text-indigo-800 hover:bg-indigo-50 p-0 font-medium group-hover:translate-x-2 transition-all duration-300"
              >
                Event Access <ArrowRight className="ml-2 w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </Button>
            </CardContent>
          </Card>
        </div>

        {/* Security Section */}
        <Card className="bg-gradient-to-r from-slate-800 to-slate-900 border-0 text-white overflow-hidden fade-in-up delay-1400 hover:shadow-2xl transition-all duration-500">
          <CardContent className="p-12">
            <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
              <div className="space-y-6">
                <div className="bg-slate-700 text-white px-4 py-2 rounded-full text-sm font-medium inline-block transform hover:scale-105 transition-transform duration-300">
                  PRIVATE SECURITY
                </div>
                <h3 className="text-3xl md:text-4xl font-light">
                  Complete protection.
                  <span className="block text-slate-300">Absolute discretion.</span>
                </h3>
                <p className="text-slate-300 text-lg leading-relaxed">
                  Our comprehensive security services include 24/7 protection, executive security, 
                  risk assessment, and private surveillance. All delivered with the utmost 
                  professionalism and confidentiality.
                </p>
                <Button 
                  variant="outline" 
                  className="border-white text-white hover:bg-white hover:text-slate-900 px-8 py-3 group hover:scale-105 transition-all duration-300"
                >
                  Security Consultation <ArrowRight className="ml-2 w-4 h-4 group-hover:translate-x-2 transition-transform" />
                </Button>
              </div>
              <div className="aspect-[4/3] bg-gradient-to-br from-slate-700 to-slate-800 rounded-lg transform hover:scale-105 transition-transform duration-500"></div>
            </div>
          </CardContent>
        </Card>

        {/* CTA */}
        <div className="text-center mt-16 fade-in delay-1600">
          <h3 className="text-2xl font-light text-slate-900 mb-4">
            Ready to experience the difference?
          </h3>
          <p className="text-slate-600 mb-8 max-w-md mx-auto">
            Contact our team today for a personalized consultation and discover 
            how we can elevate your lifestyle.
          </p>
          <Button 
            size="lg" 
            className="bg-slate-900 hover:bg-black text-white px-8 py-4 text-lg group hover:scale-105 transition-all duration-300"
          >
            Get Started Today <ArrowRight className="ml-2 w-5 h-5 group-hover:translate-x-2 transition-transform" />
          </Button>
        </div>
      </div>
    </section>
  );
}