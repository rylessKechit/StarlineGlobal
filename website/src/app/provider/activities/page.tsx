'use client';

import { Metadata } from 'next';
import { useRouter } from 'next/navigation';
import ManageActivitiesPage from '@/components/provider/ManageActivitiesPage';

// Client wrapper component
function ManageActivitiesWrapper() {
  const router = useRouter();
  
  const handleNavigate = (section: string) => {
    if (section === 'add-activity') {
      router.push('/provider/activities/new');
    } else if (section === 'provider-dashboard') {
      router.push('/provider');
    }
  };

  return <ManageActivitiesPage onNavigate={handleNavigate} />;
}

export default function ProviderActivitiesPage() {
  return <ManageActivitiesWrapper />;
}