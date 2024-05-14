import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shelfie/components/rounded_chip.dart';
import '../providers/shelf_provider.dart';
import 'material_textformfield.dart';

class EditResult extends ConsumerWidget {
  const EditResult({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ResponsiveScaledBox(
      width: 1980,
      child: AlertDialog(
        title: SizedBox(
          width: 1400,
          height: 900,
          child: Center(
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Edit the parsed result'),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                SizedBox(
                  height: 800,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(8.0),
                          child: Consumer(builder: (_, ref, __) {
                            if (ref.watch(shelfProvider).selectedImage == null) {
                              return ElevatedButton(
                                onPressed: () => ref.read(shelfProvider.notifier).pickImage(context),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  minimumSize: const Size(200, 50),
                                ),
                                child: const Text('Upload'),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Selected Image'),
                                    content: IntrinsicHeight(
                                        child: Column(
                                          children: [
                                            const Text('Remove Image?'),
                                            const SizedBox(height: 12),
                                            ElevatedButton(
                                              onPressed: () {
                                                ref.read(shelfProvider.notifier).resetImageSelection();
                                                context.pop();
                                              },
                                              child: const Text('Remove'),
                                            ),
                                          ],
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
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.all(60),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Colors.black, width: 1),
                              top: BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                const Text(
                                  "Product Name",
                                  style: TextStyle(fontSize: 18),
                                ),
                                const SizedBox(height: 10),
                                MaterialTextFormField(
                                  hintText: 'Product Name',
                                  controller: ref.read(shelfProvider).productNameController,
                                ),
                                const SizedBox(height: 20),
                                const Text("Product Description", style: TextStyle(fontSize: 18)),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: ref.read(shelfProvider).productDescriptionController,
                                  maxLines: 5,
                                  decoration: const InputDecoration(
                                    hintText: 'Product Description',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text("Product Price", style: TextStyle(fontSize: 18)),
                                const SizedBox(height: 10),
                                MaterialTextFormField(
                                  controller: ref.read(shelfProvider).productPriceController,
                                  hintText: 'Product Price',
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                ),
                                const SizedBox(height: 20),
                                const Text("Product Quantity", style: TextStyle(fontSize: 18)),
                                const SizedBox(height: 10),
                                MaterialTextFormField(
                                  controller: ref.read(shelfProvider).productQuantityController,
                                  hintText: 'Product Quantity',
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                ),
                                const SizedBox(height: 20),
                                const Text("Product Categories", style: TextStyle(fontSize: 18)),
                                const SizedBox(height: 10),
                                Container(
                                  width: 700,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Consumer(
                                        builder: (_, ref, __) => Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            for (RoundedChip category in ref.watch(shelfProvider).categories)
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: category,
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Add Category'),
                                      content: MaterialTextFormField(
                                        controller: ref.read(shelfProvider).addCategoryController,
                                        hintText: 'Category Name',
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () => context.pop(),
                                          child: const Text('Back'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => ref.read(shelfProvider.notifier).addCategory(),
                                          child: const Text('Add Category'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: const Text('Add Category'),
                                ),
                                const SizedBox(height: 20),
                                const Text("Net Weight", style: TextStyle(fontSize: 18)),
                                const SizedBox(height: 10),
                                MaterialTextFormField(
                                  hintText: 'Net Weight',
                                  controller: ref.read(shelfProvider).netWeightController,
                                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                ),
                                const SizedBox(height: 20),
                                const Text("Barcode", style: TextStyle(fontSize: 18)),
                                const SizedBox(height: 10),
                                MaterialTextFormField(
                                  controller: ref.read(shelfProvider).barcodeController,
                                  hintText: 'Barcode',
                                ),
                                const SizedBox(height: 20),
                                const Text("Manufacturer/Brand", style: TextStyle(fontSize: 18)),
                                const SizedBox(height: 10),
                                MaterialTextFormField(
                                  controller: ref.read(shelfProvider).brandNameController,
                                  hintText: 'Manufacturer/Brand',
                                ),
                                const SizedBox(height: 20),
                                const Text("Manufacturer Date", style: TextStyle(fontSize: 18)),
                                const SizedBox(height: 10),
                                Consumer(
                                  builder: (_, ref, __) => Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          List<DateTime?>? selectedMFD = await showCalendarDatePicker2Dialog(
                                            context: context,
                                            config: CalendarDatePicker2WithActionButtonsConfig(),
                                            dialogSize: const Size(325, 400),
                                            value: [ref.watch(shelfProvider).manufacturerDate],
                                            borderRadius: BorderRadius.circular(15),
                                          );
                                          if (selectedMFD != null) {
                                            ref
                                                .watch(shelfProvider.notifier)
                                                .updateManufacturerDate(selectedMFD.first!);
                                          }
                                        },
                                        child: Text(ref.watch(shelfProvider).manufacturerDate != null
                                            ? '${ref.watch(shelfProvider).manufacturerDate!.day}/${ref.watch(shelfProvider).manufacturerDate!.month}/${ref.watch(shelfProvider).manufacturerDate!.year}'
                                            : 'Manufacturer Date'),
                                      ),
                                      const SizedBox(width: 20),
                                      ElevatedButton(
                                        onPressed: () => ref.read(shelfProvider.notifier).updateManufacturerDate(null),
                                        child: const Text('Clear'),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const Text("Expiry Date", style: TextStyle(fontSize: 18)),
                                const SizedBox(height: 10),
                                Consumer(
                                  builder: (_, ref, __) => Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          var selectedEXP = await showCalendarDatePicker2Dialog(
                                            context: context,
                                            config: CalendarDatePicker2WithActionButtonsConfig(),
                                            dialogSize: const Size(325, 400),
                                            value: [ref.watch(shelfProvider).expiryDate],
                                            borderRadius: BorderRadius.circular(15),
                                          );
                                          if (selectedEXP != null) {
                                            ref.watch(shelfProvider.notifier).updateExpiryDate(selectedEXP.first!);
                                          }
                                        },
                                        child: Text(ref.watch(shelfProvider).expiryDate != null
                                            ? '${ref.watch(shelfProvider).expiryDate!.day}/${ref.watch(shelfProvider).expiryDate!.month}/${ref.watch(shelfProvider).expiryDate!.year}'
                                            : 'Expiry Date'),
                                      ),
                                      const SizedBox(width: 20),
                                      ElevatedButton(
                                        onPressed: () => ref.read(shelfProvider.notifier).updateExpiryDate(null),
                                        child: const Text('Clear'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(shelfProvider.notifier).updateFinalJson();
                      ref.read(shelfProvider.notifier).clearAll();
                      context.pop();
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: HexColor('#3E95D6'),
                      minimumSize: const Size(150, 50),
                    ),
                    child: const Text('Save Product', style: TextStyle(color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
