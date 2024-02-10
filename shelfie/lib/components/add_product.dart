import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../providers/shelf_provider.dart';

class AddProduct extends ConsumerWidget {
  const AddProduct({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveScaledBox(
      width: 1900,
      child: AlertDialog(
        title: SizedBox(
          width: 1400,
          height: 900,
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Add Item'),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          color: Colors.greenAccent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Upload File'),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () => ref.read(shelfProvider.notifier).pickFile(),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: const Size(200, 50),
                                ),
                                child: const Text('Upload'),
                              ),
                              const SizedBox(height: 12),
                              const Text('Enter prompt'),
                              const SizedBox(height: 12),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 26.0),
                                child: TextField(
                                  controller: ref.read(shelfProvider).userEnteredPromptController,
                                  maxLines: 15,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.blueAccent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Upload Images'),
                              SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () => ref.read(shelfProvider.notifier).pickImage(context),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: const Size(200, 50),
                                ),
                                child: const Text('Upload'),
                              ),
                              SizedBox(height: 20),
                              Consumer(builder: (_, ref, __) {
                                if (ref.watch(shelfProvider).selectedImage == null) {
                                  return Container();
                                } else {
                                  return GestureDetector(
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Selected Image'),
                                        content: IntrinsicHeight(
                                            child: Container(
                                          child: Column(
                                            children: [
                                              Text('Remove Image?'),
                                              SizedBox(height: 12),
                                              ElevatedButton(
                                                onPressed: () {
                                                  ref.read(shelfProvider.notifier).resetImageSelection();
                                                  context.pop();
                                                },
                                                child: const Text('Remove'),
                                              ),
                                            ],
                                          ),
                                        )),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        ref.watch(shelfProvider).selectedImage!.path,
                                        height: 300,
                                        width: 300,
                                      ),
                                    ),
                                  );
                                }
                              }),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.redAccent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Upload Audio'),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () => ref.read(shelfProvider.notifier).pickAudio(),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: const Size(200, 50),
                                ),
                                child: const Text('Upload'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => ref.read(shelfProvider.notifier).callGeminiApi(),
                      child: const Text('Add'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(150, 50),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
