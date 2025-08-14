import 'dart:ui';
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
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(bottom: 250),
      itemCount: widget.filteredItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // two items per row
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final item = widget.filteredItems[index];
        return Padding(
          padding: const EdgeInsets.only(left: 3),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SizedBox(
              height: 216,
              width: 165,
              child: Container(
                padding: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF6A6A6A),
                      blurRadius: 3,
                      offset: Offset(-1, -1),
                    ),
                  ],
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
                              ),
                        ),
                      ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Positioned(
                              bottom: 0,
                              child: ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: 15,
                                  sigmaY: 5,
                                ),
                                child: Container(
                                  width: 91,
                                  height: 11,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(0, 0, 0, 0.35),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 110,
                              height: 111.76,
                              child: CachedNetworkImage(
                                imageUrl: item.imageUrl,
                                placeholder:
                                    (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                errorWidget:
                                    (context, url, error) =>
                                        Image.asset('assets/images/pizza1.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          item.menuName,
                          style: const TextStyle(
                            color: Color(0xFF3C2F2F),
                            fontFamily: 'roboto',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      // This spacer pushes the price to the bottom
                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${item.menuPrice.toStringAsFixed(0)} ETB',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Row(
                              children: [
                                Text("4.5"),
                                Icon(Icons.star, color: Color(0xfff59e0b)),
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
      },
    );
  }
}
