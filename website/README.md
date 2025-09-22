# Starlane Global - Luxury Services Platform

> Plateforme de services de luxe premium avec Next.js - Redéfinir le luxe à travers la diversité

## 🌟 À propos

Starlane Global est une entreprise de services de luxe globaux qui opère dans les villes les plus prestigieuses du monde. Notre mission est de prouver que la diversité enrichit plutôt que limite le luxe, en offrant des expériences sur-mesure exceptionnelles.

## 🚀 Stack Technique

- **Framework:** Next.js 14+ (App Router)
- **Styling:** Tailwind CSS + shadcn/ui
- **Language:** TypeScript
- **Icons:** Lucide React
- **Components:** shadcn/ui (Button, Card, Input, etc.)
- **Animations:** Framer Motion (recommandé)
- **Forms:** React Hook Form + Zod
- **Database:** Prisma + PostgreSQL (à venir)
- **Auth:** NextAuth.js (à venir)
- **CMS:** Sanity.io (optionnel)

## 📁 Structure du Projet

```
starlane-global/
├──src/
    ├── app/
    │   ├── (routes)/
    │   │   ├── page.tsx                    # Landing Page
    │   │   ├── services/
    │   │   │   ├── real-estate/page.tsx
    │   │   │   ├── air-travel/page.tsx
    │   │   │   ├── transport/page.tsx
    │   │   │   ├── corporate/page.tsx
    │   │   │   ├── lifestyle/page.tsx
    │   │   │   ├── events/page.tsx
    │   │   │   └── security/page.tsx
    │   │   ├── about/page.tsx
    │   │   ├── membership/page.tsx
    │   │   └── contact/page.tsx
    │   ├── globals.css
    │   ├── layout.tsx
    │   └── loading.tsx
    ├── components/
    │   ├── ui/                            # Composants UI de base
    │   │   ├── button.tsx
    │   │   ├── card.tsx
    │   │   ├── input.tsx
    │   │   └── ...
    │   ├── layout/                        # Composants de layout
    │   │   ├── header.tsx
    │   │   ├── footer.tsx
    │   │   └── navigation.tsx
    │   ├── sections/                      # Sections de la landing page
    │   │   ├── hero-section.tsx
    │   │   ├── services-overview.tsx
    │   │   ├── about-preview.tsx
    │   │   ├── locations-section.tsx
    │   │   ├── testimonials.tsx
    │   │   └── cta-section.tsx
    │   └── common/                        # Composants réutilisables
    │       ├── service-card.tsx
    │       ├── location-card.tsx
    │       └── contact-info.tsx
    ├── lib/
    │   ├── utils.ts
    │   ├── constants.ts
    │   └── types.ts
    ├── public/
    │   ├── images/
    │   ├── icons/
    │   └── ...
    └── styles/
        └── globals.css
```

## 🎨 Design System

### Palette de Couleurs

```css
/* Primary - Luxe doré */
--gold-50: #fefdf4
--gold-100: #fef7cd
--gold-500: #d4af37
--gold-900: #744210

/* Secondary - Bleu professionnel */
--navy-50: #f8fafc
--navy-500: #0f172a
--navy-900: #020617

/* Accent - Diversité */
--emerald-500: #10b981
--purple-500: #8b5cf6
```

### Typographie

- **Headings:** Inter ou Montserrat (Premium feel)
- **Body:** Inter (Lisibilité optimale)
- **Accent:** Playfair Display (Élégance)

## 🏗️ Installation & Setup

```bash
# Cloner le repository
git clone <repository-url>
cd starlane-global

# Installer les dépendances
npm install

# Installer shadcn/ui
npx shadcn-ui@latest init
npx shadcn-ui@latest add button card input badge separator

# Copier les variables d'environnement
cp .env.example .env.local

# Lancer le serveur de développement
npm run dev
```

## 📱 Composants Landing Page

### 1. Hero Section

- **Fonction:** Première impression premium
- **Éléments:**
  - Titre principal avec animation
  - Sous-titre sur la diversité
  - CTA vers membership
  - Vidéo/image background de luxe

### 2. Services Overview

- **Fonction:** Présentation des 7 services principaux
- **Éléments:**
  - Grid responsive des services
  - Icons personnalisés
  - Hover effects elegants
  - Quick navigation

### 3. About Preview

- **Fonction:** Valeurs et mission
- **Éléments:**
  - Message sur la diversité
  - Stats impressionnantes
  - Photos de l'équipe
  - Link vers page About complète

### 4. Global Locations

- **Fonction:** Présence internationale
- **Éléments:**
  - Carte interactive ou statique
  - 5 villes principales
  - Informations de contact locales
  - Heures d'ouverture

### 5. Testimonials

- **Fonction:** Social proof
- **Éléments:**
  - Témoignages clients (à créer)
  - Carousel ou grid
  - Photos/avatars
  - Ratings 5 étoiles

### 6. CTA Final

- **Fonction:** Conversion membership
- **Éléments:**
  - Message fort sur l'exclusivité
  - Formulaire de contact rapide
  - Boutons d'action multiples
  - Informations de contact

## 🌐 Fonctionnalités Clés

- ✅ **Responsive Design** - Mobile-first approach
- ✅ **SEO Optimized** - Meta tags, sitemap, structured data
- ✅ **Performance** - Image optimization, lazy loading
- ✅ **Accessibility** - WCAG 2.1 compliant
- 🔄 **Internationalization** - FR/EN (Phase 2)
- 🔄 **Member Portal** - Espace client sécurisé (Phase 2)
- 🔄 **Booking System** - Réservations en ligne (Phase 2)
- 🔄 **CMS Integration** - Gestion de contenu (Phase 2)

## 📊 Métriques de Performance Cibles

- **Lighthouse Score:** 95+
- **First Contentful Paint:** < 1.5s
- **Largest Contentful Paint:** < 2.5s
- **Cumulative Layout Shift:** < 0.1

## 🔐 Variables d'Environnement

```env
# Site
NEXT_PUBLIC_SITE_URL=https://starlaneglobal.com
NEXT_PUBLIC_SITE_NAME="Starlane Global"

# Contact
NEXT_PUBLIC_CONTACT_EMAIL=contact@starlaneglobal.com
NEXT_PUBLIC_CONTACT_UK="+44 7934 858 048"
NEXT_PUBLIC_CONTACT_FR="+33 765 808 687"

# Adresse Bureau Londres
NEXT_PUBLIC_LONDON_ADDRESS="45 Fitzroy Street, Fitzrovia, W1T 6EB"
```

## 🚦 Roadmap de Développement

### Phase 1 - MVP (2-3 semaines)

- [x] Setup projet Next.js
- [ ] Landing page complète
- [ ] Pages services statiques
- [ ] Responsive design
- [ ] SEO de base

### Phase 2 - Enrichissement (2-3 semaines)

- [ ] Système de formulaires
- [ ] Animations avancées
- [ ] Optimisations performance
- [ ] Tests automatisés

### Phase 3 - Fonctionnalités Avancées (3-4 semaines)

- [ ] Espace membre
- [ ] Système de réservation
- [ ] CMS intégration
- [ ] Internationalisation

## 📞 Contact & Support

- **Email:** contact@starlaneglobal.com
- **UK:** +44 7934 858 048
- **FR:** +33 765 808 687
- **Adresse:** 45 Fitzroy Street, Fitzrovia, W1T 6EB, London

---

_Développé avec ❤️ pour redéfinir le luxe à travers la diversité_
