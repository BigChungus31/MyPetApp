import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductCardWidget extends StatefulWidget {
  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final Function(Map<String, dynamic>, int) onQuantityChanged;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.onTap,
    required this.onQuantityChanged,
  });

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  int quantity = 0;

  void _incrementQuantity() {
    setState(() {
      quantity++;
    });
    widget.onQuantityChanged(widget.product, quantity);
  }

  void _decrementQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
      widget.onQuantityChanged(widget.product, quantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: CustomImageWidget(
                imageUrl: widget.product['image'] as String,
                width: double.infinity,
                height: 20.h,
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.product['name'] as String,
                    style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 1.h),

                  // Price and Delivery Time Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.product['price'] as String,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.product['deliveryTime'] as String,
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 1.5.h),

                  // Add/Quantity Controls
                  quantity == 0
                      ? SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _incrementQuantity,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.lightTheme.primaryColor,
                              foregroundColor:
                                  AppTheme.lightTheme.colorScheme.onPrimary,
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Add',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: _decrementQuantity,
                                icon: CustomIconWidget(
                                  iconName: 'remove',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 18,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 8.w,
                                  minHeight: 4.h,
                                ),
                              ),
                              Text(
                                quantity.toString(),
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              IconButton(
                                onPressed: _incrementQuantity,
                                icon: CustomIconWidget(
                                  iconName: 'add',
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  size: 18,
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 8.w,
                                  minHeight: 4.h,
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
