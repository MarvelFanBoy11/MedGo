// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import 'payment_screen.dart';

class CartScreen extends StatefulWidget {
  CartScreen();

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final CollectionReference userCartCollection;

  @override
  void initState() {
    super.initState();
    final user = _auth.currentUser;
    if (user != null) {
      userCartCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('cart');
    }
  }

  Stream<QuerySnapshot> getCart() {
    return userCartCollection.snapshots();
  }

  Future<void> addProductToCart(Product product) async {
    try {
      await userCartCollection.doc(product.id).set({
        'id': product.id,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'imagePath': product.imagePath,
      });
    } catch (e) {
      print('Failed to add product to cart: $e');
    }
  }

  Future<void> removeProduct(Product product) async {
    try {
      await userCartCollection.doc(product.id).delete();
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
    } catch (e) {
      print('Failed to remove product from cart: $e');
    }
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
        title: Text("Your Cart", style: TextStyle(color: Color(0xffF6F4EB))),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getCart(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final cartDocs = snapshot.data!.docs;
            if (cartDocs.isEmpty) {
              return Center(
                child: Text(
                  "Your cart is empty",
                  style: TextStyle(fontSize: 20, color: Colors.black54),
                ),
              );
            }
            double total = 0;
            List<Product> products = [];
            for (var doc in cartDocs) {
              final data = doc.data() as Map<String, dynamic>;
              total += (data['price'] as num).toDouble();
              products.add(Product(
                id: doc.id,
                name: data['name'],
                pharmcy: data['pharmacy'] ?? '',
                category: data['category'] ?? '',
                description: data['description'],
                Long_description: data['Long_description'] ?? '',
                price: (data['price'] as num).toDouble(),
                imagePath: data['imagePath'],
              ));
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final item = products[index];
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaymentScreen()),
                          );
                        },
                        child: const Text(
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
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading cart'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
