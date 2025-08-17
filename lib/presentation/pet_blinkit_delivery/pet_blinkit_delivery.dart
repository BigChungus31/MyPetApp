import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/cart_summary_widget.dart';
import './widgets/category_chip_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/product_card_widget.dart';
import './widgets/quick_reorder_widget.dart';

class PetBlinkitDelivery extends StatefulWidget {
  const PetBlinkitDelivery({super.key});

  @override
  State<PetBlinkitDelivery> createState() => _PetBlinkitDeliveryState();
}

class _PetBlinkitDeliveryState extends State<PetBlinkitDelivery> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Food';
  List<Map<String, dynamic>> _cartItems = [];
  bool _isLoading = false;

  final List<String> _categories = [
    'Food',
    'Toys',
    'Accessories',
    'Medicine',
    'Grooming'
  ];

  final List<Map<String, dynamic>> _products = [
    {
      "id": 1,
      "name": "Royal Canin Adult Dog Food",
      "price": "₹1,250",
      "image":
          "https://images.unsplash.com/photo-1589924691995-400dc9ecc119?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "deliveryTime": "15 mins",
      "category": "Food",
      "brand": "Royal Canin",
      "petType": "Dog",
      "rating": 4.5,
    },
    {
      "id": 2,
      "name": "Interactive Dog Toy Ball",
      "price": "₹450",
      "image":
          "https://images.unsplash.com/photo-1601758228041-f3b2795255f1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "deliveryTime": "20 mins",
      "category": "Toys",
      "brand": "Pedigree",
      "petType": "Dog",
      "rating": 4.2,
    },
    {
      "id": 3,
      "name": "Premium Cat Collar",
      "price": "₹320",
      "image":
          "https://images.unsplash.com/photo-1574144611937-0df059b5ef3e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "deliveryTime": "25 mins",
      "category": "Accessories",
      "brand": "Whiskas",
      "petType": "Cat",
      "rating": 4.0,
    },
    {
      "id": 4,
      "name": "Deworming Tablets",
      "price": "₹180",
      "image":
          "https://images.unsplash.com/photo-1559757148-5c350d0d3c56?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "deliveryTime": "30 mins",
      "category": "Medicine",
      "brand": "Drools",
      "petType": "Dog",
      "rating": 4.8,
    },
    {
      "id": 5,
      "name": "Pet Shampoo & Conditioner",
      "price": "₹650",
      "image":
          "https://images.unsplash.com/photo-1583337130417-3346a1be7dee?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "deliveryTime": "18 mins",
      "category": "Grooming",
      "brand": "Farmina",
      "petType": "Dog",
      "rating": 4.3,
    },
    {
      "id": 6,
      "name": "Whiskas Cat Food Pouches",
      "price": "₹890",
      "image":
          "https://images.unsplash.com/photo-1548199973-03cce0bbc87b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "deliveryTime": "12 mins",
      "category": "Food",
      "brand": "Whiskas",
      "petType": "Cat",
      "rating": 4.6,
    },
    {
      "id": 7,
      "name": "Feather Wand Cat Toy",
      "price": "₹280",
      "image":
          "https://images.unsplash.com/photo-1415369629372-26f2fe60c467?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "deliveryTime": "22 mins",
      "category": "Toys",
      "brand": "Pedigree",
      "petType": "Cat",
      "rating": 4.1,
    },
    {
      "id": 8,
      "name": "Automatic Water Dispenser",
      "price": "₹1,450",
      "image":
          "https://images.unsplash.com/photo-1583512603805-3cc6b41f3edb?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "deliveryTime": "35 mins",
      "category": "Accessories",
      "brand": "Royal Canin",
      "petType": "Dog",
      "rating": 4.7,
    },
  ];

  final List<Map<String, dynamic>> _quickReorderItems = [
    {
      "id": 1,
      "name": "Royal Canin Adult Dog Food",
      "price": "₹1,250",
      "image":
          "https://images.unsplash.com/photo-1589924691995-400dc9ecc119?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 6,
      "name": "Whiskas Cat Food Pouches",
      "price": "₹890",
      "image":
          "https://images.unsplash.com/photo-1548199973-03cce0bbc87b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
    {
      "id": 2,
      "name": "Interactive Dog Toy Ball",
      "price": "₹450",
      "image":
          "https://images.unsplash.com/photo-1601758228041-f3b2795255f1?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    return _products
        .where(
            (product) => (product['category'] as String) == _selectedCategory)
        .toList();
  }

  double get _totalAmount {
    return _cartItems.fold(0.0, (sum, item) {
      final priceString = (item['product']['price'] as String)
          .replaceAll('₹', '')
          .replaceAll(',', '');
      final price = double.tryParse(priceString) ?? 0.0;
      return sum + (price * (item['quantity'] as int));
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _onQuantityChanged(Map<String, dynamic> product, int quantity) {
    setState(() {
      final existingIndex = _cartItems.indexWhere(
          (item) => (item['product']['id'] as int) == (product['id'] as int));

      if (quantity == 0) {
        if (existingIndex != -1) {
          _cartItems.removeAt(existingIndex);
        }
      } else {
        if (existingIndex != -1) {
          _cartItems[existingIndex]['quantity'] = quantity;
        } else {
          _cartItems.add({
            'product': product,
            'quantity': quantity,
          });
        }
      }
    });
  }

  void _onProductTap(Map<String, dynamic> product) {
    // Navigate to product detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${product['name']} details'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onCheckout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Proceeding to checkout with ${_cartItems.length} items'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        onApplyFilters: (filters) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Filters applied successfully'),
              duration: Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }

  void _onReorder(Map<String, dynamic> item) {
    _onQuantityChanged(item, 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              // Header with Search and Cart
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 2.h,
                  left: 4.w,
                  right: 4.w,
                  bottom: 2.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.lightTheme.colorScheme.shadow
                          .withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // App Bar
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: CustomIconWidget(
                            iconName: 'arrow_back',
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                            size: 24,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pet Blinkit',
                                style: AppTheme.lightTheme.textTheme.titleLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'location_on',
                                    color: AppTheme.lightTheme.primaryColor,
                                    size: 14,
                                  ),
                                  SizedBox(width: 1.w),
                                  Text(
                                    'NCR Region • 10-30 mins',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Cart Icon with Badge
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CustomIconWidget(
                                iconName: 'shopping_cart',
                                color: AppTheme.lightTheme.primaryColor,
                                size: 24,
                              ),
                            ),
                            if (_cartItems.isNotEmpty)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: EdgeInsets.all(1.w),
                                  decoration: BoxDecoration(
                                    color:
                                        AppTheme.lightTheme.colorScheme.error,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 5.w,
                                    minHeight: 5.w,
                                  ),
                                  child: Text(
                                    _cartItems.length.toString(),
                                    style: AppTheme
                                        .lightTheme.textTheme.labelSmall
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onError,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 2.h),

                    // Search Bar
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.lightTheme.scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search for pet supplies...',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(3.w),
                                  child: CustomIconWidget(
                                    iconName: 'search',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 20,
                                  ),
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 1.5.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        GestureDetector(
                          onTap: _showFilterBottomSheet,
                          child: Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.primaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: CustomIconWidget(
                              iconName: 'tune',
                              color: AppTheme.lightTheme.colorScheme.onPrimary,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Category Chips
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return CategoryChipWidget(
                      category: category,
                      isSelected: _selectedCategory == category,
                      onTap: () => _onCategorySelected(category),
                    );
                  },
                ),
              ),

              // Main Content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: CustomScrollView(
                    slivers: [
                      // Quick Reorder Section
                      SliverToBoxAdapter(
                        child: QuickReorderWidget(
                          reorderItems: _quickReorderItems,
                          onReorder: _onReorder,
                        ),
                      ),

                      // Products Grid
                      _isLoading
                          ? SliverToBoxAdapter(
                              child: Container(
                                height: 40.h,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            )
                          : _filteredProducts.isEmpty
                              ? SliverToBoxAdapter(
                                  child: Container(
                                    height: 40.h,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomIconWidget(
                                          iconName: 'inventory_2',
                                          color: AppTheme.lightTheme.colorScheme
                                              .onSurfaceVariant,
                                          size: 48,
                                        ),
                                        SizedBox(height: 2.h),
                                        Text(
                                          'No products found',
                                          style: AppTheme
                                              .lightTheme.textTheme.titleMedium
                                              ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        SizedBox(height: 1.h),
                                        Text(
                                          'Try browsing other categories',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: AppTheme.lightTheme
                                                .colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : SliverPadding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.w),
                                  sliver: SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.75,
                                      crossAxisSpacing: 2.w,
                                      mainAxisSpacing: 2.w,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                      (context, index) {
                                        final product =
                                            _filteredProducts[index];
                                        return ProductCardWidget(
                                          product: product,
                                          onTap: () => _onProductTap(product),
                                          onQuantityChanged: _onQuantityChanged,
                                        );
                                      },
                                      childCount: _filteredProducts.length,
                                    ),
                                  ),
                                ),

                      // Bottom Padding for Cart Summary
                      SliverToBoxAdapter(
                        child: SizedBox(
                            height: _cartItems.isNotEmpty ? 15.h : 5.h),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Cart Summary (Positioned at bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CartSummaryWidget(
              cartItems: _cartItems,
              totalAmount: _totalAmount,
              onCheckout: _onCheckout,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
