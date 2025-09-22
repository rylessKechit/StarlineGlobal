import { Metadata } from 'next';
import BookingPage from '@/components/client/BookingPage';

export const metadata: Metadata = {
  title: 'Mes Réservations - Starlane Global',
  description: 'Gérez vos réservations de services de luxe avec Starlane Global',
};

export default function ClientBookingsPage() {
  return <BookingPage />;
}