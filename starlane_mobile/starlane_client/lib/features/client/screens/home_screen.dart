// Path: starlane_mobile/starlane_client/lib/features/client/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';

// Sections
import '../widgets/home_header_section.dart';
import '../widgets/search_section.dart';
import '../widgets/categories_grid_section.dart';
import '../widgets/featured_services_section.dart';

// Blocs et repositories
import '../bloc/activity_bloc.dart';
import '../bloc/service_bloc.dart';
import '../repositories/activity_repository.dart';
import '../repositories/service_repository.dart';
import '../../../data/api/api_client.dart';
import '../../../data/api/service_api_client.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategoryTap(String categoryId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigation vers $categoryId - À implémenter'),
        backgroundColor: StarlaneColors.emerald500,
      ),
    );
  }

  void _onServiceTap(String serviceId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Détails du service $serviceId - À implémenter'),
        backgroundColor: StarlaneColors.navy500,
      ),
    );
  }

  void _onSearchChanged(String query) {
    // TODO: Implémenter la recherche avec les blocs
    if (query.isNotEmpty) {
      // Pour l'instant, on utilise encore ActivityBloc pour la recherche
      // car les services n'ont pas de fonction de recherche textuelle
      context.read<ActivityBloc>().add(
        ActivitySearchRequested(query: query),
      );
    }
    print('Recherche: $query');
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provider pour ActivityBloc (pour la recherche et autres fonctionnalités)
        BlocProvider<ActivityBloc>(
          create: (context) => ActivityBloc(
            activityRepository: context.read<ActivityRepository>(),
          ),
        ),
        // Provider pour ServiceBloc (pour les services phares)
        BlocProvider<ServiceBloc>(
          create: (context) => ServiceBloc(
            serviceRepository: context.read<ServiceRepository>(),
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: StarlaneColors.gray50,
        body: Column(
          children: [
            // ✅ HEADER FIXE (ne scroll pas)
            const HomeHeaderSection(),

            // ✅ BARRE DE RECHERCHE AVEC CONTAINER ET OMBRE
            Container(
              decoration: BoxDecoration(
                color: StarlaneColors.white,
                boxShadow: [
                  BoxShadow(
                    color: StarlaneColors.black.withOpacity(0.08),
                    blurRadius: 8.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(height: 16.h),
                  SearchSection(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
            
            // ✅ CONTENU SCROLLABLE
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  // Rafraîchir les deux types de données
                  context.read<ActivityBloc>()
                      .add(ActivityFeaturedLoadRequested());
                  context.read<ServiceBloc>()
                      .add(ServiceFeaturedLoadRequested());
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 8.h),
                      
                      // Grille des catégories 2x2
                      CategoriesGridSection(
                        onCategoryTap: _onCategoryTap,
                      ),
                      
                      SizedBox(height: 6.h),
                      
                      // ✅ SERVICES PHARES - UTILISE MAINTENANT ServiceBloc
                      FeaturedServicesSection(
                        onServiceTap: _onServiceTap,
                      ),
                      
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}