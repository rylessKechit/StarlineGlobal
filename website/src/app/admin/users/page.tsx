import { Metadata } from 'next';
import UsersManagementPage from '@/components/admin/UsersManagementPage';

export const metadata: Metadata = {
  title: 'Gestion des Utilisateurs - Starlane Global',
  description: 'Gérez tous les utilisateurs de la plateforme Starlane Global',
};

export default function AdminUsersPage() {
  return <UsersManagementPage />;
}