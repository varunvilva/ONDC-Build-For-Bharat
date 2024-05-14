import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:shelfie/api/bashin_asr.dart';
import 'package:shelfie/api/gemini.dart';
import 'package:shelfie/constants/constants.dart';

import '../components/rounded_chip.dart';
import '../models/product.dart';

final shelfProvider = StateNotifierProvider<ShelfStateNotifier, ShelfState>(
  (ref) => ShelfStateNotifier(ref),
);

class ShelfState {
  final List<Product> totalProducts;
  final TextEditingController productNameController;
  final TextEditingController productDescriptionController;
  final TextEditingController productPriceController;
  final TextEditingController productQuantityController;
  final List<RoundedChip> categories;
  final TextEditingController netWeightController;
  final TextEditingController barcodeController;
  final TextEditingController brandNameController;
  final DateTime? manufacturerDate;
  final DateTime? expiryDate;
  final TextEditingController addCategoryController;
  Map<String, dynamic> finalJson;

  final XFile? selectedImage;
  final Uint8List? selectedAudio;
  final TextEditingController userEnteredPromptController;
  final String selectedLanguageCode;
  final String? bashiniASRResponse;
  final String? geminiProVisionResponse;
  final String? geminiProResponse;
  final TextProcessingState textProcessingState;
  final ImageProcessingState imageProcessingState;
  final AudioProcessingState audioProcessingState;
  final bool processingComplete;

  // final AudioRecorder audioRecorder;
  // final bool isRecording;

  ShelfState({
    required this.totalProducts,
    required this.productNameController,
    required this.productDescriptionController,
    required this.productPriceController,
    required this.productQuantityController,
    required this.categories,
    required this.netWeightController,
    required this.barcodeController,
    required this.brandNameController,
    required this.manufacturerDate,
    required this.expiryDate,
    required this.addCategoryController,
    required this.finalJson,
    this.selectedImage,
    this.selectedAudio,
    required this.userEnteredPromptController,
    required this.selectedLanguageCode,
    this.bashiniASRResponse,
    this.geminiProVisionResponse,
    this.geminiProResponse,
    required this.textProcessingState,
    required this.imageProcessingState,
    required this.audioProcessingState,
    required this.processingComplete,
    // required this.audioRecorder,
    // required this.isRecording,
  });

  ShelfState copyWith({
    List<Product>? totalProducts,
    TextEditingController? productNameController,
    TextEditingController? productDescriptionController,
    TextEditingController? productPriceController,
    TextEditingController? productQuantityController,
    List<RoundedChip>? categories,
    TextEditingController? netWeightController,
    TextEditingController? barcodeController,
    TextEditingController? brandNameController,
    DateTime? manufacturerDate,
    DateTime? expiryDate,
    TextEditingController? addCategoryController,
    Map<String, dynamic>? finalJson,
    XFile? selectedImage,
    Uint8List? selectedAudio,
    TextEditingController? userEnteredPromptController,
    String? selectedLanguageCode,
    String? bashiniASRResponse,
    String? geminiProVisionResponse,
    String? geminiProResponse,
    TextProcessingState? textProcessingState,
    ImageProcessingState? imageProcessingState,
    AudioProcessingState? audioProcessingState,
    bool? processingComplete,
    // AudioRecorder? audioRecorder,
    // bool? isRecording,
  }) {
    return ShelfState(
      totalProducts: totalProducts ?? this.totalProducts,
      productNameController: productNameController ?? this.productNameController,
      productDescriptionController: productDescriptionController ?? this.productDescriptionController,
      productPriceController: productPriceController ?? this.productPriceController,
      productQuantityController: productQuantityController ?? this.productQuantityController,
      categories: categories ?? this.categories,
      netWeightController: netWeightController ?? this.netWeightController,
      barcodeController: barcodeController ?? this.barcodeController,
      brandNameController: brandNameController ?? this.brandNameController,
      manufacturerDate: manufacturerDate,
      expiryDate: expiryDate,
      addCategoryController: addCategoryController ?? this.addCategoryController,
      finalJson: finalJson ?? this.finalJson,

      selectedImage: selectedImage ?? this.selectedImage,
      selectedAudio: selectedAudio ?? this.selectedAudio,
      userEnteredPromptController: userEnteredPromptController ?? this.userEnteredPromptController,
      selectedLanguageCode: selectedLanguageCode ?? this.selectedLanguageCode,
      bashiniASRResponse: bashiniASRResponse ?? this.bashiniASRResponse,
      geminiProVisionResponse: geminiProVisionResponse ?? this.geminiProVisionResponse,
      geminiProResponse: geminiProResponse ?? this.geminiProResponse,
      textProcessingState: textProcessingState ?? this.textProcessingState,
      imageProcessingState: imageProcessingState ?? this.imageProcessingState,
      audioProcessingState: audioProcessingState ?? this.audioProcessingState,
      processingComplete: processingComplete ?? this.processingComplete,
      // audioRecorder: audioRecorder ?? this.audioRecorder,
      // isRecording: isRecording ?? this.isRecording,
    );
  }
}

