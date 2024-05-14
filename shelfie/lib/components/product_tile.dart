import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shelfie/models/product.dart';
import '../providers/shelf_provider.dart';

class ProductTile extends ConsumerWidget {
  const ProductTile({super.key, required this.product, required this.index});

  final Product product;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
        children: [
          if (product.image != null)
            Image.network(
              product.image!.path,
              width: 300,
              height: 200,
              fit: BoxFit.cover,
            ),
          if (product.image == null)
            Image.asset(
              'lib/assets/placeholder-image-2.png',
              width: 270,
              height: 190,
              fit: BoxFit.cover,
            ),
          Text('${product.productName}', style: const TextStyle(fontSize: 20)),
          Text('${product.description}',
              style: const TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis), maxLines: 3),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 40,
                child: ElevatedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              // display the product details
                              Text('Product Name: ${product.productName}'),
                              const SizedBox(height: 20),
                              Text('Description: ${product.description}'),
                              const SizedBox(height: 20),
                              Text('Price: ${product.price}'),
                              const SizedBox(height: 20),
                              Text('Categories: ${product.categories?.join(', ')}'),
                              const SizedBox(height: 20),
                              Text('Quantity: ${product.quantity}'),
                              const SizedBox(height: 20),
                              Text('Net Weight: ${product.netWeight}'),
                              const SizedBox(height: 20),
                              Text('Barcode: ${product.barcode}'),
                              const SizedBox(height: 20),
                              Text('Manufacturer Brand: ${product.manufacturerBrand}'),
                              const SizedBox(height: 20),
                              Text('Manufacturing Date: ${product.manufacturingDate}'),
                              const SizedBox(height: 20),
                              Text('Expiration Date: ${product.expirationDate}'),
                            ],
                          )),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor('#3E95D6'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View Product', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                height: 40,
                width: 40,
                child: IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete Product'),
                      content: const Text('Are you sure you want to delete this product?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            ref.read(shelfProvider.notifier).deleteProduct(index);
                            context.pop();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
