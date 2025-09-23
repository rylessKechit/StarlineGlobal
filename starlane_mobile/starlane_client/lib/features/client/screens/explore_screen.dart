import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';

// Feature imports
import '../../../features/auth/bloc/auth_bloc.dart';
import '../../../data/models/activity.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;

  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all';
  String _sortBy = 'popular';
  double _minPrice = 0;
  double _maxPrice = 10000;
  
  // Mock data - À remplacer par de vrais appels API
  final List<Map<String, dynamic>> _allActivities = [
    {
      'id': '1',
      'title': 'Weekend Grand Prix Monaco',
      'location': 'Monaco',
      'price': 2500.0,
      'rating': 4.9,
      'reviews': 127,
      'image': 'https://images.unsplash.com/photo-1580674684081-7617fbf3d745?w=400',
      'category': 'events',
      'featured': true,
      'description': 'Vivez l\'expérience unique du Grand Prix de Monaco avec accès VIP',
    },
    {
      'id': '2',
      'title': 'Yacht Party Privé Saint-Tropez',
      'location': 'Saint-Tropez',
      'price': 1800.0,
      'rating': 4.8,
      'reviews': 89,
      'image': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
      'category': 'lifestyle',
      'featured': true,
      'description': 'Soirée exclusive sur yacht privé avec service de luxe',
    },
    {
      'id': '3',
      'title': 'Jet Privé Paris-Londres',
      'location': 'Multi-villes',
      'price': 3200.0,
      'rating': 5.0,
      'reviews': 203,
      'image': 'https://images.unsplash.com/photo-1540962351504-03099e0a754b?w=400',
      'category': 'airTravel',
      'featured': false,
      'description': 'Transport aérien privé avec service concierge complet',
    },
    {
      'id': '4',
      'title': 'Château Privé Bordeaux',
      'location': 'Bordeaux',
      'price': 4500.0,
      'rating': 4.9,
      'reviews': 56,
      'image': 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=400',
      'category': 'realEstate',
      'featured': true,
      'description': 'Weekend dans un château privé avec dégustation de vins',
    },
    {
      'id': '5',
      'title': 'Transport VIP Paris',
      'location': 'Paris',
      'price': 150.0,
      'rating': 4.7,
      'reviews': 234,
      'image': 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400',
      'category': 'transport',
      'featured': false,
      'description': 'Service de chauffeur privé avec véhicule de luxe',
    },
    {
      'id': '6',
      'title': 'Spa Wellness Retreat',
      'location': 'Courchevel',
      'price': 800.0,
      'rating': 4.6,
      'reviews': 78,
      'image': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      'category': 'lifestyle',
      'featured': false,
      'description': 'Retraite bien-être dans un spa de luxe en montagne',
    },
  ];

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'name': 'Tout', 'icon': '🌟'},
    {'id': 'realEstate', 'name': 'Immobilier', 'icon': '🏡'},
    {'id': 'transport', 'name': 'Transport', 'icon': '🚗'},
    {'id': 'airTravel', 'name': 'Aviation', 'icon': '✈️'},
    {'id': 'lifestyle', 'name': 'Lifestyle', 'icon': '🧘‍♀️'},
    {'id': 'events', 'name': 'Événements', 'icon': '🎉'},
  ];

  List<Map<String, dynamic>> _filteredActivities = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _filteredActivities = List.from(_allActivities);
    _animationController.forward();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimations = List.generate(
      6,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            index * 0.1,
            0.6 + (index * 0.1),
            curve: Curves.easeOut,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _filterActivities() {
    setState(() {
      _filteredActivities = _allActivities.where((activity) {
        // Filtre par recherche
        final searchMatch = activity['title']
            .toString()
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()) ||
            activity['location']
                .toString()
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
        
        // Filtre par catégorie
        final categoryMatch = _selectedCategory == 'all' ||
            activity['category'] == _selectedCategory;
        
        // Filtre par prix
        final priceMatch = activity['price'] >= _minPrice &&
            activity['price'] <= _maxPrice;
        
        return searchMatch && categoryMatch && priceMatch;
      }).toList();
      
      // Tri
      switch (_sortBy) {
        case 'price_low':
          _filteredActivities.sort((a, b) => a['price'].compareTo(b['price']));
          break;
        case 'price_high':
          _filteredActivities.sort((a, b) => b['price'].compareTo(a['price']));
          break;
        case 'rating':
          _filteredActivities.sort((a, b) => b['rating'].compareTo(a['rating']));
          break;
        case 'popular':
        default:
          _filteredActivities.sort((a, b) => b['reviews'].compareTo(a['reviews']));
          break;
      }
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: StarlaneColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.only(top: 12.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: StarlaneColors.gray300,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              
              // Header
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filtres',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: StarlaneColors.navy700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          _selectedCategory = 'all';
                          _sortBy = 'popular';
                          _minPrice = 0;
                          _maxPrice = 10000;
                        });
                      },
                      child: Text(
                        'Réinitialiser',
                        style: TextStyle(
                          color: StarlaneColors.gold600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Tri
                      Text(
                        'Trier par',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: StarlaneColors.navy700,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Wrap(
                        spacing: 8.w,
                        children: [
                          _buildSortChip('popular', 'Populaire', setModalState),
                          _buildSortChip('rating', 'Note', setModalState),
                          _buildSortChip('price_low', 'Prix ↗', setModalState),
                          _buildSortChip('price_high', 'Prix ↘', setModalState),
                        ],
                      ),
                      
                      SizedBox(height: 24.h),
                      
                      // Section Prix
                      Text(
                        'Gamme de prix',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: StarlaneColors.navy700,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      
                      RangeSlider(
                        values: RangeValues(_minPrice, _maxPrice),
                        min: 0,
                        max: 10000,
                        divisions: 20,
                        activeColor: StarlaneColors.gold500,
                        inactiveColor: StarlaneColors.gold100,
                        labels: RangeLabels(
                          '${_minPrice.round()}€',
                          '${_maxPrice.round()}€',
                        ),
                        onChanged: (values) {
                          setModalState(() {
                            _minPrice = values.start;
                            _maxPrice = values.end;
                          });
                        },
                      ),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_minPrice.round()}€',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: StarlaneColors.gray600,
                            ),
                          ),
                          Text(
                            '${_maxPrice.round()}€',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: StarlaneColors.gray600,
                            ),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
              
              // Apply button
              Padding(
                padding: EdgeInsets.all(20.w),
                child: StarlaneButton(
                  text: 'Appliquer les filtres',
                  onPressed: () {
                    setState(() {
                      _selectedCategory = _selectedCategory;
                      _sortBy = _sortBy;
                      _minPrice = _minPrice;
                      _maxPrice = _maxPrice;
                    });
                    _filterActivities();
                    Navigator.of(context).pop();
                  },
                  style: StarlaneButtonStyle.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortChip(String id, String label, StateSetter setModalState) {
    final isSelected = _sortBy == id;
    
    return GestureDetector(
      onTap: () {
        setModalState(() {
          _sortBy = id;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? StarlaneColors.gold500 : StarlaneColors.gray100,
          borderRadius: BorderRadius.circular(20.r),
          border: isSelected ? null : Border.all(color: StarlaneColors.gray300),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? StarlaneColors.white : StarlaneColors.gray700,
          ),
        ),
      ),
    );
  }

  void _onActivityTap(Map<String, dynamic> activity) {
    // TODO: Navigator vers page de détail
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Détails de "${activity['title']}" - À implémenter'),
        backgroundColor: StarlaneColors.emerald500,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StarlaneColors.gray50,
      body: CustomScrollView(
        slivers: [
          // App Bar avec recherche
          SliverAppBar(
            expandedHeight: 160.h,
            floating: false,
            pinned: true,
            backgroundColor: StarlaneColors.emerald500,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [StarlaneColors.emerald400, StarlaneColors.emerald600],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: FadeTransition(
                      opacity: _fadeAnimations[0],
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Explorer',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: StarlaneColors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Découvrez nos services premium',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: StarlaneColors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Barre de recherche et filtres
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: FadeTransition(
                opacity: _fadeAnimations[1],
                child: Column(
                  children: [
                    // Barre de recherche
                    Row(
                      children: [
                        Expanded(
                          child: StarlaneTextField(
                            controller: _searchController,
                            hintText: 'Rechercher un service...',
                            prefixIcon: Icons.search_rounded,
                            onChanged: (value) => _filterActivities(),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        GestureDetector(
                          onTap: _showFilterBottomSheet,
                          child: Container(
                            width: 48.w,
                            height: 48.w,
                            decoration: BoxDecoration(
                              color: StarlaneColors.gold500,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(
                              Icons.tune_rounded,
                              color: StarlaneColors.white,
                              size: 24.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    SizedBox(height: 20.h),
                    
                    // Filtres par catégorie
                    SizedBox(
                      height: 40.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          final isSelected = _selectedCategory == category['id'];
                          
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category['id']!;
                              });
                              _filterActivities();
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 12.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 8.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected 
                                  ? StarlaneColors.gold500 
                                  : StarlaneColors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: isSelected 
                                    ? StarlaneColors.gold500 
                                    : StarlaneColors.gray300,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    category['icon']!,
                                    style: TextStyle(fontSize: 14.sp),
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    category['name']!,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected 
                                        ? StarlaneColors.white 
                                        : StarlaneColors.gray700,
                                    ),
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
          
          // Résultats
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: FadeTransition(
                opacity: _fadeAnimations[2],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_filteredActivities.length} résultat${_filteredActivities.length > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: StarlaneColors.navy700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Liste des activités
          SliverPadding(
            padding: EdgeInsets.all(20.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final activity = _filteredActivities[index];
                  
                  return FadeTransition(
                    opacity: _fadeAnimations[(index % _fadeAnimations.length)],
                    child: Container(
                      margin: EdgeInsets.only(bottom: 16.h),
                      child: StarlaneCard(
                        onTap: () => _onActivityTap(activity),
                        padding: EdgeInsets.zero,
                        child: Row(
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(16.r),
                              ),
                              child: StarlaneImage(
                                imageUrl: activity['image'],
                                width: 120.w,
                                height: 120.h,
                              ),
                            ),
                            
                            // Informations
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(16.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            activity['title'],
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: StarlaneColors.navy700,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (activity['featured'])
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 6.w,
                                              vertical: 2.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: StarlaneColors.gold500,
                                              borderRadius: BorderRadius.circular(8.r),
                                            ),
                                            child: Text(
                                              'TOP',
                                              style: TextStyle(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.bold,
                                                color: StarlaneColors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: 4.h),
                                    
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 14.sp,
                                          color: StarlaneColors.gray500,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          activity['location'],
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            color: StarlaneColors.gray500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: 8.h),
                                    
                                    Row(
                                      children: [
                                        StarlaneRating(
                                          rating: activity['rating'].toDouble(),
                                          size: 12,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          '(${activity['reviews']})',
                                          style: TextStyle(
                                            fontSize: 11.sp,
                                            color: StarlaneColors.gray500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    SizedBox(height: 8.h),
                                    
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '${activity['price'].toInt()}',
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: StarlaneColors.gold600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '€',
                                                style: TextStyle(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: StarlaneColors.gold600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14.sp,
                                          color: StarlaneColors.gray400,
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
                },
                childCount: _filteredActivities.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}