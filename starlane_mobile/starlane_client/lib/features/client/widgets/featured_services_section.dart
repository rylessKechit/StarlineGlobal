import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';

class FeaturedServicesSection extends StatelessWidget {
  final Function(String serviceId) onServiceTap;

  const FeaturedServicesSection({
    super.key,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'id': 'meet-greet',
        'title': 'Meet & Greet',
        'category': 'Air Travel',
        'description': 'Service d\'accueil VIP à l\'aéroport',
        'price': '250€',
        'icon': Icons.flight,
        'color': StarlaneColors.navy500,
      },
      {
        'id': 'jet-reservation',
        'title': 'Réservation de Jet',
        'category': 'Air Travel',
        'description': 'Location de jets privés sur mesure',
        'price': 'Sur devis',
        'icon': Icons.flight_takeoff,
        'color': StarlaneColors.navy500,
      },
      {
        'id': 'mise-disposition',
        'title': 'Mise à Disposition',
        'category': 'Transport',
        'description': 'Véhicule avec chauffeur à disposition',
        'price': '150€/h',
        'icon': Icons.directions_car,
        'color': StarlaneColors.emerald500,
      },
      {
        'id': 'chauffeur-vip',
        'title': 'Chauffeur VIP',
        'category': 'Transport',
        'description': 'Service de chauffeur personnel',
        'price': '80€/h',
        'icon': Icons.person_pin_circle,
        'color': StarlaneColors.emerald500,
      },
      {
        'id': 'recherche-bien-louer',
        'title': 'Recherche de Bien à Louer',
        'category': 'Real Estate',
        'description': 'Recherche personnalisée de biens',
        'price': '500€',
        'icon': Icons.home_outlined,
        'color': StarlaneColors.gold500,
      },
      {
        'id': 'recherche-bien-acheter',
        'title': 'Recherche de Bien à Acheter',
        'category': 'Real Estate',
        'description': 'Accompagnement achat immobilier',
        'price': '1000€',
        'icon': Icons.home,
        'color': StarlaneColors.gold500,
      },
      {
        'id': 'events-corporate',
        'title': 'Events Corporate',
        'category': 'Corporate',
        'description': 'Organisation d\'événements d\'entreprise',
        'price': 'Sur devis',
        'icon': Icons.business,
        'color': StarlaneColors.purple500,
      },
    ];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Services Phares',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: StarlaneColors.navy900,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Nos services les plus demandés',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: StarlaneColors.gray600,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigation vers tous les services
                },
                child: Text(
                  'Voir tout',
                  style: TextStyle(
                    color: StarlaneColors.gold600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          
          // Liste des services
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final service = services[index];
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                child: _buildServiceCard(service),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return StarlaneCard(
      onTap: () => onServiceTap(service['id']),
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          // Icône
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: (service['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              service['icon'] as IconData,
              color: service['color'] as Color,
              size: 22.sp,
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // Contenu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        service['title'],
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: StarlaneColors.navy700,
                        ),
                      ),
                    ),
                    Text(
                      service['price'],
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: StarlaneColors.gold600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  service['category'],
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: service['color'] as Color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  service['description'],
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: StarlaneColors.gray600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          SizedBox(width: 8.w),
          
          // Flèche
          Icon(
            Icons.arrow_forward_ios,
            size: 14.sp,
            color: StarlaneColors.gray400,
          ),
        ],
      ),
    );
  }
}