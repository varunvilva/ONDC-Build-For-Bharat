import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/shelf_provider.dart';


class Metrics extends ConsumerWidget {
  const Metrics({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // calculate average text processing time
    double bashiniTime =0;
    double geminiProTime =0;
    double geminiProVisionTime =0;
    double totalAverageTime =0;
    for (var product in ref.watch(shelfProvider).totalProducts) {
      bashiniTime += product.bashiniTime;
      geminiProTime += product.geminiProTime;
      geminiProVisionTime += product.geminiVisionTime;
    }
    totalAverageTime = (bashiniTime + geminiProTime + geminiProVisionTime) / ref.watch(shelfProvider).totalProducts.length;
    bashiniTime = bashiniTime / ref.watch(shelfProvider).totalProducts.length;
    geminiProTime = geminiProTime / ref.watch(shelfProvider).totalProducts.length;
    geminiProVisionTime = geminiProVisionTime / ref.watch(shelfProvider).totalProducts.length;
    return AlertDialog(
      content: Container(
        width: 700,
        height: 700,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Text('Average Text Processing time : $geminiProTime seconds', style: const TextStyle(fontSize: 25)),
          const SizedBox(height: 20),
          Text('Average Image Processing time : $geminiProVisionTime seconds', style: const TextStyle(fontSize: 25)),
          const SizedBox(height: 20),
          Text('Average Audio Processing time : $bashiniTime seconds', style: const TextStyle(fontSize: 25)),
          const SizedBox(height: 20),
          Text('Average Total Processing time : $totalAverageTime seconds', style: const TextStyle(fontSize: 25)),
          ],
        ),
      ),
    );
  }
}