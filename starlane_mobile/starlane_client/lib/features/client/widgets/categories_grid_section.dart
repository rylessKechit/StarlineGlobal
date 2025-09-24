import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';

class CategoriesGridSection extends StatelessWidget {
  final Function(String categoryId) onCategoryTap;

  const CategoriesGridSection({
    super.key,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      {
        'id': 'airTravel',
        'name': 'Air Travel',
        'icon': Icons.flight,
        'color': StarlaneColors.navy500,
        'description': 'Jets privés & voyages'
      },
      {
        'id': 'transport',
        'name': 'Transport',
        'icon': Icons.directions_car,
        'color': StarlaneColors.emerald500,
        'description': 'Chauffeurs & véhicules'
      },
      {
        'id': 'realEstate',
        'name': 'Real Estate',
        'icon': Icons.home,
        'color': StarlaneColors.gold500,
        'description': 'Biens immobiliers'
      },
      {
        'id': 'corporate',
        'name': 'Corporate',
        'icon': Icons.business,
        'color': StarlaneColors.purple500,
        'description': 'Événements d\'entreprise'
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ✅ AJOUTÉ pour minimiser l'espace
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nos Services',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: StarlaneColors.navy900,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Choisissez votre catégorie de service',
            style: TextStyle(
              fontSize: 13.sp,
              color: StarlaneColors.gray600,
            ),
          ),

          SizedBox(height: 16.h),
          
          // ✅ GRILLE 2x2 SANS PADDING INTERNE
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero, // ✅ SUPPRIME TOUT PADDING INTERNE !
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 1.3,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return _buildCategoryCard(category);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return StarlaneCard(
      onTap: () => onCategoryTap(category['id']),
      padding: EdgeInsets.all(12.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: (category['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              category['icon'] as IconData,
              color: category['color'] as Color,
              size: 22.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            category['name'],
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: StarlaneColors.navy700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            category['description'],
            style: TextStyle(
              fontSize: 9.sp,
              color: StarlaneColors.gray600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}