class ShelfStateNotifier extends StateNotifier<ShelfState> {
  ShelfStateNotifier(ref)
      : _bashiniASRApi = ref.read(bashiniProvider),
        _geminiApi = ref.read(geminiProvider),
        super(ShelfState(
          totalProducts: [],
          productNameController: TextEditingController(),
          productDescriptionController: TextEditingController(),
          productPriceController: TextEditingController(),
          productQuantityController: TextEditingController(),
          categories: [],
          netWeightController: TextEditingController(),
          barcodeController: TextEditingController(),
          brandNameController: TextEditingController(),
          manufacturerDate: null,
          expiryDate: null,
          addCategoryController: TextEditingController(),
          finalJson: {},

          userEnteredPromptController: TextEditingController(),
          selectedLanguageCode: 'en',
          bashiniASRResponse: '',
          geminiProVisionResponse: '',
          geminiProResponse: '',
          textProcessingState: TextProcessingState.idle,
          imageProcessingState: ImageProcessingState.idle,
          audioProcessingState: AudioProcessingState.idle,
          processingComplete: false,
          // audioRecorder: AudioRecorder(),
          // isRecording: false,
        ));

  final Logger _logger = Logger();
  final GeminiApi _geminiApi;
  final BashiniASRApi _bashiniASRApi;
  double bashiniTime = 0.0;
  double geminiTime = 0.0;
  double geminiVisionTime = 0.0;

  Future<void> callGeminiVisionApi() async {
    final XFile image = state.selectedImage!;
    final String response = await _geminiApi.proVisionModel(image: image);
    state = state.copyWith(geminiProVisionResponse: response);
  }

  Future<void> callGeminiProApi() async {
    final String userEnteredPrompt = state.userEnteredPromptController.text;
    final String response = await _geminiApi.proModel(prompt: APIConstants.proPrompt + userEnteredPrompt);
    state = state.copyWith(geminiProResponse: response);
  }

  Future<void> callBashiniASRApi() async {
    final String response = await _bashiniASRApi.bashiniASR(
      APIConstants.modelIdMapASR[state.selectedLanguageCode]!,
      base64Encode(state.selectedAudio!),
      state.selectedLanguageCode,
    );
    final String responseJson = await _geminiApi.proModel(prompt: APIConstants.proPrompt + response);
    state = state.copyWith(bashiniASRResponse: responseJson);
  }

  Map<String, dynamic>? extractJsonFromString(String corpus) {
    // Find the start and end index of the JSON object
    int startIndex = corpus.indexOf('{');
    int endIndex = corpus.lastIndexOf('}') + 1;

    // If both start and end index are found
    if (startIndex != -1 && endIndex != -1) {
      // Extract the substring containing the JSON object
      String jsonSubstring = corpus.substring(startIndex, endIndex);

      // Parse the JSON string into a Map
      try {
        Map<String, dynamic> jsonObject = json.decode(jsonSubstring);
        return jsonObject;
      } catch (e) {
        _logger.e('Error parsing JSON: $e');
        return null;
      }
    } else {
      _logger.e('No JSON object found in the corpus');
      return null;
    }
  }

