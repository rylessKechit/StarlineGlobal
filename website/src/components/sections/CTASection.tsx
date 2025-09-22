'use client';

import React, { useEffect, useRef } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { 
  ArrowRight, 
  Sparkles, 
  Shield, 
  Clock, 
  Globe,
  Phone,
  Mail,
  Calendar,
  CheckCircle
} from 'lucide-react';

export default function CTASection() {
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
              }, index * 100);
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

  const benefits = [
    {
      icon: Shield,
      title: "Complete Discretion",
      description: "Your privacy is our priority"
    },
    {
      icon: Globe,
      title: "Global Network", 
      description: "3 prestigious cities, unlimited possibilities"
    },
    {
      icon: Sparkles,
      title: "Bespoke Service",
      description: "Tailored to your unique needs"
    },
    {
      icon: Clock,
      title: "24/7 Availability",
      description: "Always here when you need us"
    }
  ];

  const services = [
    "Real Estate Advisory",
    "Private Aviation", 
    "Luxury Transportation",
    "Corporate Solutions",
    "Lifestyle Management",
    "Exclusive Events",
    "Private Security"
  ];

  return (
    <section ref={sectionRef} className="py-20 px-4 bg-white">
      <div className="container mx-auto max-w-6xl">
        
        {/* Header */}
        <div className="text-center mb-16 fade-in-up delay-200">
          <Badge className="mb-6 bg-gradient-to-r from-blue-100 to-purple-100 text-slate-700 hover:from-blue-200 hover:to-purple-200">
            ✨ Begin Your Journey
          </Badge>
          <h2 className="text-4xl md:text-5xl lg:text-6xl font-light text-slate-900 mb-6 leading-tight">
            Experience luxury
            <span className="block text-transparent bg-clip-text bg-gradient-to-r from-blue-600 via-purple-600 to-emerald-600">
              redefined.
            </span>
          </h2>
          <p className="text-xl text-slate-600 max-w-3xl mx-auto leading-relaxed">
            Join our exclusive community of discerning clients who understand that true luxury 
            lies in personalized experiences and uncompromising service excellence.
          </p>
        </div>

        {/* Benefits Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-16">
          {benefits.map((benefit, index) => {
            const IconComponent = benefit.icon;
            const colors = [
              'text-blue-600 bg-blue-50 hover:bg-blue-100',
              'text-emerald-600 bg-emerald-50 hover:bg-emerald-100', 
              'text-purple-600 bg-purple-50 hover:bg-purple-100',
              'text-amber-600 bg-amber-50 hover:bg-amber-100'
            ];
            return (
              <Card 
                key={benefit.title} 
                className="border border-slate-200 hover:shadow-lg transition-all duration-300 group service-card"
                style={{ animationDelay: `${400 + index * 100}ms` }}
              >
                <CardContent className="p-6 text-center">
                  <div className={`w-12 h-12 ${colors[index]} rounded-xl flex items-center justify-center mx-auto mb-4 group-hover:scale-110 transition-transform`}>
                    <IconComponent className="w-6 h-6" />
                  </div>
                  <h3 className="text-lg font-medium text-slate-900 mb-2">{benefit.title}</h3>
                  <p className="text-slate-600 text-sm leading-relaxed">{benefit.description}</p>
                </CardContent>
              </Card>
            );
          })}
        </div>

        {/* Main CTA Section */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center mb-16">
          
          {/* Left: Contact Form */}
          <Card className="border border-slate-200 shadow-xl slide-in-left delay-800">
            <CardContent className="p-8">
              <div className="space-y-6">
                <div className="space-y-2">
                  <h3 className="text-2xl font-light text-slate-900">
                    Start your luxury journey
                  </h3>
                  <p className="text-slate-600">
                    Schedule a personalized consultation with our team.
                  </p>
                </div>

                <div className="space-y-4">
                  <input 
                    type="text" 
                    placeholder="Your full name" 
                    className="w-full px-4 py-3 border border-slate-300 rounded-lg text-slate-900 placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                  />
                  <input 
                    type="email" 
                    placeholder="Email address" 
                    className="w-full px-4 py-3 border border-slate-300 rounded-lg text-slate-900 placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                  />
                  <input 
                    type="tel" 
                    placeholder="Phone number" 
                    className="w-full px-4 py-3 border border-slate-300 rounded-lg text-slate-900 placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                  />
                  <select className="w-full px-4 py-3 border border-slate-300 rounded-lg text-slate-900 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all">
                    <option value="">Select primary interest</option>
                    {services.map((service) => (
                      <option key={service} value={service.toLowerCase().replace(/\s+/g, '-')}>
                        {service}
                      </option>
                    ))}
                  </select>
                  <textarea 
                    placeholder="Tell us about your requirements..."
                    rows={4}
                    className="w-full px-4 py-3 border border-slate-300 rounded-lg text-slate-900 placeholder-slate-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all resize-none"
                  ></textarea>
                </div>

                <Button 
                  size="lg" 
                  className="w-full bg-gradient-to-r from-blue-600 to-purple-600 hover:from-blue-700 hover:to-purple-700 text-white py-6 text-lg group"
                >
                  Schedule Consultation
                  <ArrowRight className="ml-2 w-5 h-5 group-hover:translate-x-1 transition-transform" />
                </Button>

                <p className="text-sm text-slate-500 text-center">
                  Response guaranteed within 2 hours • Completely confidential
                </p>
              </div>
            </CardContent>
          </Card>

          {/* Right: Contact Information */}
          <div className="space-y-8 slide-in-right delay-1000">
            
            {/* Direct Contact */}
            <div className="space-y-6">
              <h3 className="text-2xl font-light text-slate-900">
                Prefer to speak directly?
              </h3>
              
              <div className="space-y-4">
                <div className="flex items-center space-x-4 group cursor-pointer p-4 rounded-lg hover:bg-slate-50 transition-colors">
                  <div className="w-12 h-12 bg-blue-100 rounded-full flex items-center justify-center group-hover:bg-blue-200 transition-colors">
                    <Phone className="w-6 h-6 text-blue-600" />
                  </div>
                  <div>
                    <p className="font-medium text-slate-900">Call us directly</p>
                    <p className="text-slate-600">UK: +44 7934 858 048</p>
                    <p className="text-slate-600">FR: +33 765 808 687</p>
                  </div>
                </div>

                <div className="flex items-center space-x-4 group cursor-pointer p-4 rounded-lg hover:bg-slate-50 transition-colors">
                  <div className="w-12 h-12 bg-emerald-100 rounded-full flex items-center justify-center group-hover:bg-emerald-200 transition-colors">
                    <Mail className="w-6 h-6 text-emerald-600" />
                  </div>
                  <div>
                    <p className="font-medium text-slate-900">Email our team</p>
                    <p className="text-slate-600">contact@starlaneglobal.com</p>
                  </div>
                </div>

                <div className="flex items-center space-x-4 group cursor-pointer p-4 rounded-lg hover:bg-slate-50 transition-colors">
                  <div className="w-12 h-12 bg-purple-100 rounded-full flex items-center justify-center group-hover:bg-purple-200 transition-colors">
                    <Calendar className="w-6 h-6 text-purple-600" />
                  </div>
                  <div>
                    <p className="font-medium text-slate-900">Office hours</p>
                    <p className="text-slate-600">Mon-Thu: 08:00-18:00</p>
                    <p className="text-slate-600">Fri-Sun: 07:00-19:00</p>
                  </div>
                </div>
              </div>
            </div>

            {/* What to Expect */}
            <Card className="bg-gradient-to-r from-slate-50 to-blue-50 border-0">
              <CardContent className="p-6">
                <h4 className="font-medium text-slate-900 mb-4">What to expect:</h4>
                <div className="space-y-3">
                  {[
                    "Personalized consultation call",
                    "Tailored service recommendations", 
                    "Transparent pricing discussion",
                    "Immediate next steps"
                  ].map((item) => (
                    <div key={item} className="flex items-center space-x-3">
                      <CheckCircle className="w-5 h-5 text-emerald-600 flex-shrink-0" />
                      <span className="text-slate-700">{item}</span>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Alternative Actions */}
            <div className="space-y-4">
              <Button 
                variant="outline" 
                size="lg" 
                className="w-full border-slate-300 text-slate-700 hover:bg-slate-50 py-4 text-lg group"
              >
                <Sparkles className="mr-2 w-5 h-5" />
                Explore Our Services
                <ArrowRight className="ml-2 w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </Button>
              
              <Button 
                variant="ghost" 
                size="lg" 
                className="w-full text-slate-600 hover:text-slate-900 hover:bg-slate-50 py-4 text-lg"
              >
                Download Service Brochure
              </Button>
            </div>
          </div>
        </div>

        {/* Trust Indicators */}
        <div className="text-center fade-in delay-1200">
          <Card className="border-0 bg-slate-50">
            <CardContent className="p-8">
              <h4 className="text-lg font-medium text-slate-900 mb-6">
                Trusted by 1000+ premium clients worldwide
              </h4>
              
              {/* Global Cities */}
              <div className="flex flex-wrap justify-center items-center gap-8 opacity-60">
                <div className="flex items-center space-x-2">
                  <div className="w-2 h-2 bg-blue-400 rounded-full"></div>
                  <span className="text-slate-600 font-medium">London</span>
                </div>
                <div className="w-px h-4 bg-slate-300"></div>
                <div className="flex items-center space-x-2">
                  <div className="w-2 h-2 bg-emerald-400 rounded-full"></div>
                  <span className="text-slate-600 font-medium">New York</span>
                </div>
                <div className="w-px h-4 bg-slate-300"></div>
                <div className="flex items-center space-x-2">
                  <div className="w-2 h-2 bg-purple-400 rounded-full"></div>
                  <span className="text-slate-600 font-medium">Paris</span>
                </div>
              </div>

              {/* Commitment */}
              <div className="mt-8 pt-6 border-t border-slate-200">
                <p className="text-slate-600 italic">
                  "We are committed to delivering exceptional service that transcends borders, 
                  making your luxury experience truly extraordinary."
                </p>
              </div>
            </CardContent>
          </Card>
        </div>

        {/* Final Headline */}
        <div className="text-center mt-16 fade-in-up delay-1400">
          <h3 className="text-3xl md:text-4xl font-light text-slate-900 mb-4">
            Your extraordinary life
            <span className="block text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600">
              starts here.
            </span>
          </h3>
          <p className="text-slate-600 max-w-2xl mx-auto leading-relaxed">
            Join the exclusive community of global citizens who choose Starlane Global 
            for unparalleled luxury experiences that celebrate diversity and excellence.
          </p>
        </div>
      </div>
    </section>
  );
}