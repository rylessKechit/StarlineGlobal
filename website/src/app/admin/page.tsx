'use client';

import { Metadata } from 'next';
import { useRouter } from 'next/navigation';
import AdminDashboard from '@/components/dashboards/AdminDashboard';

// Client wrapper component
function AdminDashboardWrapper() {
  const router = useRouter();
  
  const handleNavigate = (section: string) => {
    if (section === 'users') {
      router.push('/admin/users');
    } else if (section === 'providers') {
      router.push('/admin/providers');
    } else if (section === 'analytics') {
      router.push('/admin/analytics');
    } else if (section === 'all-bookings') {
      router.push('/admin/bookings');
    } else if (section === 'activity-logs') {
      router.push('/admin/logs');
    }
  };

  return <AdminDashboard onNavigate={handleNavigate} />;
}

export default function AdminDashboardPage() {
  return <AdminDashboardWrapper />;
}