  void addCategory() {
    if (state.addCategoryController.text.isNotEmpty) {
      String label = state.addCategoryController.text;
      state = state.copyWith(
        categories: [
          ...state.categories,
          RoundedChip(
            label: label,
            onDeleted: () {
              state = state.copyWith(
                categories: state.categories.where((element) => element.label != label).toList(),
                manufacturerDate: state.manufacturerDate,
                expiryDate: state.expiryDate,
              );
            },
            color: Colors.tealAccent,
          ),
        ],
        manufacturerDate: state.manufacturerDate,
        expiryDate: state.expiryDate,
      );
      state.addCategoryController.clear();
    }
  }

  void updateManufacturerDate(DateTime? date) {
    state = state.copyWith(manufacturerDate: date, expiryDate: state.expiryDate);
  }

  void updateExpiryDate(DateTime? date) {
    state = state.copyWith(expiryDate: date, manufacturerDate: state.manufacturerDate);
  }

  void setLanguageCode(String languageCode) {
    state = state.copyWith(selectedLanguageCode: languageCode);
  }

  Future<void> startProcessing() async {
    state = state.copyWith(
      textProcessingState: TextProcessingState.loading,
      imageProcessingState: ImageProcessingState.loading,
      audioProcessingState: AudioProcessingState.loading,
    );

    final bashiniStartPoint = window.performance.now();
    if (state.selectedAudio != null) {
      await callBashiniASRApi();
      state = state.copyWith(audioProcessingState: AudioProcessingState.complete);
    } else {
      state = state.copyWith(audioProcessingState: AudioProcessingState.error);
    }
    final bashiniEndPoint = window.performance.now();

    final geminiStartPoint = window.performance.now();
    if (state.userEnteredPromptController.text.isNotEmpty) {
      await callGeminiProApi();
      state = state.copyWith(textProcessingState: TextProcessingState.complete);
    } else {
      state = state.copyWith(textProcessingState: TextProcessingState.error);
    }
    final geminiEndPoint = window.performance.now();

    final geminiVisionStartPoint = window.performance.now();
    if (state.selectedImage != null) {
      await callGeminiVisionApi();
      state = state.copyWith(imageProcessingState: ImageProcessingState.complete);
    } else {
      state = state.copyWith(imageProcessingState: ImageProcessingState.error);
    }
    final geminiVisionEndPoint = window.performance.now();

    // The mesures time by window.performance.now() is in nanoseconds so we convert it in seconds
    _logger.d("Bashini ASR Time: ${(bashiniEndPoint - bashiniStartPoint) / 1000} seconds");
    _logger.d("Gemini Pro Time: ${(geminiEndPoint - geminiStartPoint) / 1000} seconds");
    _logger.d("Gemini Pro Vision Time: ${(geminiVisionEndPoint - geminiVisionStartPoint) / 1000} seconds");

    bashiniTime = (bashiniEndPoint - bashiniStartPoint) / 1000;
    geminiTime = (geminiEndPoint - geminiStartPoint) / 1000;
    geminiVisionTime = (geminiVisionEndPoint - geminiVisionStartPoint) / 1000;

    combinedResponse();
  }

