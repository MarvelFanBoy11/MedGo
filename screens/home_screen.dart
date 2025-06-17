// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors

import 'package:demo/screens/Product_screen.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/cart_screen.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> products = [
    Product(
      name: "Panadol", 
      price: 29.99, 
      imagePath: "images/Panadol.jpeg", 
      description: 'Fast-acting pain relief with caffeine boost', 
      Long_description:'''
Panadol is a widely recognized over-the-counter medication providing effective relief from mild to moderate pain and reducing fever. The active ingredient is paracetamol, which helps block pain signals and lowers inflammation.

Usage Instructions:
• Amount to Take: 500 mg to 1000 mg per dose
• How Often: Every 4 to 6 hours as needed, do not exceed 4 grams/day

Important:
- Always follow package directions or physician advice.
- Do not exceed recommended dosage to avoid liver damage.
''', 

      ),
    Product(
      name: "Panthenol", 
      price: 79.99, 
      imagePath: "images/Panthenol.jpeg", 
      description: 'Advanced skin healing and moisturizing cream', 
      Long_description:'''
Panthenol, also known as provitamin B5, is a moisturizing and healing ingredient widely used in skincare and haircare products. It attracts and retains moisture, helping soothe and repair skin and hair.

Usage Instructions:
• Amount to Take / Apply: Apply a thin layer to the affected skin area as needed
• How Often: 2 to 3 times daily or as recommended by a healthcare professional

Important:
- Suitable for sensitive or dry skin types.
- For external use only.
''', 
     
      ),
    Product(
      name: "C-Retard", 
      price: 49.99, 
      imagePath: "images/C-Retard.jpeg", 
      description: 'Vitamin C', 
      Long_description:'''
C-Retard is a sustained-release Vitamin C supplement designed to provide your body with a steady supply of this important antioxidant throughout the day. It supports immune health, collagen production, and overall vitality.

Usage Instructions:
• Amount to Take: 500 mg per tablet
• How Often: 1 tablet twice daily, or as directed by your doctor

Important:
- Not intended to replace a balanced diet.
- Consult your healthcare provider before starting any supplement.
''', 
    ), 
  ];

  List<Product> info = [];

  List<Product> cart = [];

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color(0xff4682A9),
        content:
        Container(
          decoration: 
          BoxDecoration(
            borderRadius: BorderRadius.circular(15)
          ),
                  child: 
                        Text("${product.name} added to cart",style: TextStyle(color: Color(0xffF6F4EB)),)
        ),
      ),
    );
  }


  void showInfo(Product product) {
    setState(() {
      info.add(product);
    });
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context) => ProductScreen(productinfo: info[0],),),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.local_pharmacy,color: Color(0xffF6F4EB)),
        backgroundColor: Color(0xff4682A9),
        title: Text("MedGo", style: TextStyle(color: Color(0xffF6F4EB))),
        actions: [
          Text((cart.length).toString(),style: TextStyle(color: Color(0xffF6F4EB)),),
          IconButton(   
            icon: Icon(Icons.shopping_cart,color: Color(0xffF6F4EB)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(cart: cart),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              width: 500,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFF749BC2),Color(0xFF4682A9),]),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Text("Welcome to MedGo!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xffF6F4EB))),
                  Text("Your trusted online medical store", style: TextStyle(color: Color(0xffF6F4EB))),
                ],
              ),
            ),
            SizedBox(height: 16.0), // Added spacing
            TextField(
              decoration: InputDecoration(
                hintText: "Search medicines...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Color(0xff4682A9)),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16.0), // Added spacing
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68, // Adjusted for better card view
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(product: product, onAddToCart: addToCart, onShowInfo: showInfo,);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}