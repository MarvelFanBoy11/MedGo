// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../models/product.dart';

class CartScreen extends StatefulWidget {
  final List<Product> cart;

  CartScreen({required this.cart});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  
  void removeProduct(Product product) {
    setState(() {
      widget.cart.remove(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color(0xff4682A9),
        content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            "${product.name} removed from cart",
            style: TextStyle(color: Color(0xffF6F4EB)),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    double total = widget.cart.fold(0, (sum, item) => sum + item.price);
    bool isEmpty = widget.cart.isEmpty;

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
        title: Text("Your Cart", style: TextStyle(color: Color(0xffF6F4EB))),
      ),
      body: isEmpty // Conditional rendering based on cart status
          ? Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {
                      final item = widget.cart[index];
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(item.imagePath, width: 150, height: 100),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                item.description,
                                style: TextStyle(fontSize: 13, color: Colors.black),
                              ),
                              Text(
                                "\$${item.price}",
                                style: TextStyle(color: Color(0xff4682A9), fontSize: 12),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff4682A9),
                              padding: EdgeInsets.symmetric(horizontal: 2),
                            ),
                            onPressed: () => removeProduct(item),
                            child: Icon(Icons.delete, color: Color(0xffF6F4EB)),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Total: ", style: TextStyle(fontSize: 20)),
                          Text(" \$ ${total.ceil()}", style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff4682A9),
                          padding: EdgeInsets.symmetric(horizontal: 150, vertical: 20),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Proceed To Checkout",
                          style: TextStyle(
                            color: Color(0xffF6F4EB),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}