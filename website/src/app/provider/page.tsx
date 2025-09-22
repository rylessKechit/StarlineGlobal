'use client';

import { Metadata } from 'next';
import { useRouter } from 'next/navigation';
import ProviderDashboard from '@/components/dashboards/ProviderDashboard';

// Client wrapper component
function ProviderDashboardWrapper() {
  const router = useRouter();
  
  const handleNavigate = (section: string) => {
    if (section === 'add-activity') {
      router.push('/provider/activities/new');
    } else if (section === 'manage-activities') {
      router.push('/provider/activities');
    } else if (section === 'all-bookings') {
      router.push('/provider/bookings');
    }
  };

  return <ProviderDashboard onNavigate={handleNavigate} />;
}

export default function ProviderDashboardPage() {
  return <ProviderDashboardWrapper />;
}