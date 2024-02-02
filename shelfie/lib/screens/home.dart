import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shelfie/components/add_product.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {



    return ResponsiveScaledBox(
      width: 1900,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shelfie'),
          actions: [
            Container(
              width: 1500,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AddProduct(),
                  ),
                ),
              ),
            ),
          ],
          backgroundColor: Colors.orangeAccent,
        ),
        body: GridView.count(
          crossAxisCount: 4,
          children: [
            Container(
              color: Colors.red,
              child: const Center(
                  child: Text(
                '1',
                style: TextStyle(fontSize: 35),
              )),
            ),
            Container(
              color: Colors.green,
              child: const Center(
                  child: Text(
                '2',
                style: TextStyle(fontSize: 35),
              )),
            ),
            Container(
              color: Colors.blue,
              child: const Center(
                  child: Text(
                '3',
                style: TextStyle(fontSize: 35),
              )),
            ),
            Container(
              color: Colors.yellow,
              child: const Center(
                  child: Text(
                '4',
                style: TextStyle(fontSize: 35),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
