import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shelfie/providers/shelf_provider.dart';
import '../constants/constants.dart';
import 'edit_result.dart';

class LoadingDialog extends ConsumerWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    if(ref.watch(shelfProvider).processingComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.pop();
        showDialog(context: context, builder: (context) => const EditResult());
      });
    }

    return ResponsiveScaledBox(
      width: 1900,
      child: AlertDialog(
        content: SizedBox(
          width: 500,
          height: 500,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Processing Audio",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Consumer(
                        builder: (_, ref, __) {
                          if (ref.watch(shelfProvider).audioProcessingState == AudioProcessingState.loading) {
                            return const CircularProgressIndicator();
                          } else if (ref.watch(shelfProvider).selectedAudio == null) {
                            return const Icon(Icons.not_listed_location_outlined, color: Colors.orange, size: 35);
                          } else if (ref.watch(shelfProvider).audioProcessingState == AudioProcessingState.complete) {
                            return const Icon(Icons.check_circle, color: Colors.green, size: 35);
                          } else {
                            return const Icon(Icons.error, color: Colors.red, size: 35);
                          }
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Processing Image",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Consumer(
                        builder: (_, ref, __) {
                          if (ref.watch(shelfProvider).imageProcessingState == ImageProcessingState.loading) {
                            return const CircularProgressIndicator();
                          } else if (ref.watch(shelfProvider).selectedImage == null) {
                            return const Icon(Icons.not_listed_location_outlined, color: Colors.orange, size: 35);
                          } else if (ref.watch(shelfProvider).imageProcessingState == ImageProcessingState.complete) {
                            return const Icon(Icons.check_circle, color: Colors.green, size: 35);
                          } else {
                            return const Icon(Icons.error, color: Colors.red, size: 35);
                          }
                        },
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Processing Text",
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Consumer(
                        builder: (_, ref, __) {
                          if (ref.watch(shelfProvider).textProcessingState == TextProcessingState.loading) {
                            return const CircularProgressIndicator();
                          } else if (ref.watch(shelfProvider).userEnteredPromptController.text.isEmpty) {
                            return const Icon(Icons.not_listed_location_outlined, color: Colors.orange, size: 35);
                          } else if (ref.watch(shelfProvider).textProcessingState == TextProcessingState.complete) {
                            return const Icon(Icons.check_circle, color: Colors.green, size: 35);
                          } else {
                            return const Icon(Icons.error, color: Colors.red, size: 35);
                          }
                        },
                      )
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
