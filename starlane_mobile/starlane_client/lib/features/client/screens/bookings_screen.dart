import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

// Core imports
import '../../../core/theme/starlane_colors.dart';
import '../../../shared/widgets/starlane_widgets.dart';

// Feature imports
import '../../../features/auth/bloc/auth_bloc.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Animation<double>> _fadeAnimations;
  late TabController _tabController;

  String _selectedFilter = 'all';

  // Mock data - À remplacer par de vrais appels API
  final List<Map<String, dynamic>> _allBookings = [
    {
      'id': 'BK-2025-000001',
      'title': 'Weekend Grand Prix Monaco',
      'image': 'https://images.unsplash.com/photo-1580674684081-7617fbf3d745?w=400',
      'location': 'Monaco',
      'startDate': DateTime.now().add(const Duration(days: 15)),
      'endDate': DateTime.now().add(const Duration(days: 17)),
      'participants': 2,
      'totalAmount': 2500.0,
      'status': 'confirmed',
      'category': 'events',
      'provider': 'Monaco Events VIP',
      'bookingDate': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'id': 'BK-2025-000002',
      'title': 'Transport VIP Paris',
      'image': 'https://images.unsplash.com/photo-1449824913935-59a10b8d2000?w=400',
      'location': 'Paris',
      'startDate': DateTime.now().add(const Duration(days: 3)),
      'endDate': DateTime.now().add(const Duration(days: 3, hours: 4)),
      'participants': 1,
      'totalAmount': 180.0,
      'status': 'confirmed',
      'category': 'transport',
      'provider': 'Paris Luxury Cars',
      'bookingDate': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': 'BK-2025-000003',
      'title': 'Yacht Party Saint-Tropez',
      'image': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=400',
      'location': 'Saint-Tropez',
      'startDate': DateTime.now().subtract(const Duration(days: 10)),
      'endDate': DateTime.now().subtract(const Duration(days: 9)),
      'participants': 4,
      'totalAmount': 1800.0,
      'status': 'completed',
      'category': 'lifestyle',
      'provider': 'Riviera Yachts',
      'bookingDate': DateTime.now().subtract(const Duration(days: 25)),
      'rating': 4.8,
      'review': 'Expérience incroyable ! Service parfait.',
    },
    {
      'id': 'BK-2025-000004',
      'title': 'Jet Privé Paris-Londres',
      'image': 'https://images.unsplash.com/photo-1540962351504-03099e0a754b?w=400',
      'location': 'Multi-villes',
      'startDate': DateTime.now().subtract(const Duration(days: 5)),
      'endDate': DateTime.now().subtract(const Duration(days: 5)),
      'participants': 3,
      'totalAmount': 3200.0,
      'status': 'cancelled',
      'category': 'airTravel',
      'provider': 'Elite Aviation',
      'bookingDate': DateTime.now().subtract(const Duration(days: 20)),
      'cancellationReason': 'Annulation client',
      'refundAmount': 2400.0,
    },
  ];

  List<Map<String, dynamic>> _filteredBookings = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _setupAnimations();
    _filteredBookings = List.from(_allBookings);
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
    _tabController.dispose();
    super.dispose();
  }

  void _filterBookings(String filter) {
    setState(() {
      _selectedFilter = filter;
      switch (filter) {
        case 'upcoming':
          _filteredBookings = _allBookings
              .where((booking) => 
                  booking['startDate'].isAfter(DateTime.now()) &&
                  ['confirmed', 'pending'].contains(booking['status']))
              .toList();
          break;
        case 'completed':
          _filteredBookings = _allBookings
              .where((booking) => booking['status'] == 'completed')
              .toList();
          break;
        case 'cancelled':
          _filteredBookings = _allBookings
              .where((booking) => booking['status'] == 'cancelled')
              .toList();
          break;
        case 'all':
        default:
          _filteredBookings = List.from(_allBookings);
          break;
      }
      
      // Tri par date de réservation (plus récent en premier)
      _filteredBookings.sort((a, b) => b['startDate'].compareTo(a['startDate']));
    });
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'confirmed':
        return StarlaneColors.emerald500;
      case 'pending':
        return StarlaneColors.gold500;
      case 'completed':
        return StarlaneColors.navy500;
      case 'cancelled':
        return StarlaneColors.error;
      default:
        return StarlaneColors.gray500;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmé';
      case 'pending':
        return 'En attente';
      case 'completed':
        return 'Terminé';
      case 'cancelled':
        return 'Annulé';
      default:
        return status;
    }
  }

  void _onBookingTap(Map<String, dynamic> booking) {
    // TODO: Navigator vers page de détail de la réservation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Détails de la réservation ${booking['id']} - À implémenter'),
        backgroundColor: StarlaneColors.navy500,
      ),
    );
  }

  void _onCancelBooking(Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Annuler la réservation',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: StarlaneColors.navy700,
          ),
        ),
        content: Text(
          'Êtes-vous sûr de vouloir annuler cette réservation ?\n\nSelon nos conditions, un remboursement partiel pourrait s\'appliquer.',
          style: TextStyle(
            fontSize: 14.sp,
            color: StarlaneColors.gray600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Garder',
              style: TextStyle(color: StarlaneColors.gray600),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Appel API pour annuler
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Annulation de ${booking['id']} - À implémenter'),
                  backgroundColor: StarlaneColors.error,
                ),
              );
            },
            child: Text(
              'Annuler',
              style: TextStyle(
                color: StarlaneColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StarlaneColors.gray50,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 140.h,
            floating: false,
            pinned: true,
            backgroundColor: StarlaneColors.navy500,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [StarlaneColors.navy400, StarlaneColors.navy600],
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
                            'Mes Réservations',
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: StarlaneColors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Gérez vos réservations et expériences',
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
          
          // Filtres par onglets
          SliverToBoxAdapter(
            child: Container(
              color: StarlaneColors.white,
              child: FadeTransition(
                opacity: _fadeAnimations[1],
                child: TabBar(
                  controller: _tabController,
                  labelColor: StarlaneColors.navy600,
                  unselectedLabelColor: StarlaneColors.gray500,
                  indicatorColor: StarlaneColors.navy600,
                  labelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  onTap: (index) {
                    final filters = ['all', 'upcoming', 'completed', 'cancelled'];
                    _filterBookings(filters[index]);
                  },
                  tabs: const [
                    Tab(text: 'Toutes'),
                    Tab(text: 'À venir'),
                    Tab(text: 'Terminées'),
                    Tab(text: 'Annulées'),
                  ],
                ),
              ),
            ),
          ),
          
          // Statistiques rapides
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: FadeTransition(
                opacity: _fadeAnimations[2],
                child: Row(
                  children: [
                    Expanded(
                      child: StarlaneCard(
                        child: Column(
                          children: [
                            Text(
                              '${_allBookings.where((b) => b['status'] == 'completed').length}',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: StarlaneColors.emerald500,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Terminées',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: StarlaneColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: StarlaneCard(
                        child: Column(
                          children: [
                            Text(
                              '${_allBookings.where((b) => ['confirmed', 'pending'].contains(b['status']) && b['startDate'].isAfter(DateTime.now())).length}',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: StarlaneColors.gold500,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'À venir',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: StarlaneColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: StarlaneCard(
                        child: Column(
                          children: [
                            Text(
                              '${_allBookings.fold<double>(0, (sum, b) => sum + (b['totalAmount'] ?? 0)).toInt()}€',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: StarlaneColors.navy500,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Total dépensé',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: StarlaneColors.gray600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Liste des réservations
          _filteredBookings.isEmpty
              ? SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(40.w),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64.sp,
                          color: StarlaneColors.gray400,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Aucune réservation',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                            color: StarlaneColors.gray600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Vos réservations apparaîtront ici',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: StarlaneColors.gray500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: EdgeInsets.all(20.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final booking = _filteredBookings[index];
                        final isUpcoming = booking['startDate'].isAfter(DateTime.now());
                        final canCancel = isUpcoming && booking['status'] == 'confirmed';
                        
                        return FadeTransition(
                          opacity: _fadeAnimations[(index % _fadeAnimations.length)],
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            child: StarlaneCard(
                              onTap: () => _onBookingTap(booking),
                              padding: EdgeInsets.zero,
                              child: Column(
                                children: [
                                  // Header avec statut
                                  Container(
                                    padding: EdgeInsets.all(16.w),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(booking['status']).withOpacity(0.1),
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16.r),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              booking['id'],
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                                color: StarlaneColors.gray600,
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              'Réservé le ${DateFormat('dd/MM/yyyy').format(booking['bookingDate'])}',
                                              style: TextStyle(
                                                fontSize: 11.sp,
                                                color: StarlaneColors.gray500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        StarlaneBadge(
                                          text: _getStatusText(booking['status']),
                                          backgroundColor: _getStatusColor(booking['status']),
                                          textColor: StarlaneColors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                  // Contenu principal
                                  Padding(
                                    padding: EdgeInsets.all(16.w),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            // Image
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12.r),
                                              child: StarlaneImage(
                                                imageUrl: booking['image'],
                                                width: 80.w,
                                                height: 80.h,
                                              ),
                                            ),
                                            
                                            SizedBox(width: 16.w),
                                            
                                            // Informations
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    booking['title'],
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.bold,
                                                      color: StarlaneColors.navy700,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
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
                                                        booking['location'],
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
                                                      Icon(
                                                        Icons.calendar_today_outlined,
                                                        size: 14.sp,
                                                        color: StarlaneColors.gray500,
                                                      ),
                                                      SizedBox(width: 4.w),
                                                      Text(
                                                        DateFormat('dd/MM/yyyy').format(booking['startDate']),
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: StarlaneColors.gray500,
                                                        ),
                                                      ),
                                                      if (booking['startDate'].day != booking['endDate'].day)
                                                        Text(
                                                          ' - ${DateFormat('dd/MM/yyyy').format(booking['endDate'])}',
                                                          style: TextStyle(
                                                            fontSize: 12.sp,
                                                            color: StarlaneColors.gray500,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        
                                        SizedBox(height: 16.h),
                                        
                                        // Footer avec prix et actions
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '${booking['totalAmount'].toInt()}',
                                                        style: TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight: FontWeight.bold,
                                                          color: StarlaneColors.navy600,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '€',
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight: FontWeight.w500,
                                                          color: StarlaneColors.navy600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Text(
                                                  '${booking['participants']} participant${booking['participants'] > 1 ? 's' : ''}',
                                                  style: TextStyle(
                                                    fontSize: 11.sp,
                                                    color: StarlaneColors.gray500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            
                                            // Actions
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if (canCancel)
                                                  TextButton(
                                                    onPressed: () => _onCancelBooking(booking),
                                                    child: Text(
                                                      'Annuler',
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: StarlaneColors.error,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                
                                                if (booking['status'] == 'completed' && booking['rating'] == null)
                                                  TextButton(
                                                    onPressed: () {
                                                      // TODO: Ouvrir modal d'avis
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(
                                                          content: Text('Laisser un avis - À implémenter'),
                                                          backgroundColor: StarlaneColors.gold500,
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      'Avis',
                                                      style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: StarlaneColors.gold600,
                                                        fontWeight: FontWeight.w600,
                                                      ),
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
                                        
                                        // Avis client si présent
                                        if (booking['rating'] != null) ...[
                                          SizedBox(height: 12.h),
                                          Container(
                                            padding: EdgeInsets.all(12.w),
                                            decoration: BoxDecoration(
                                              color: StarlaneColors.gold50,
                                              borderRadius: BorderRadius.circular(8.r),
                                            ),
                                            child: Row(
                                              children: [
                                                StarlaneRating(
                                                  rating: booking['rating'].toDouble(),
                                                  size: 14,
                                                ),
                                                SizedBox(width: 8.w),
                                                Expanded(
                                                  child: Text(
                                                    booking['review'],
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: StarlaneColors.gray700,
                                                      fontStyle: FontStyle.italic,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: _filteredBookings.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}