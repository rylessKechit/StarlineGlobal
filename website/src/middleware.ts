import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  // Get user info from cookies (you'll need to implement this based on your auth system)
  const userRole = request.cookies.get('userRole')?.value;
  const isAuthenticated = request.cookies.get('isAuthenticated')?.value === 'true';
  
  const { pathname } = request.nextUrl;

  // Protect client routes
  if (pathname.startsWith('/client')) {
    if (!isAuthenticated) {
      return NextResponse.redirect(new URL('/auth/login', request.url));
    }
    if (userRole !== 'client') {
      return NextResponse.redirect(new URL('/auth/login', request.url));
    }
  }

  // Protect provider routes
  if (pathname.startsWith('/provider')) {
    if (!isAuthenticated) {
      return NextResponse.redirect(new URL('/auth/login', request.url));
    }
    if (userRole !== 'prestataire') {
      return NextResponse.redirect(new URL('/auth/login', request.url));
    }
  }

  // Protect admin routes
  if (pathname.startsWith('/admin')) {
    if (!isAuthenticated) {
      return NextResponse.redirect(new URL('/auth/login', request.url));
    }
    if (userRole !== 'admin') {
      return NextResponse.redirect(new URL('/auth/login', request.url));
    }
  }

  // Redirect authenticated users away from auth pages
  if (pathname.startsWith('/auth') && isAuthenticated) {
    if (userRole === 'client') {
      return NextResponse.redirect(new URL('/client', request.url));
    }
    if (userRole === 'prestataire') {
      return NextResponse.redirect(new URL('/provider', request.url));
    }
    if (userRole === 'admin') {
      return NextResponse.redirect(new URL('/admin', request.url));
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     * - public folder
     */
    '/((?!api|_next/static|_next/image|favicon.ico|public).*)',
  ],
};