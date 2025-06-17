  // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, sized_box_for_whitespace

  import 'package:flutter/material.dart';
  import '../models/product.dart';

  class ProductCard extends StatefulWidget {
    Product product;
    void Function(Product) onAddToCart;
    void Function(Product) onShowInfo;

    ProductCard({required this.product, required this.onAddToCart,required this.onShowInfo});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
    @override
    Widget build(BuildContext context) {
      return GestureDetector(
        onDoubleTap: () => widget.onShowInfo(widget.product),
        child: Card(
          elevation: 5.0,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 15,
                      children: [
                          Image.asset(
                            widget.product.imagePath,
                            height: 100,
                            width: 150,
                          ),
                          Text(
                            widget.product.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            widget.product.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          Text("\$${widget.product.price}", style: TextStyle(color: Color(0xff4682A9),fontSize: 20)),
                          ElevatedButton(
                            onPressed: () => widget.onAddToCart(widget.product),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff4682A9),
                            ),
                            child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Icon(Icons.shopping_cart,color: Color(0xffF6F4EB),size: 15,),
                                    Text(" Add to Cart",style: TextStyle(color: Color(0xffF6F4EB),fontSize: 15),),
                                ],
                              ),
                          ),
                    ],
                  ),
                ),
              ),
            ),
            );
      }
}