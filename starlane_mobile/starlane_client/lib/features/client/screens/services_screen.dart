import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';
import '../../../data/models/service.dart';

// Bloc et repository
import '../bloc/service_bloc.dart';
import '../repositories/service_repository.dart';

class ServicesScreen extends StatefulWidget {
  final String? initialCategory;
  final String? initialSearch;

  const ServicesScreen({
    super.key,
    this.initialCategory,
    this.initialSearch,
  });

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  late TextEditingController _searchController;
  late ScrollController _scrollController;
  late ServiceBloc _serviceBloc;

  String? _selectedCategory;
  String? _selectedSortBy;

  // Catégories disponibles
  final List<Map<String, String>> _categories = [
    {'id': '', 'name': 'Tous', 'icon': 'all'},
    {'id': 'airTravel', 'name': 'Air Travel', 'icon': 'flight'},
    {'id': 'transport', 'name': 'Transport', 'icon': 'car'},
    {'id': 'realEstate', 'name': 'Real Estate', 'icon': 'home'},
    {'id': 'corporate', 'name': 'Corporate', 'icon': 'business'},
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialSearch);
    _scrollController = ScrollController();
    
    _serviceBloc = ServiceBloc(
      serviceRepository: context.read<ServiceRepository>(),
    );
    
    _selectedCategory = widget.initialCategory;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadServices();
    });
  }

  void _loadServices() {
    _serviceBloc.add(ServiceLoadRequested(
      category: _selectedCategory,
      search: _searchController.text.trim().isEmpty ? null : _searchController.text.trim(),
      sortBy: _selectedSortBy,
    ));
  }

  void _onSearchChanged(String value) {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_searchController.text == value) {
        _loadServices();
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Filtres et tri',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: StarlaneColors.navy900,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            
            Text(
              'Trier par',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: StarlaneColors.navy900,
              ),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              children: [
                _buildFilterChip('Nom', 'title'),
                _buildFilterChip('Catégorie', 'category'),
                _buildFilterChip('Date', 'createdAt'),
              ],
            ),
            SizedBox(height: 32.h),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedSortBy = null;
                      });
                      Navigator.pop(context);
                      _loadServices();
                    },
                    child: const Text('Réinitialiser'),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _loadServices();
                    },
                    child: const Text('Appliquer'),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedSortBy == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedSortBy = selected ? value : null;
        });
      },
      selectedColor: StarlaneColors.gold100,
      checkmarkColor: StarlaneColors.gold600,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ServiceBloc>.value(
      value: _serviceBloc,
      child: Scaffold(
        backgroundColor: StarlaneColors.background,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Services VIP',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: StarlaneColors.navy900,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: StarlaneColors.navy900,
              size: 20.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.tune_outlined,
                color: StarlaneColors.navy900,
                size: 24.sp,
              ),
              onPressed: _showFilterBottomSheet,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(120.h),
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  // Barre de recherche
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Rechercher un service VIP...',
                        hintStyle: TextStyle(
                          color: StarlaneColors.gray400,
                          fontSize: 14.sp,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: StarlaneColors.gray400,
                          size: 20.sp,
                        ),
                        filled: true,
                        fillColor: StarlaneColors.gray50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                      ),
                    ),
                  ),
                  
                  // Catégories horizontales (comme sur home_screen)
                  Container(
                    height: 80.h,
                    margin: EdgeInsets.only(bottom: 8.h),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = _selectedCategory == category['id'] || 
                                         (_selectedCategory == null && index == 0);
                        
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = category['id']!.isEmpty ? null : category['id'];
                            });
                            _loadServices();
                          },
                          child: Container(
                            width: 80.w,
                            margin: EdgeInsets.only(right: 12.w),
                            child: Column(
                              children: [
                                // Icône de catégorie
                                Container(
                                  width: 50.w,
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                        ? _getCategoryColor(category['id']!)
                                        : _getCategoryColor(category['id']!).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Icon(
                                    _getCategoryIconData(category['id']!),
                                    color: isSelected 
                                        ? Colors.white 
                                        : _getCategoryColor(category['id']!),
                                    size: 24.sp,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                // Nom de catégorie
                                Text(
                                  category['name']!,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                    color: isSelected 
                                        ? _getCategoryColor(category['id']!) 
                                        : StarlaneColors.gray600,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: BlocBuilder<ServiceBloc, ServiceState>(
          builder: (context, state) {
            if (state is ServiceLoading) {
              return _buildLoadingState();
            } else if (state is ServiceLoaded) {
              if (state.services.isEmpty) {
                return _buildEmptyState();
              }
              return _buildServicesGrid(state.services);
            } else if (state is ServiceError) {
              return _buildErrorState(state.message);
            }
            
            return _buildInitialState();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(StarlaneColors.gold600),
          ),
          SizedBox(height: 16.h),
          Text(
            'Chargement des services VIP...',
            style: TextStyle(
              fontSize: 14.sp,
              color: StarlaneColors.gray600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: StarlaneColors.error,
            ),
            SizedBox(height: 24.h),
            Text(
              'Erreur de chargement',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: StarlaneColors.navy900,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: StarlaneColors.gray600,
              ),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: _loadServices,
              icon: const Icon(Icons.refresh),
              label: const Text('Réessayer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: StarlaneColors.gold600,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.diamond_outlined,
              size: 64.sp,
              color: StarlaneColors.gray400,
            ),
            SizedBox(height: 24.h),
            Text(
              'Aucun service trouvé',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: StarlaneColors.navy900,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Essayez de modifier vos critères de recherche ou de sélectionner une autre catégorie.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: StarlaneColors.gray600,
              ),
            ),
            SizedBox(height: 24.h),
            TextButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _selectedCategory = null;
                  _selectedSortBy = null;
                });
                _loadServices();
              },
              icon: const Icon(Icons.clear_all),
              label: const Text('Effacer les filtres'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.diamond_outlined,
              size: 64.sp,
              color: StarlaneColors.gold600,
            ),
            SizedBox(height: 24.h),
            Text(
              'Découvrez nos services VIP',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: StarlaneColors.navy900,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Sélectionnez une catégorie pour commencer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: StarlaneColors.gray600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesGrid(List<Service> services) {
    return RefreshIndicator(
      onRefresh: () async => _loadServices(),
      color: StarlaneColors.gold600,
      child: GridView.builder(
        controller: _scrollController,
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.8,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.h,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return _buildServiceCard(service);
        },
      ),
    );
  }

  Widget _buildServiceCard(Service service) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: StarlaneColors.navy900.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: () => _onServiceTap(service),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image du service avec badges
              Expanded(
                flex: 3,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                    color: StarlaneColors.gray100,
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                        child: CachedNetworkImage(
                          imageUrl: service.primaryImageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Container(
                            color: StarlaneColors.gray100,
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(StarlaneColors.gold600),
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: StarlaneColors.gray100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _getServiceCategoryIcon(service.category),
                                  size: 32.sp,
                                  color: _getServiceCategoryColor(service.category),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'Image non disponible',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: StarlaneColors.gray500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Badge de catégorie en haut à gauche
                      Positioned(
                        top: 8.h,
                        left: 8.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getServiceCategoryColor(service.category),
                            borderRadius: BorderRadius.circular(6.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getServiceCategoryIcon(service.category),
                                size: 12.sp,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                _getServiceCategoryName(service.category),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Badge featured en haut à droite
                      if (service.featured)
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: Container(
                            width: 28.w,
                            height: 28.h,
                            decoration: BoxDecoration(
                              color: StarlaneColors.gold600,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.star,
                              size: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Contenu du service
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Titre
                      Text(
                        service.title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: StarlaneColors.navy900,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),

                      // Description
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Text(
                            (service.shortDescription?.isNotEmpty == true) 
                                ? service.shortDescription!
                                : service.description,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: StarlaneColors.gray600,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      SizedBox(height: 6.h),

                      // Footer avec prix
                      Row(
                        children: [
                          const Spacer(),
                          Text(
                            service.formattedPrice,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: StarlaneColors.gold600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonctions helper pour les catégories horizontales
  IconData _getCategoryIconData(String categoryId) {
    switch (categoryId) {
      case 'airTravel':
        return Icons.flight;
      case 'transport':
        return Icons.directions_car; 
      case 'realEstate':
        return Icons.home; 
      case 'corporate':
        return Icons.business; 
      default:
        return Icons.diamond_outlined;
    }
  }

  Color _getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'airTravel':
        return StarlaneColors.navy500;
      case 'transport':
        return StarlaneColors.emerald500;
      case 'realEstate':
        return StarlaneColors.gold500;
      case 'corporate':
        return StarlaneColors.purple500;
      default:
        return StarlaneColors.gold600;
    }
  }

  // Fonctions helper pour les badges de services
  IconData _getServiceCategoryIcon(String category) {
    switch (category) {
      case 'airTravel':
        return Icons.flight;
      case 'transport':
        return Icons.directions_car;
      case 'realEstate':
        return Icons.home;
      case 'corporate':
        return Icons.business;
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
      default:
        return Icons.diamond_outlined;
    }
  }

  Color _getServiceCategoryColor(String category) {
    switch (category) {
      case 'airTravel':
        return StarlaneColors.navy500;
      case 'transport':
        return StarlaneColors.emerald500;
      case 'realEstate':
        return StarlaneColors.gold500;
      case 'corporate':
        return StarlaneColors.purple500;
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
      default:
        return StarlaneColors.gold600;
    }
  }

  String _getServiceCategoryName(String category) {
    switch (category) {
      case 'airTravel':
        return 'Air Travel';
      case 'transport':
        return 'Transport';
      case 'realEstate':
        return 'Real Estate';
      case 'corporate':
        return 'Corporate';
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
      default:
        return 'Service VIP';
    }
  }

  void _onServiceTap(Service service) {
    context.push('/service/${service.id}');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _serviceBloc.close();
    super.dispose();
  }
}