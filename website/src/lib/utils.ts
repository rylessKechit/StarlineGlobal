import { type ClassValue, clsx } from "clsx"
import { twMerge } from "tailwind-merge"

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs))
}

// Utility functions for Starlane Global

export const CONTACT_INFO = {
  email: 'contact@starlaneglobal.com',
  phone: {
    uk: '+44 7934 858 048',
    fr: '+33 765 808 687'
  },
  address: {
    street: '45 Fitzroy Street',
    area: 'Fitzrovia',
    postcode: 'W1T 6EB',
    city: 'London',
    country: 'UK'
  },
  hours: {
    weekdays: 'Monday - Thursday: 08:00-18:00',
    weekend: 'Friday - Sunday: 07:00-19:00'
  }
} as const;

export const SERVICES = [
  'Real Estate',
  'Air Travel', 
  'Transport',
  'Corporate',
  'Lifestyle',
  'Exclusive Events',
  'Private Security'
] as const;

export const LOCATIONS = [
  'London',
  'New York', 
  'Paris',
] as const;

// Format phone number for display
export function formatPhoneNumber(phone: string): string {
  return phone.replace(/(\+\d{2})(\s)(\d{4})(\s)(\d{3})(\s)(\d{3})/, '$1 $3 $5 $7');
}

// Validate email format
export function isValidEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

// Generate smooth scroll to element
export function scrollToElement(elementId: string): void {
  const element = document.getElementById(elementId);
  if (element) {
    element.scrollIntoView({ 
      behavior: 'smooth',
      block: 'start',
      inline: 'nearest'
    });
  }
}

// Format currency for pricing displays
export function formatCurrency(amount: number, currency: string = 'GBP'): string {
  return new Intl.NumberFormat('en-GB', {
    style: 'currency',
    currency: currency,
    minimumFractionDigits: 0,
    maximumFractionDigits: 0,
  }).format(amount);
}

// Delay function for animations
export function delay(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}