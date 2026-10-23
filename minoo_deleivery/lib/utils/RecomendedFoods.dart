import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:minoo_deleivery/pages/details.dart';
import 'package:minoo_deleivery/utils/menu_item.dart';

class Recomendedfoods extends StatefulWidget {
  final List<MenuItem> filteredItems;
  const Recomendedfoods({super.key, required this.filteredItems});

  @override
  State<Recomendedfoods> createState() => _RecomendedfoodsState();
}

class _RecomendedfoodsState extends State<Recomendedfoods> {
  static const int _batchSize = 10;
  int _visibleCount = _batchSize;

  @override
  void didUpdateWidget(covariant Recomendedfoods oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.filteredItems != oldWidget.filteredItems) {
      setState(() {
        _visibleCount = _batchSize;
      });
    }
  }

  void _loadMore() {
    setState(() {
      _visibleCount += _batchSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.filteredItems.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text(
                "No food items found",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final displayedItems = widget.filteredItems.take(_visibleCount).toList();
    final hasMore = _visibleCount < widget.filteredItems.length;
    final remainingCount = widget.filteredItems.length - _visibleCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: displayedItems.length,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 14,
          ),
          itemBuilder: (context, index) {
            final item = displayedItems[index];
            return FoodItemCard(
              key: ValueKey('food_item_${item.id}'),
              item: item,
            );
          },
        ),

        if (hasMore) ...[
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              key: const ValueKey('show_more_button'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xfff59e0b),
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: const Color(0xfff59e0b).withValues(alpha: 0.4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _loadMore,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 22,
                color: Colors.white,
              ),
              label: Text(
                "Show more ($remainingCount)",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        const SizedBox(height: 120), // Spacing for bottom navigation bar
      ],
    );
  }
}

class FoodItemCard extends StatefulWidget {
  final MenuItem item;
  const FoodItemCard({super.key, required this.item});

  @override
  State<FoodItemCard> createState() => _FoodItemCardState();
}

class _FoodItemCardState extends State<FoodItemCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final item = widget.item;

    return Padding(
      padding: const EdgeInsets.only(left: 3),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          height: 216,
          width: 165,
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xffececf9),
            ),
            child: GestureDetector(
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DetailsPage(
                            imageUrl: item.imageUrl,
                            title: item.menuName,
                            subTitle: item.menuCategory ?? '',
                            description: item.menuDescription,
                            price: item.menuPrice,
                            id: item.id.toString(),
                            vendorId: item.vendorId,
                          ),
                    ),
                  ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 140,
                      height: 112,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.10),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          memCacheWidth: 400,
                          memCacheHeight: 320,
                          useOldImageOnUrlChange: true,
                          fadeInDuration: const Duration(milliseconds: 150),
                          placeholder:
                              (context, url) => const FoodContentPlaceholder(),
                          errorWidget:
                              (context, url, error) =>
                                  const FoodContentPlaceholder(isError: true),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      item.menuName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF3C2F2F),
                        fontFamily: 'roboto',
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "4.5",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.star,
                              color: Color(0xfff59e0b),
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A modern skeleton / shadow placeholder representing content loading
class FoodContentPlaceholder extends StatelessWidget {
  final bool isError;
  const FoodContentPlaceholder({super.key, this.isError = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 112,
      decoration: BoxDecoration(
        color: const Color(0xFFDDE1EA),
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE2E6EF), Color(0xFFF0F3F9), Color(0xFFE2E6EF)],
        ),
      ),
      child: Center(
        child: Icon(
          isError ? Icons.restaurant_rounded : Icons.fastfood_outlined,
          size: 32,
          color: const Color(0xFFAAB2C2),
        ),
      ),
    );
  }
}