  void combinedResponse() {
    final geminiProResponse = extractJsonFromString(state.geminiProResponse ?? '') ?? {};
    final geminiProVisionResponse = extractJsonFromString(state.geminiProVisionResponse ?? '') ?? {};
    final bashiniASRResponse = extractJsonFromString(state.bashiniASRResponse ?? '') ?? {};

    Map<String, dynamic> finalJson = {};

    _logger.d("Gemini Pro Response${state.geminiProResponse ?? ''}");
    _logger.d("Bashini Response${bashiniASRResponse ?? ''}");
    _logger.d("Gemini Pro Vision Response${geminiProVisionResponse ?? ''}");

    for (var key in APIConstants.jsonAttributes) {
      List nonNullOrder = [geminiProResponse[key], bashiniASRResponse[key], geminiProVisionResponse[key]];
      nonNullOrder.removeWhere((element) => element == null);
      finalJson[key] = nonNullOrder.isNotEmpty ? nonNullOrder.first : null;
    }
    finalJsonToControllers(finalJson);

    _logger.i("Final Json \n$finalJson");
  }

  void finalJsonToControllers(finalJson) {
    state.productNameController.text = finalJson['product_name'] ?? '';
    state.productDescriptionController.text = finalJson['description'] ?? '';
    state.productPriceController.text = finalJson['price']?.toString() ?? '';
    state.productQuantityController.text = finalJson['quantity']?.toString() ?? '';
    state.netWeightController.text = finalJson['net_weight']?.toString() ?? '';
    state.barcodeController.text = finalJson['barcode'] ?? '';
    state.brandNameController.text = finalJson['manufacturer_brand'] ?? '';

    DateTime? manufacturerDate;
    DateTime? expiryDate;
    if (finalJson['manufacturing_date'] != null) {
      manufacturerDate = DateFormat('dd-MM-yyyy').parse(finalJson['manufacturing_date']);
    }
    if (finalJson['expiration_date'] != null) {
      expiryDate = DateFormat('dd-MM-yyyy').parse(finalJson['expiration_date']);
    }

    List<RoundedChip> categories = [];
    if (finalJson['categories'] != null) {
      for (var category in finalJson['categories']) {
        String label = category;

        categories.add(
          RoundedChip(
            label: label,
            onDeleted: () {
              state = state.copyWith(
                categories: state.categories.where((element) => element.label != label).toList(),
                manufacturerDate: manufacturerDate,
                expiryDate: expiryDate,
              );
            },
            color: Colors.tealAccent,
          ),
        );
      }
    }
    state = state.copyWith(
      categories: categories,
      manufacturerDate: manufacturerDate,
      expiryDate: expiryDate,
      processingComplete: true,
    );
  }

