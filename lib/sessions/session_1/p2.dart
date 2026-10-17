// QUESTION (Task 2):
// Simulate a Flipkart-style wishlist feature: create a simple Flutter app
// screen where tapping a heart icon saves the product name locally, so the
// wishlist remains visible even if the app is restarted without internet.

import 'package:flutter/material.dart';
import 'package:flutter_application_1/database.dart';

class P2 extends StatefulWidget {
  const P2({super.key});

  @override
  State<P2> createState() => _P2State();
}

class _P2State extends State<P2> {
  final products = [
    'iPhone 15',
    'Sony Headphones',
    'Nike Shoes',
    'Smart Watch',
  ];
  List<String> wishlist = [];

  @override
  void initState() {
    super.initState();
    loadWishlist(); // read saved items when the screen opens
  }

  Future<void> loadWishlist() async {
    final items = await database_helper.getWishlist();
    setState(() => wishlist = items);
  }

  // SAVE or REMOVE when the heart is tapped
  Future<void> toggleHeart(String name) async {
    if (wishlist.contains(name)) {
      await database_helper.removeFromWishlist(name);
    } else {
      await database_helper.addToWishlist(name);
    }
    loadWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: products.map((name) {
                final liked = wishlist.contains(name);
                return ListTile(
                  title: Text(name),
                  trailing: IconButton(
                    icon: Icon(
                      liked ? Icons.favorite : Icons.favorite_border,
                      color: liked ? Colors.red : Colors.grey,
                    ),
                    onPressed: () => toggleHeart(name),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          const Text('My Wishlist', style: TextStyle(fontSize: 18)),
          SizedBox(
            height: 150,
            child: ListView(
              children: wishlist
                  .map((name) => ListTile(title: Text(name)))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
