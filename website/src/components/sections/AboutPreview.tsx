import React from 'react';
import { Card, CardContent } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { ArrowRight, Users, Globe, Award, Heart } from 'lucide-react';

export default function AboutPreview() {
  return (
    <section className="py-20 px-4 bg-white">
      <div className="container mx-auto max-w-7xl">
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-16 items-center">
          
          {/* Left content */}
          <div className="space-y-8">
            <div className="space-y-6">
              <h2 className="text-4xl md:text-5xl font-light text-slate-900 leading-tight">
                Diversity drives
                <span className="block text-emerald-700">our excellence.</span>
              </h2>
              
              <p className="text-xl text-slate-700 leading-relaxed">
                At Starlane Global, we believe that diversity enhances rather than limits luxury. 
                Our commitment to inclusion creates richer, more meaningful experiences for every client.
              </p>
              
              <p className="text-lg text-slate-600 leading-relaxed">
                We're dedicated to breaking societal barriers by championing diversity in luxury services. 
                Through collaboration with our global partners, we create extraordinary experiences 
                that redefine what luxury means in the modern world.
              </p>
            </div>

            {/* Team values */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div className="flex items-start space-x-4">
                <div className="w-10 h-10 bg-emerald-100 rounded-full flex items-center justify-center flex-shrink-0">
                  <Heart className="w-5 h-5 text-emerald-700" />
                </div>
                <div>
                  <h4 className="font-medium text-slate-900 mb-1">Inclusive Excellence</h4>
                  <p className="text-sm text-slate-600">Celebrating diversity in every experience we create</p>
                </div>
              </div>
              
              <div className="flex items-start space-x-4">
                <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center flex-shrink-0">
                  <Users className="w-5 h-5 text-blue-700" />
                </div>
                <div>
                  <h4 className="font-medium text-slate-900 mb-1">Personal Attention</h4>
                  <p className="text-sm text-slate-600">Dedicated account management that understands you</p>
                </div>
              </div>
              
              <div className="flex items-start space-x-4">
                <div className="w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center flex-shrink-0">
                  <Globe className="w-5 h-5 text-purple-700" />
                </div>
                <div>
                  <h4 className="font-medium text-slate-900 mb-1">Global Network</h4>
                  <p className="text-sm text-slate-600">Elite partners in prestigious cities worldwide</p>
                </div>
              </div>
              
              <div className="flex items-start space-x-4">
                <div className="w-10 h-10 bg-amber-100 rounded-full flex items-center justify-center flex-shrink-0">
                  <Award className="w-5 h-5 text-amber-700" />
                </div>
                <div>
                  <h4 className="font-medium text-slate-900 mb-1">Proven Excellence</h4>
                  <p className="text-sm text-slate-600">1000+ satisfied clients across 5 global cities</p>
                </div>
              </div>
            </div>

            <Button 
              size="lg" 
              className="bg-emerald-700 hover:bg-emerald-800 text-white px-8 py-4"
            >
              Learn Our Story <ArrowRight className="ml-2 w-5 h-5" />
            </Button>
          </div>

          {/* Right side - Team and stats */}
          <div className="space-y-8">
            
            {/* Leadership team */}
            <Card className="bg-slate-50 border-0">
              <CardContent className="p-8">
                <h3 className="text-xl font-medium text-slate-900 mb-6">Leadership Team</h3>
                <div className="space-y-4">
                  {[
                    { name: "Emmanuel", role: "Co-founder London", color: "bg-amber-600" },
                    { name: "Jaken", role: "Co-founder Paris", color: "bg-blue-600" },
                    { name: "Jessica", role: "Meet & Greet Director", color: "bg-amber-600" },
                    { name: "Godfrey", role: "Operations Director", color: "bg-emerald-600" },
                    { name: "Sylvia", role: "Client Relations", color: "bg-purple-600" },
                    { name: "Alisha", role: "Lifestyle Manager", color: "bg-rose-600" }
                  ].map((member) => (
                    <div key={member.name} className="flex items-center space-x-4">
                      <div className={`w-10 h-10 ${member.color} rounded-full flex items-center justify-center`}>
                        <span className="text-white font-medium text-sm">{member.name.charAt(0)}</span>
                      </div>
                      <div>
                        <p className="font-medium text-slate-900">{member.name}</p>
                        <p className="text-sm text-slate-600">{member.role}</p>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>

            {/* Quick stats */}
            <div className="grid grid-cols-2 gap-6">
              <Card className="bg-white border border-slate-200">
                <CardContent className="p-6 text-center">
                  <div className="text-3xl font-light text-slate-900 mb-2">3</div>
                  <div className="text-sm text-slate-600">Global Cities</div>
                  <div className="text-xs text-slate-500 mt-1">London • New York • Paris</div>
                </CardContent>
              </Card>
              
              <Card className="bg-white border border-slate-200">
                <CardContent className="p-6 text-center">
                  <div className="text-3xl font-light text-slate-900 mb-2">24/7</div>
                  <div className="text-sm text-slate-600">Availability</div>
                  <div className="text-xs text-slate-500 mt-1">Round-the-clock premium support</div>
                </CardContent>
              </Card>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}