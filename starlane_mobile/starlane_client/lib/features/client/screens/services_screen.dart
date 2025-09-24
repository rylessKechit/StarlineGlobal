import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';
import '../../../data/models/service.dart';
import '../repositories/service_repository.dart';
import '../bloc/service_bloc.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceBloc(
        serviceRepository: context.read<ServiceRepository>(),
      )..add(ServiceLoadRequested()),
      child: const _ServicesScreenView(),
    );
  }
}

class _ServicesScreenView extends StatefulWidget {
  const _ServicesScreenView();

  @override
  State<_ServicesScreenView> createState() => _ServicesScreenViewState();
}

class _ServicesScreenViewState extends State<_ServicesScreenView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  
  @override
  void initState() {
    super.initState();
    
    // Listener pour sticky header
    _scrollController.addListener(() {
      final isScrolled = _scrollController.offset > 50;
      if (_isScrolled != isScrolled) {
        setState(() {
          _isScrolled = isScrolled;
        });
      }
    });
  }

  void _onSearchChanged(String value) {
    // Recherche avec debounce
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_searchController.text == value) {
        if (value.isNotEmpty) {
          context.read<ServiceBloc>().add(ServiceSearchRequested(query: value));
        } else {
          context.read<ServiceBloc>().add(ServiceLoadRequested());
        }
      }
    });
  }

  void _onRefresh() {
    context.read<ServiceBloc>().add(ServiceLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StarlaneColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header avec recherche
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: StarlaneColors.white,
                boxShadow: _isScrolled 
                  ? [
                      BoxShadow(
                        color: StarlaneColors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
              ),
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Titre avec icône VIP
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              StarlaneColors.gold600,
                              StarlaneColors.gold400,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: StarlaneColors.gold600.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.diamond, // ICÔNE VIP/PREMIUM
                          color: StarlaneColors.white,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Services VIP',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: StarlaneColors.navy900,
                              ),
                            ),
                            Text(
                              'Excellence & Luxe',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: StarlaneColors.gold600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 8.h),
                  
                  // Sous-titre
                  Text(
                    'Découvrez nos services d\'exception Starlane Global',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: StarlaneColors.textSecondary,
                    ),
                  ),
                  
                  SizedBox(height: 20.h),
                  
                  // Barre de recherche
                  StarlaneTextField(
                    controller: _searchController,
                    hintText: 'Rechercher un service VIP...',
                    prefixIcon: Icons.search,
                    onChanged: _onSearchChanged,
                  ),
                ],
              ),
            ),
            
            // Contenu principal
            Expanded(
              child: BlocBuilder<ServiceBloc, ServiceState>(
                builder: (context, state) {
                  if (state is ServiceLoading) {
                    return _buildLoadingState();
                  } else if (state is ServiceError) {
                    return _buildErrorState(state.message);
                  } else if (state is ServiceLoaded) {
                    if (state.services.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildServicesList(state.services);
                  } else if (state is ServiceFeaturedLoaded) {
                    if (state.services.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildServicesList(state.services);
                  }
                  
                  return _buildEmptyState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: 6,
      itemBuilder: (context, index) => Container(
        margin: EdgeInsets.only(bottom: 16.h),
        height: 200.h,
        decoration: BoxDecoration(
          color: StarlaneColors.gray100,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: const StarlaneShimmer(),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: StarlaneColors.error,
          ),
          SizedBox(height: 16.h),
          Text(
            'Erreur',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: StarlaneColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 14.sp,
              color: StarlaneColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          StarlaneButton(
            text: 'Réessayer',
            onPressed: _onRefresh,
            style: StarlaneButtonStyle.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  StarlaneColors.gold600.withOpacity(0.1),
                  StarlaneColors.gold400.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(32.r),
            ),
            child: Icon(
              Icons.diamond, // ICÔNE VIP
              size: 64.sp,
              color: StarlaneColors.gold600,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Services VIP à venir',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: StarlaneColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Nos services VIP d\'exception arrivent bientôt',
            style: TextStyle(
              fontSize: 14.sp,
              color: StarlaneColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(List<Service> services) {
    return RefreshIndicator(
      onRefresh: () async => _onRefresh(),
      color: StarlaneColors.gold600,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(20.w),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _buildServiceCard(service);
        },
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    return StarlaneCard(
      margin: EdgeInsets.only(bottom: 20.h),
      onTap: () => _onServiceTap(service),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image du service
          Container(
            height: 180.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.r),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16.r),
              ),
              child: _buildServiceImage(service),
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Badge catégorie + Prix
          Row(
            children: [
              StarlaneBadge(
                text: _getServiceCategoryName(service.category),
                backgroundColor: _getServiceCategoryColor(service.category).withOpacity(0.1),
                textColor: _getServiceCategoryColor(service.category),
                icon: _getServiceCategoryIcon(service.category),
              ),
              
              const Spacer(),
              
              if (service.pricing != null && service.pricing!.basePrice > 0)
                StarlaneBadge(
                  text: 'À partir de ${service.pricing!.basePrice.toStringAsFixed(0)} ${_getCurrencySymbol(service.pricing!.currency)}',
                  backgroundColor: StarlaneColors.gold100,
                  textColor: StarlaneColors.gold700,
                ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          // Titre
          Text(
            service.title,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: StarlaneColors.navy900,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: 8.h),
          
          // Description
          if (service.shortDescription != null)
            Text(
              service.shortDescription!,
              style: TextStyle(
                fontSize: 14.sp,
                color: StarlaneColors.textSecondary,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          
          SizedBox(height: 16.h),
          
          // Tags/Features
          if (service.features != null && service.features!.isNotEmpty)
            Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: service.features!.take(3).map((feature) {
                return StarlaneBadge(
                  text: feature,
                  backgroundColor: StarlaneColors.navy100,
                  textColor: StarlaneColors.navy700,
                  fontSize: 10,
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildServiceImage(Service service) {
    if (service.images != null && service.images!.isNotEmpty) {
      final primaryImage = service.images!.firstWhere(
        (img) => img.isPrimary,
        orElse: () => service.images!.first,
      );
      
      return CachedNetworkImage(
        imageUrl: primaryImage.url,
        fit: BoxFit.cover,
        width: double.infinity,
        placeholder: (context, url) => Container(
          color: StarlaneColors.gray100,
          child: const StarlaneShimmer(),
        ),
        errorWidget: (context, url, error) => _buildDefaultServiceImage(service.category),
      );
    } else {
      return _buildDefaultServiceImage(service.category);
    }
  }

  Widget _buildDefaultServiceImage(String category) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getServiceCategoryColor(category).withOpacity(0.2),
            _getServiceCategoryColor(category).withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          _getServiceCategoryIcon(category),
          size: 48.sp,
          color: _getServiceCategoryColor(category),
        ),
      ),
    );
  }

  IconData _getServiceCategoryIcon(String category) {
    switch (category) {
      case 'concierge':
        return Icons.support_agent_outlined;
      case 'luxury':
        return Icons.diamond_outlined;
      case 'travel':
        return Icons.travel_explore_outlined;
      case 'lifestyle':
        return Icons.spa_outlined;
      case 'business':
        return Icons.business_center_outlined;
      case 'security':
        return Icons.security_outlined;
      case 'airTravel': // AJOUTÉ pour votre backend
        return Icons.flight_takeoff;
      default:
        return Icons.diamond_outlined; // ICÔNE VIP par défaut
    }
  }

  Color _getServiceCategoryColor(String category) {
    switch (category) {
      case 'concierge':
        return StarlaneColors.gold600;
      case 'luxury':
        return StarlaneColors.purple600;
      case 'travel':
        return StarlaneColors.navy600;
      case 'lifestyle':
        return StarlaneColors.emerald600;
      case 'business':
        return StarlaneColors.gray700;
      case 'security':
        return StarlaneColors.error;
      case 'airTravel': // AJOUTÉ pour votre backend
        return StarlaneColors.navy600;
      default:
        return StarlaneColors.gold600; // Couleur VIP par défaut
    }
  }

  String _getServiceCategoryName(String category) {
    switch (category) {
      case 'concierge':
        return 'Conciergerie VIP';
      case 'luxury':
        return 'Luxe';
      case 'travel':
        return 'Voyage Premium';
      case 'lifestyle':
        return 'Lifestyle VIP';
      case 'business':
        return 'Business Class';
      case 'security':
        return 'Sécurité Premium';
      case 'airTravel': // AJOUTÉ pour votre backend
        return 'Aviation VIP';
      default:
        return 'Service VIP';
    }
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'EUR':
        return '€';
      case 'USD':
        return '\$';
      case 'GBP':
        return '£';
      default:
        return currency;
    }
  }

  void _onServiceTap(Service service) {
    // TODO: Navigation vers ServiceDetailScreen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Détails du service VIP ${service.title} - À implémenter'),
        backgroundColor: StarlaneColors.gold600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        margin: EdgeInsets.all(16.w),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}