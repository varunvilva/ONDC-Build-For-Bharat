import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shelfie/components/add_product.dart';
import 'package:shelfie/components/metrics.dart';

import '../components/product_tile.dart';
import '../providers/shelf_provider.dart';

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
                    builder: (context) => const Metrics(),
                  ),
                  child: const Text('Metrics'),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.orangeAccent,
        ),
        body: Consumer(builder: (_, re, __) {
          if (ref.watch(shelfProvider).totalProducts.isNotEmpty) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: ref.watch(shelfProvider).totalProducts.length,
              itemBuilder: (context, index) {
                final product = ref.watch(shelfProvider).totalProducts[index];
                return ProductTile(product: product);
              },
            );
          }
          return Center(
            child: Text(
              'Empty',
              style: TextStyle(fontSize: 60, color: Colors.grey[400]),
            ),
          );
        }),
      ),
    );
  }
}
