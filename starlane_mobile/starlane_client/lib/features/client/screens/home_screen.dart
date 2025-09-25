import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';
import '../../../data/models/service.dart';

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

  void _onServiceTap(Service service) {
    context.push('/service/${service.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StarlaneColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header avec avatar et notifications
              const HomeHeaderSection(),
              
              // Section de recherche
              SearchSection(
                controller: _searchController,
                onSearchChanged: (value) {
                  // TODO: Implement search
                  print('Search: $value');
                },
                onFilterTap: () {
                  // TODO: Implement filter
                  print('Filter tapped');
                },
              ),
              
              // Grille des catégories (2x2)
              CategoriesGridSection(
                onCategoryTap: _onCategoryTap,
              ),
              
              // Services phares
              FeaturedServicesSection(
                onServiceTap: _onServiceTap, // CORRIGÉ - passe la fonction corrigée
              ),
              
              // Espacement final
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}