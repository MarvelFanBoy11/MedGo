// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:demo/models/product.dart';
import 'package:demo/screens/cart_screen.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final Product productinfo;

  ProductScreen({required this.productinfo});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> cart = [];

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color(0xff4682A9),
        content: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          child: Text(
            "${product.name} added to cart",
            style: TextStyle(color: Color(0xffF6F4EB)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xffF6F4EB)),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/Home');
          },
        ),
        backgroundColor: Color(0xff4682A9),
        title: Text(widget.productinfo.name, style: TextStyle(color: Color(0xffF6F4EB))),
        actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Color(0xffF6F4EB)),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  ),
                );
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ListView(
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          widget.productinfo.imagePath,
                          height: 120,
                          width: 160,
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.productinfo.name,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "\$${widget.productinfo.price}",
                                style: TextStyle(color: Color(0xff4682A9), fontSize: 22),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () => addToCart(widget.productinfo),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff4682A9),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.shopping_cart, color: Color(0xffF6F4EB), size: 15),
                                    SizedBox(width: 5),
                                    Text(
                                      "Add to Cart",
                                      style: TextStyle(color: Color(0xffF6F4EB), fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      widget.productinfo.Long_description,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}