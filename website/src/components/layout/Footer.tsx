import React from 'react';
import { Sparkles, Phone, Mail, MapPin, Clock } from 'lucide-react';
import { Separator } from '@/components/ui/separator';

export default function Footer() {
  const currentYear = new Date().getFullYear();

  return (
    <footer className="bg-slate-900 text-white">
      <div className="container mx-auto px-4 py-16">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
          {/* Company Info */}
          <div className="space-y-4">
            <div className="flex items-center space-x-2">
              <div className="w-8 h-8 bg-gradient-to-r from-blue-600 to-purple-600 rounded-lg flex items-center justify-center">
                <Sparkles className="w-5 h-5 text-white" />
              </div>
              <div>
                <h3 className="text-lg font-bold">STARLANE GLOBAL</h3>
                <p className="text-xs text-slate-400">Luxury Services & Lifestyle</p>
              </div>
            </div>
            <p className="text-slate-300 text-sm leading-relaxed">
              Delivering exceptional luxury experiences that transcend borders, 
              proving that diversity enhances rather than limits luxury.
            </p>
          </div>

          {/* Services */}
          <div className="space-y-4">
            <h4 className="text-lg font-semibold text-blue-400">Services</h4>
            <ul className="space-y-2 text-sm">
              <li><a href="#" className="text-slate-300 hover:text-blue-400 transition-colors">Real Estate</a></li>
              <li><a href="#" className="text-slate-300 hover:text-emerald-400 transition-colors">Air Travel</a></li>
              <li><a href="#" className="text-slate-300 hover:text-purple-400 transition-colors">Transport</a></li>
              <li><a href="#" className="text-slate-300 hover:text-amber-400 transition-colors">Corporate Services</a></li>
              <li><a href="#" className="text-slate-300 hover:text-pink-400 transition-colors">Lifestyle Management</a></li>
              <li><a href="#" className="text-slate-300 hover:text-indigo-400 transition-colors">Exclusive Events</a></li>
              <li><a href="#" className="text-slate-300 hover:text-rose-400 transition-colors">Private Security</a></li>
            </ul>
          </div>

          {/* Contact Info */}
          <div className="space-y-4">
            <h4 className="text-lg font-semibold text-emerald-400">Contact</h4>
            <div className="space-y-3 text-sm">
              <div className="flex items-center space-x-2">
                <Mail className="w-4 h-4 text-blue-400" />
                <span className="text-slate-300">contact@starlaneglobal.com</span>
              </div>
              <div className="flex items-center space-x-2">
                <Phone className="w-4 h-4 text-emerald-400" />
                <span className="text-slate-300">UK: +44 7934 858 048</span>
              </div>
              <div className="flex items-center space-x-2">
                <Phone className="w-4 h-4 text-purple-400" />
                <span className="text-slate-300">FR: +33 765 808 687</span>
              </div>
            </div>
          </div>

          {/* London Office */}
          <div className="space-y-4">
            <h4 className="text-lg font-semibold text-purple-400">London Office</h4>
            <div className="space-y-3 text-sm">
              <div className="flex items-start space-x-2">
                <MapPin className="w-4 h-4 text-amber-400 mt-1" />
                <span className="text-slate-300">
                  45 Fitzroy Street<br />
                  Fitzrovia, W1T 6EB<br />
                  London, UK
                </span>
              </div>
              <div className="flex items-start space-x-2">
                <Clock className="w-4 h-4 text-pink-400 mt-1" />
                <div className="text-slate-300">
                  <p>Mon-Thu: 08:00-18:00</p>
                  <p>Fri-Sun: 07:00-19:00</p>
                </div>
              </div>
            </div>
          </div>
        </div>

        <Separator className="my-8 bg-slate-700" />

        <div className="flex flex-col md:flex-row justify-between items-center space-y-4 md:space-y-0">
          <p className="text-slate-400 text-sm">
            © {currentYear} Starlane Global. All rights reserved.
          </p>
          <div className="flex space-x-6 text-sm">
            <a href="#" className="text-slate-400 hover:text-blue-400 transition-colors">Privacy Policy</a>
            <a href="#" className="text-slate-400 hover:text-purple-400 transition-colors">Terms of Service</a>
            <a href="#" className="text-slate-400 hover:text-emerald-400 transition-colors">Cookie Policy</a>
          </div>
        </div>
      </div>
    </footer>
  );
}