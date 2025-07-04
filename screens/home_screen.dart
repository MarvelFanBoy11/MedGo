// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, use_key_in_widget_constructors, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      id: "1",
      name: "Panadol", 
      price: 29.99, 
      pharmcy: "Eleslam",
      category: "Pain Relief",
      imagePath: "images/Panadol.png", 
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
      id: "2",
      name: "Panthenol", 
      price: 79.99, 
      pharmcy: "mohamed",
      category: "Skin Care",
      imagePath: "images/Panthenol.png", 
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
      id: "3",
      name: "C-Retard", 
      price: 49.99, 
      pharmcy: "Eleman",
      category: "Vitamins",
      imagePath: "images/C-Reterd.png", 
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

  // New code: list for filtered products for the search feature
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }
int cartlen = 0;

void addToCart(Product product) async{
  final user = FirebaseAuth.instance.currentUser;
  cartlen += 1;
  if (user != null) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('cart')
        .doc(product.id)
        .set({
      'name': product.name,
      'price': product.price,
      'imagePath': product.imagePath,
      'description': product.description,
      'Long_description': product.Long_description,
    });
  }
}

  TextEditingController MyController = TextEditingController();

  void showInfo(Product product) {
    setState(() {
      info.add(product);
    });
      Navigator.pop(context);
      Navigator.push(context,MaterialPageRoute(builder: (context) => ProductScreen(productinfo: info[0],),),);
  }

  void _filterProducts(String search) {
    if (search.isEmpty) {
      setState(() {
        filteredProducts = products;
      });
    } else {
      setState(() {
        filteredProducts = products.where((product) {
          return product.name.toLowerCase().contains(search.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, '/Account');
          },
          icon: Icon(Icons.local_pharmacy,color: Color(0xffF6F4EB))),
        backgroundColor: Color(0xff4682A9),
        title: Text("MedGo", style: TextStyle(color: Color(0xffF6F4EB))),
        actions: [
          Text(cartlen.toString(),style: TextStyle(color: Color(0xffF6F4EB)),),
          IconButton(   
            icon: Icon(Icons.shopping_cart,color: Color(0xffF6F4EB)),
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
            SizedBox(height: 16.0),

            TextField(
              controller: MyController,
              onChanged: _filterProducts,
              decoration: InputDecoration(            
                hintText: "Search medicines...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(color: Color(0xff4682A9)),
                ),                
                prefixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 16.0), 

            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                itemCount: filteredProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductCard(product: product, onAddToCart: addToCart, onShowInfo: showInfo);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
