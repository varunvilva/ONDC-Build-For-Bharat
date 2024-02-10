import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shelfie/components/loading_dialog.dart';
import 'package:shelfie/constants/constants.dart';

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
                                padding: const EdgeInsets.symmetric(horizontal: 26.0),
                                child: TextField(
                                  controller: ref.read(shelfProvider).userEnteredPromptController,
                                  maxLines: 15,
                                  decoration: const InputDecoration(
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Consumer(
                                builder: (_, ref, __) => DropdownMenu(
                                  initialSelection: ref.watch(shelfProvider).selectedLanguageCode,
                                  dropdownMenuEntries: APIConstants.languages,
                                  onSelected: (value) {
                                    ref.read(shelfProvider.notifier).setLanguageCode(value!);
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text('Upload Audio'),
                              const SizedBox(height: 12),

                              Consumer(
                                builder: (_, ref, __) {
                                  if (ref.watch(shelfProvider).selectedAudio == null) {
                                    return ElevatedButton(
                                      onPressed: () => ref.read(shelfProvider.notifier).pickAudio(),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        minimumSize: const Size(200, 50),
                                      ),
                                      child: const Text('Upload'),
                                    );
                                  } else {
                                    return ElevatedButton(
                                      onPressed: () => ref.read(shelfProvider.notifier).resetAudioSelection(),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        minimumSize: const Size(200, 50),
                                      ),
                                      child: const Text('Remove Selected Audio'),
                                    );
                                  }
                                },
                              ),
                              // SizedBox(height: 20),
                              // Consumer(
                              //   builder: (_, ref, __) {
                              //     if (ref.watch(shelfProvider).isRecording) {
                              //       return IconButton(
                              //         onPressed: () => ref.read(shelfProvider.notifier).stopRecording(),
                              //         icon: Icon(Icons.mic_off),
                              //       );
                              //     } else {
                              //       return IconButton(
                              //         onPressed: () => ref.read(shelfProvider.notifier).startRecording(),
                              //         icon: Icon(Icons.mic),
                              //       );
                              //     }
                              //   },
                              // ),
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
                      onPressed: () {
                        ref.read(shelfProvider.notifier).startProcessing();
                        showDialog(context: context, builder: (_) => const LoadingDialog());

                        // ref.read(shelfProvider.notifier).callBashiniASRApi();
                        // showDialog(
                        //     context: context,
                        //     builder: (_) => AlertDialog(
                        //           title: const Text('Response'),
                        //           content: Consumer(
                        //             builder: (_, ref, __) {
                        //               if (ref.watch(shelfProvider).bashiniASRResponse == null) {
                        //                 return const SizedBox(
                        //                   height: 100,
                        //                   width: 100,
                        //                   child: Scaffold(
                        //                     body: Center(
                        //                       child: CircularProgressIndicator(),
                        //                     ),
                        //                     backgroundColor: Colors.transparent,
                        //                   ),
                        //                 );
                        //               } else {
                        //                 return Text(ref.watch(shelfProvider).bashiniASRResponse!);
                        //               }
                        //             },
                        //           ),
                        //           actions: [
                        //             ElevatedButton(onPressed: () => context.pop(), child: const Text('Close')),
                        //           ],
                        //         ));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        minimumSize: const Size(150, 50),
                      ),
                      child: const Text('Add'),
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
