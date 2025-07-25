import 'package:flutter/material.dart';
import 'package:minoo_deleivery/services/widgit_support.dart';

class DetailsPage extends StatefulWidget {
  final String imageUrl, title, description, subTitle;
  final double price;
  DetailsPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.price,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  int quantity = 1;
  double totalPrice = 0;
  @override
  void initState() {
    // TODO: implement initState
    totalPrice = widget.price * quantity;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.only(top: 30.0, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFf59e0b),
                  borderRadius: BorderRadius.circular(30),
                ),
                height: 40,

                padding: EdgeInsets.all(5),
                child: Icon(Icons.arrow_back, size: 30, color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Image.asset(
                widget.imageUrl,
                height: MediaQuery.of(context).size.height / 3,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20.0),
            Text(widget.title, style: AppWidget.LeadingTextStyle()),
            Text(
              '${widget.price.toStringAsFixed(2)} Birr',
              style: AppWidget.PriceTextStyle(),
            ),
            SizedBox(height: 30),
            Text(
              widget.description,
              style: AppWidget.SimpleOnboardingTextStyle(),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 36.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: TextStyle(fontSize: 24, color: Color(0xFF6A6A6A)),
                  ),
                  Text(
                    "Quantity",
                    style: TextStyle(fontSize: 24, color: Color(0xFF6A6A6A)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Center(
                      child: Text(
                        '${totalPrice.toStringAsFixed(2)} Birr',
                        style: AppWidget.TotalPriceTextStyle(),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (quantity < 10) {
                          quantity++;
                          totalPrice = totalPrice + widget.price;
                        }

                        setState(() {});
                      },
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Color(0xFFf59e0b),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(Icons.add, size: 30, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Text(
                      quantity.toString(),
                      style: AppWidget.LeadingTextStyle(),
                    ),
                    SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        if (quantity > 1) {
                          quantity--;
                          totalPrice = totalPrice - widget.price;
                          setState(() {});
                        }
                      },
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Color(0xFFf59e0b),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.remove,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: Material(
                borderRadius: BorderRadius.circular(15),
                elevation: 3,

                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xFFf59e0b),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      "Order Now",
                      style: AppWidget.TotalPriceTextStyle(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