  void updateFinalJson() {
    Map<String, dynamic> finalJson = state.finalJson;
    Product product = Product();
    if (state.productNameController.text.isNotEmpty) {
      finalJson['product_name'] = state.productNameController.text;
      product.productName = state.productNameController.text;
    }
    if (state.productDescriptionController.text.isNotEmpty) {
      finalJson['description'] = state.productDescriptionController.text;
      product.description = state.productDescriptionController.text;
    }
    if (state.productPriceController.text.isNotEmpty) {
      finalJson['price'] = double.parse(state.productPriceController.text);
      product.price = double.parse(state.productPriceController.text);
    }
    if (state.productQuantityController.text.isNotEmpty) {
      finalJson['quantity'] = double.parse(state.productQuantityController.text);
      product.quantity = double.parse(state.productQuantityController.text);
    }
    if (state.netWeightController.text.isNotEmpty) {
      finalJson['net_weight'] = double.parse(state.netWeightController.text);
      product.netWeight = double.parse(state.netWeightController.text);
    }
    if (state.barcodeController.text.isNotEmpty) {
      finalJson['barcode'] = state.barcodeController.text;
      product.barcode = state.barcodeController.text;
    }
    if (state.brandNameController.text.isNotEmpty) {
      finalJson['manufacturer_brand'] = state.brandNameController.text;
      product.manufacturerBrand = state.brandNameController.text;
    }
    if (state.manufacturerDate != null) {
      finalJson['manufacturing_date'] = DateFormat('dd-MM-yyyy').format(state.manufacturerDate!);
      product.manufacturingDate = DateFormat('dd-MM-yyyy').format(state.manufacturerDate!);
    }
    if (state.expiryDate != null) {
      finalJson['expiration_date'] = DateFormat('dd-MM-yyyy').format(state.expiryDate!);
      product.expirationDate = DateFormat('dd-MM-yyyy').format(state.expiryDate!);
    }
    if (state.categories.isNotEmpty) {
      finalJson['categories'] = state.categories.map((e) => e.label).toList();
      product.categories = state.categories.map((e) => e.label).toList();
    }
    if (state.selectedImage != null) {
      product.image = state.selectedImage;
    }

    product.bashiniTime = bashiniTime;
    product.geminiProTime = geminiTime;
    product.geminiVisionTime = geminiVisionTime;

    bashiniTime = 0;
    geminiTime = 0;
    geminiVisionTime = 0;
    _logger.i(finalJson);
    state = state.copyWith(finalJson: finalJson, totalProducts: [product, ...state.totalProducts]);
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      bool isValidFile = result.files.single.path!.endsWith(".xlsx") ||
          result.files.single.path!.endsWith(".xls") ||
          result.files.single.path!.endsWith(".csv") ||
          result.files.single.path!.endsWith(".txt");
      if (isValidFile) {
        //  File file = File(result.files.single.path!);

        // TODO : Add code to send the spreadsheet to the backend

        //  _logger.i("Picked file ${file.path}");
      } else {
        _logger.e("Picked file is not a spreadsheet");
      }
    } else {
      _logger.e("No file picked");
    }
  }

  void pickImage(BuildContext context) async {
    final XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // CroppedFile? file = await _cropImage(pickedFile, context);
      state = state.copyWith(selectedImage: pickedFile);
      //  _logger.d(file.path);
    }
    _logger.d("Picked Image file path${pickedFile!.path}");
  }

  void pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      bool isValidFile = result.files.single.name.endsWith(".mp3") || result.files.single.name.endsWith(".wav");
      if (isValidFile) {
        _logger.d('Audio file selected');
        Uint8List bytes = result.files.single.bytes!;

        state = state.copyWith(selectedAudio: bytes);
        // TODO : Add code to send the audio to the backend

        _logger.i("Picked file ${result.files.single.name}");
      } else {
        _logger.e("Picked file is not an supported audio file");
      }
    } else {
      _logger.e("No file picked");
    }
  }

  Future<CroppedFile?> _cropImage(XFile image, BuildContext context) {
    return ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [WebUiSettings(context: context, showZoomer: true, enableZoom: true)],
    );
  }

  void resetImageSelection() {
    state = state.copyWith(selectedImage: null);
    _logger.d('Image selection reset');
  }

  void resetAudioSelection() {
    state = state.copyWith(selectedAudio: null);
    _logger.d('Audio selection reset');
  }

  void deleteProduct(int index) {
    List<Product> totalProducts = state.totalProducts;
    totalProducts.removeAt(index);
    state = state.copyWith(totalProducts: totalProducts);
  }

  void clearAll() {
    state = ShelfState(
      totalProducts: state.totalProducts,
      productNameController: TextEditingController(),
      productDescriptionController: TextEditingController(),
      productPriceController: TextEditingController(),
      productQuantityController: TextEditingController(),
      categories: [],
      netWeightController: TextEditingController(),
      barcodeController: TextEditingController(),
      brandNameController: TextEditingController(),
      manufacturerDate: null,
      expiryDate: null,
      addCategoryController: TextEditingController(),
      finalJson: {},

      userEnteredPromptController: TextEditingController(),
      selectedLanguageCode: 'en',
      bashiniASRResponse: '',
      geminiProVisionResponse: '',
      geminiProResponse: '',
      textProcessingState: TextProcessingState.idle,
      imageProcessingState: ImageProcessingState.idle,
      audioProcessingState: AudioProcessingState.idle,
      processingComplete: false,
      // audioRecorder: AudioRecorder(),
      // isRecording: false,
    );
  }
}
