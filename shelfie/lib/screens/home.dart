import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shelfie/components/add_product.dart';
import 'package:shelfie/components/metrics.dart';
import '../api/gemini.dart';
import '../components/product_tile.dart';
import '../providers/shelf_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveScaledBox(
      width: 1980,
      child: Scaffold(
        floatingActionButton: SizedBox(
          height: 70,
          child: FloatingActionButton.extended(
            backgroundColor: HexColor('#3E95D6'),
            label: const Row(
              children: [
                Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text('Add Product', style: TextStyle(fontSize: 20, color: Colors.white)),
              ],
            ),
            onPressed: () => showDialog(context: context, builder: (_) => AddProduct()),
          ),
        ),
        appBar: AppBar(
          actions: [
            ElevatedButton(
                onPressed: (){
                  ref.read(geminiProvider).testApiCall();
                },
                child: const Text('Test api call')),
            const SizedBox(
              width: 40,
            ),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor('#3E95D6'),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.stacked_line_chart,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Metrics',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const Metrics(),
                ),
              ),
            ),
            const SizedBox(width: 20),
          ],
          toolbarHeight: 80,
          title: Row(
            children: [
              Image.asset(
                'lib/assets/ONDC_logo.png',
                width: 140,
                height: 70,
              ),
              const SizedBox(width: 15),
              Text('Shelfie', style: GoogleFonts.jost(fontSize: 38, fontWeight: FontWeight.w400)),
              const SizedBox(width: 20),
              const Text('An innovative catalog digitizer', style: TextStyle(fontSize: 18))
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey,
              height: 2.0,
            ),
          ),
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
                return ProductTile(product: product, index: index);
              },
            );
          }
          return Center(
            child: Text(
              'Empty Shelf :(',
              style: TextStyle(fontSize: 60, color: Colors.grey[400]),
            ),
          );
        }),
      ),
    );
  }
}
