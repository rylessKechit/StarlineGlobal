'use client';

import { Metadata } from 'next';
import { useRouter } from 'next/navigation';
import AddActivityPage from '@/components/provider/AddActivityPage';

// Client wrapper component
function AddActivityWrapper() {
  const router = useRouter();
  
  const handleNavigate = (section: string) => {
    if (section === 'provider-dashboard') {
      router.push('/provider');
    } else if (section === 'manage-activities') {
      router.push('/provider/activities');
    }
  };

  return <AddActivityPage onNavigate={handleNavigate} />;
}

export default function NewActivityPage() {
  return <AddActivityWrapper />;
}