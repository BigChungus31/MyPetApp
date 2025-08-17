import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/venue_service.dart';

class PetFriendlyVenuesScreen extends StatefulWidget {
  const PetFriendlyVenuesScreen({Key? key}) : super(key: key);

  @override
  State<PetFriendlyVenuesScreen> createState() =>
      _PetFriendlyVenuesScreenState();
}

class _PetFriendlyVenuesScreenState extends State<PetFriendlyVenuesScreen> {
  final VenueService _venueService = VenueService.instance;
  List<Map<String, dynamic>> _venues = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final venuesFuture = _venueService.getAllVenues();
      final categoriesFuture = _venueService.getVenueCategories();

      final results = await Future.wait([venuesFuture, categoriesFuture]);

      setState(() {
        _venues = results[0];
        _categories = results[1];
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load venues: ${error.toString()}')),
      );
    }
  }

  Future<void> _searchVenues(String query) async {
    if (query.isEmpty) {
      await _loadVenuesByCategory(_selectedCategory);
      return;
    }

    try {
      final venues = await _venueService.searchVenues(query);
      setState(() => _venues = venues);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Search failed: ${error.toString()}')),
      );
    }
  }

  Future<void> _loadVenuesByCategory(String category) async {
    setState(() => _isLoading = true);

    try {
      List<Map<String, dynamic>> venues;
      if (category == 'all') {
        venues = await _venueService.getAllVenues();
      } else {
        venues = await _venueService.getVenuesByType(category);
      }

      setState(() {
        _venues = venues;
        _selectedCategory = category;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load venues: ${error.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Pet-Friendly Venues',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(4.w),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search venues, locations...',
                hintStyle: GoogleFonts.inter(color: Colors.grey[500]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3.w),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3.w),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3.w),
                  borderSide: BorderSide(color: Colors.blue[400]!),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              ),
              onSubmitted: _searchVenues,
            ),
          ),

          // Category Filter
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('all', 'All Venues', Icons.location_on),
                  SizedBox(width: 3.w),
                  ..._categories
                      .map((category) => Padding(
                            padding: EdgeInsets.only(right: 3.w),
                            child: _buildCategoryChip(
                              category['type'] as String,
                              category['name'] as String,
                              _getCategoryIcon(category['type'] as String),
                            ),
                          ))
                      .toList(),
                ],
              ),
            ),
          ),

          // Venues List
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _venues.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_off,
                              size: 15.w,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'No venues found',
                              style: GoogleFonts.inter(
                                fontSize: 14.sp,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Try adjusting your search or filter',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () =>
                            _loadVenuesByCategory(_selectedCategory),
                        child: ListView.builder(
                          padding: EdgeInsets.all(4.w),
                          itemCount: _venues.length,
                          itemBuilder: (context, index) {
                            final venue = _venues[index];
                            return _buildVenueCard(venue);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String value, String label, IconData icon) {
    final isSelected = _selectedCategory == value;

    return GestureDetector(
      onTap: () => _loadVenuesByCategory(value),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[600] : Colors.grey[100],
          borderRadius: BorderRadius.circular(6.w),
          border: Border.all(
            color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 4.w,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            SizedBox(width: 2.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenueCard(Map<String, dynamic> venue) {
    return Container(
      margin: EdgeInsets.only(bottom: 3.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
            child: venue['image_url'] != null
                ? CachedNetworkImage(
                    imageUrl: venue['image_url'],
                    height: 20.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      height: 20.h,
                      color: Colors.grey[200],
                      child: Icon(Icons.restaurant,
                          size: 8.w, color: Colors.grey[400]),
                    ),
                  )
                : Container(
                    height: 20.h,
                    color: Colors.grey[200],
                    child: Icon(Icons.restaurant,
                        size: 8.w, color: Colors.grey[400]),
                  ),
          ),

          Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Type
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        venue['name'] ?? 'Unknown Venue',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(2.w),
                      ),
                      child: Text(
                        _getVenueTypeLabel(venue['venue_type'] ?? ''),
                        style: GoogleFonts.inter(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[600],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 1.h),

                // Rating
                if (venue['rating'] != null)
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 4.w),
                      SizedBox(width: 1.w),
                      Text(
                        venue['rating'].toString(),
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '(${venue['rating'].toString()} stars)',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 1.5.h),

                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_outlined,
                        color: Colors.grey[500], size: 4.w),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        venue['address'] ?? 'Address not available',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                // Pet Amenities
                if (venue['pet_amenities'] != null &&
                    venue['pet_amenities'].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2.h),
                      Text(
                        'Pet Amenities:',
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Wrap(
                        spacing: 2.w,
                        runSpacing: 1.h,
                        children: (venue['pet_amenities'] as List)
                            .take(3) // Show only first 3 amenities
                            .map((amenity) => Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(1.w),
                                    border:
                                        Border.all(color: Colors.green[200]!),
                                  ),
                                  child: Text(
                                    _getAmenityLabel(amenity),
                                    style: GoogleFonts.inter(
                                      fontSize: 9.sp,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),

                SizedBox(height: 2.h),

                // Contact Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (venue['contact_number'] != null)
                      GestureDetector(
                        onTap: () {
                          // TODO: Implement phone calling
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Calling ${venue['contact_number']}')),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.phone,
                                color: Colors.blue[600], size: 4.w),
                            SizedBox(width: 1.w),
                            Text(
                              'Call',
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: Colors.blue[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Implement directions
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Opening directions to ${venue['name']}')),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.directions,
                              color: Colors.green[600], size: 4.w),
                          SizedBox(width: 1.w),
                          Text(
                            'Directions',
                            style: GoogleFonts.inter(
                              fontSize: 11.sp,
                              color: Colors.green[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String type) {
    switch (type) {
      case 'cafe':
        return Icons.local_cafe;
      case 'restaurant':
        return Icons.restaurant;
      case 'park':
        return Icons.park;
      case 'hotel':
        return Icons.hotel;
      default:
        return Icons.location_on;
    }
  }

  String _getVenueTypeLabel(String type) {
    switch (type) {
      case 'cafe':
        return 'Cafe';
      case 'restaurant':
        return 'Restaurant';
      case 'park':
        return 'Park';
      case 'hotel':
        return 'Hotel';
      default:
        return 'Venue';
    }
  }

  String _getAmenityLabel(String amenity) {
    switch (amenity) {
      case 'pet_menu':
        return 'Pet Menu';
      case 'water_bowls':
        return 'Water Bowls';
      case 'pet_area':
        return 'Pet Area';
      case 'outdoor_seating':
        return 'Outdoor Seating';
      case 'pet_treats':
        return 'Pet Treats';
      case 'pet_play_area':
        return 'Play Area';
      default:
        return amenity.replaceAll('_', ' ').toUpperCase();
    }
  }
}
