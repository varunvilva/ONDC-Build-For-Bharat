import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shelfie/components/add_product.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveScaledBox(
      width: 1900,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text(
                'Shelfie',
                style: TextStyle(fontSize: 30),
              ),
              const SizedBox(width: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const AddProduct(),
                  ),
                  child: const Text('Add Product'),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orangeAccent,
        ),
        body: GridView.count(
          crossAxisCount: 4,
          children: [],
        ),
      ),
    );
  }
}
