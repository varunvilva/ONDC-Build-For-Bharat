import 'package:flutter/material.dart';
import 'package:shelfie/models/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
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
          Text(product.productName!, style: const TextStyle(fontSize: 20)),
          Text(product.description!, style: const TextStyle(fontSize: 15,overflow: TextOverflow.ellipsis), maxLines: 3),
          const SizedBox(height: 20),
          ElevatedButton(
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
                  )
                ),
              ),
            ),
            child: const Text('View Product'),
          )
        ],
      ),
    );
  }
}
