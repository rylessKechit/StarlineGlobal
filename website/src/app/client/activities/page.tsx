import { Metadata } from 'next';
import ActivitiesPage from '@/components/client/ActivitiesPage';

export const metadata: Metadata = {
  title: 'Activités - Starlane Global',
  description: 'Découvrez et réservez des expériences de luxe exceptionnelles',
};

export default function ClientActivitiesPage() {
  return <ActivitiesPage />;
}