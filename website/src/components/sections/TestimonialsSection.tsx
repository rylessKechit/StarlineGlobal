'use client';

import React, { useEffect, useRef } from 'react';
import { Card, CardContent } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Star, Quote } from 'lucide-react';

export default function TestimonialsSection() {
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
              }, index * 150);
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

  const testimonials = [
    {
      name: "Alexandra Chen",
      role: "CEO, Tech Innovate",
      company: "Fortune 500",
      content: "Starlane Global transformed our corporate events across three continents. Their attention to detail and commitment to diversity created experiences our international team will never forget.",
      rating: 5,
      initials: "AC",
      color: "bg-blue-600"
    },
    {
      name: "Marcus Williams", 
      role: "Private Investor",
      company: "Real Estate",
      content: "From London to Dubai, every service exceeded expectations. Their global network and personalized approach truly set them apart in the luxury industry.",
      rating: 5,
      initials: "MW",
      color: "bg-emerald-600"
    },
    {
      name: "Sofia Rodriguez",
      role: "Art Collector",
      company: "Cultural Patron",
      content: "Finding exclusive cultural experiences through Starlane has enriched my life immeasurably. They understand that luxury means different things to different people.",
      rating: 5,
      initials: "SR",
      color: "bg-purple-600"
    },
    {
      name: "James Thompson",
      role: "Entrepreneur",
      company: "Tech Startup",
      content: "The 24/7 concierge service is exceptional. Whether organizing events in Paris or securing last-minute travel, they deliver with unmatched professionalism.",
      rating: 5,
      initials: "JT",
      color: "bg-amber-600"
    },
    {
      name: "Priya Sharma",
      role: "Marketing Director", 
      company: "Global Brand",
      content: "Their approach to diversity in luxury is revolutionary. As a business leader, I feel truly understood and valued. Starlane redefines excellence.",
      rating: 5,
      initials: "PS",
      color: "bg-rose-600"
    },
    {
      name: "David Kim",
      role: "Investment Banker",
      company: "Financial Services",
      content: "Security and transportation services are world-class. Discretion, professionalism, and attention to detail - exactly what high-profile clients need.",
      rating: 5,
      initials: "DK",
      color: "bg-slate-600"
    }
  ];

  const renderStars = (rating: any) => {
    return [...Array(5)].map((_, i) => (
      <Star 
        key={i} 
        className={`w-4 h-4 ${i < rating ? 'text-amber-400 fill-current' : 'text-slate-300'}`} 
      />
    ));
  };

  return (
    <section ref={sectionRef} className="py-20 px-4 bg-slate-50">
      <div className="container mx-auto max-w-7xl">
        
        {/* Header */}
        <div className="text-center mb-16 fade-in-up delay-200">
          <Badge className="mb-4 bg-slate-200 text-slate-700 hover:bg-slate-300">
            Client Success Stories
          </Badge>
          <h2 className="text-4xl md:text-5xl font-light text-slate-900 mb-6">
            Trusted by leaders
            <span className="block text-purple-700">worldwide.</span>
          </h2>
          <p className="text-xl text-slate-600 max-w-3xl mx-auto leading-relaxed">
            Discover how we've transformed experiences for discerning clients across industries, 
            creating moments that exceed expectations and redefine luxury.
          </p>
        </div>

        {/* Testimonials Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 mb-16">
          {testimonials.map((testimonial, index) => (
            <Card 
              key={testimonial.name} 
              className="group hover:shadow-xl transition-all duration-500 hover:-translate-y-2 border-0 bg-white service-card"
              style={{ animationDelay: `${400 + index * 150}ms` }}
            >
              <CardContent className="p-8 space-y-6">
                {/* Quote icon */}
                <div className="relative">
                  <Quote className="w-8 h-8 text-slate-300 opacity-50" />
                </div>

                {/* Rating */}
                <div className="flex space-x-1">
                  {renderStars(testimonial.rating)}
                </div>

                {/* Content */}
                <blockquote className="text-slate-700 leading-relaxed italic">
                  "{testimonial.content}"
                </blockquote>

                {/* Author */}
                <div className="flex items-center space-x-4 pt-4 border-t border-slate-100">
                  <div className={`w-12 h-12 ${testimonial.color} rounded-full flex items-center justify-center group-hover:scale-110 transition-transform`}>
                    <span className="text-white font-bold text-sm">{testimonial.initials}</span>
                  </div>
                  <div>
                    <h4 className="font-medium text-slate-900">{testimonial.name}</h4>
                    <p className="text-sm text-slate-600">{testimonial.role}</p>
                    <p className="text-xs text-slate-500">{testimonial.company}</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>

        {/* Stats Section */}
        <div className="grid grid-cols-2 md:grid-cols-4 gap-8 text-center mb-16 fade-in-up delay-1200">
          <div className="space-y-2 group cursor-pointer">
            <div className="text-4xl md:text-5xl font-light text-slate-900 group-hover:text-blue-700 transition-colors">1000+</div>
            <div className="text-slate-600 font-medium">Satisfied Clients</div>
            <div className="w-8 h-px bg-blue-400 mx-auto opacity-0 group-hover:opacity-100 transition-opacity"></div>
          </div>
          <div className="space-y-2 group cursor-pointer">
            <div className="text-4xl md:text-5xl font-light text-emerald-600">5.0★</div>
            <div className="text-slate-600 font-medium">Average Rating</div>
            <div className="w-8 h-px bg-emerald-400 mx-auto opacity-0 group-hover:opacity-100 transition-opacity"></div>
          </div>
          <div className="space-y-2 group cursor-pointer">
            <div className="text-4xl md:text-5xl font-light text-slate-900 group-hover:text-purple-700 transition-colors">25+</div>
            <div className="text-slate-600 font-medium">Countries Served</div>
            <div className="w-8 h-px bg-purple-400 mx-auto opacity-0 group-hover:opacity-100 transition-opacity"></div>
          </div>
          <div className="space-y-2 group cursor-pointer">
            <div className="text-4xl md:text-5xl font-light text-amber-600">24/7</div>
            <div className="text-slate-600 font-medium">Global Support</div>
            <div className="w-8 h-px bg-amber-400 mx-auto opacity-0 group-hover:opacity-100 transition-opacity"></div>
          </div>
        </div>

        {/* Featured Quote */}
        <div className="max-w-4xl mx-auto text-center fade-in-up delay-1400">
          <Card className="border-0 shadow-xl bg-gradient-to-r from-slate-800 to-slate-900 text-white overflow-hidden">
            <CardContent className="p-12">
              <Quote className="w-12 h-12 text-amber-400 mx-auto mb-6 opacity-50" />
              <blockquote className="text-2xl md:text-3xl font-light leading-relaxed mb-8 italic">
                "We don't just meet expectations – we redefine what's possible when 
                diversity and luxury intersect."
              </blockquote>
              <div className="flex items-center justify-center space-x-4">
                <div className="w-1 h-12 bg-gradient-to-b from-amber-400 to-transparent"></div>
                <div className="text-center">
                  <p className="font-medium text-amber-400">Starlane Global</p>
                  <p className="text-sm text-slate-400">Philosophy</p>
                </div>
                <div className="w-1 h-12 bg-gradient-to-b from-amber-400 to-transparent"></div>
              </div>
            </CardContent>
          </Card>
        </div>
      </div>
    </section>
  );
}