import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';

// Sections
import '../widgets/home_header_section.dart';
import '../widgets/search_section.dart';
import '../widgets/categories_grid_section.dart';
import '../widgets/featured_services_section.dart';

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
    // TODO: Implémenter la recherche
    print('Recherche: $query');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StarlaneColors.gray50,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header avec bonjour + avatar
            const HomeHeaderSection(),
            
            SizedBox(height: 16.h),
            
            // Barre de recherche
            SearchSection(
              controller: _searchController,
              onChanged: _onSearchChanged,
            ),
            
            SizedBox(height: 16.h),
            
            // Grille des catégories 2x2
            CategoriesGridSection(
              onCategoryTap: _onCategoryTap,
            ),
            
            SizedBox(height: 12.h),
            
            // Services phares
            FeaturedServicesSection(
              onServiceTap: _onServiceTap,
            ),
            
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}