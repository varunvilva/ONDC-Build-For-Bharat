import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:shelfie/api/bashin_asr.dart';
import 'package:shelfie/api/gemini.dart';
import 'package:shelfie/constants/constants.dart';

import '../components/rounded_chip.dart';

final shelfProvider = StateNotifierProvider<ShelfStateNotifier, ShelfState>(
  (ref) => ShelfStateNotifier(ref),
);

class ShelfState {
  final int productId;
  final TextEditingController productNameController;
  final TextEditingController productDescriptionController;
  final TextEditingController productPriceController;
  final TextEditingController productQuantityController;
  final List<RoundedChip> categories;
  final TextEditingController netWeight;
  final TextEditingController barcode;
  final TextEditingController brandName;
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
    required this.productId,
    required this.productNameController,
    required this.productDescriptionController,
    required this.productPriceController,
    required this.productQuantityController,
    required this.categories,
    required this.netWeight,
    required this.barcode,
    required this.brandName,
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
    int? productId,
    TextEditingController? productNameController,
    TextEditingController? productDescriptionController,
    TextEditingController? productPriceController,
    TextEditingController? productQuantityController,
    List<RoundedChip>? categories,
    TextEditingController? netWeight,
    TextEditingController? barcode,
    TextEditingController? brandName,
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
      productId: productId ?? this.productId,
      productNameController: productNameController ?? this.productNameController,
      productDescriptionController: productDescriptionController ?? this.productDescriptionController,
      productPriceController: productPriceController ?? this.productPriceController,
      productQuantityController: productQuantityController ?? this.productQuantityController,
      categories: categories ?? this.categories,
      netWeight: netWeight ?? this.netWeight,
      barcode: barcode ?? this.barcode,
      brandName: brandName ?? this.brandName,
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
          productId: 0,
          productNameController: TextEditingController(),
          productDescriptionController: TextEditingController(),
          productPriceController: TextEditingController(),
          productQuantityController: TextEditingController(),
          categories: [],
          netWeight: TextEditingController(),
          barcode: TextEditingController(),
          brandName: TextEditingController(),
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

  Future<void> callGeminiVisionApi() async {
    final XFile image = state.selectedImage!;
    final String response = await _geminiApi.proVisionModel(image: image, prompt: APIConstants.proVisionPrompt);
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
    state = state.copyWith(manufacturerDate: date);
  }

  void updateExpiryDate(DateTime? date) {
    state = state.copyWith(expiryDate: date);
  }

  void combinedResponse() {
    final geminiProResponse = extractJsonFromString(state.geminiProResponse ?? '') ?? {};
    final geminiProVisionResponse = extractJsonFromString(state.geminiProVisionResponse ?? '') ?? {};
    final bashiniASRResponse = extractJsonFromString(state.bashiniASRResponse ?? '') ?? {};

    Map<String, dynamic> finalJson = {};

    for (var key in APIConstants.jsonAttributes) {
      List nonNullOrder = [geminiProResponse[key], bashiniASRResponse[key], geminiProVisionResponse[key]];
      nonNullOrder.removeWhere((element) => element == null);
      finalJson[key] = nonNullOrder.isNotEmpty ? nonNullOrder.first : null;
    }

    //update controllers with values of final json
    state = state.copyWith(
      productNameController: TextEditingController(text: finalJson['product_name'] ?? ''),
      productDescriptionController: TextEditingController(text: finalJson['description'] ?? ''),
      productPriceController: TextEditingController(text: finalJson['price']?.toString() ?? ''),
      productQuantityController: TextEditingController(text: finalJson['quantity']?.toString() ?? ''),
      netWeight: TextEditingController(text: finalJson['net_weight']?.toString() ?? ''),
      barcode: TextEditingController(text: finalJson['barcode'] ?? ''),
      brandName: TextEditingController(text: finalJson['manufacturer_brand'] ?? ''),
      categories: finalJson['categories'] != null
          ? (finalJson['categories'] as List)
              .map((e) => RoundedChip(label: e, onDeleted: () {}, color: Colors.tealAccent))
              .toList()
          : [],
      manufacturerDate: DateTime.tryParse(finalJson['manufacturing date'] ?? ''),
      expiryDate: DateTime.tryParse(finalJson['expiration_date'] ?? ''),
      processingComplete: true,
      finalJson: finalJson,
    );

    _logger.i(finalJson);
  }

  // update the finalJson with the value of controllers and other fields
  void updateFinalJson() {
    Map<String, dynamic> finalJson = state.finalJson;
    finalJson['product_name'] = state.productNameController.text;
    finalJson['description'] = state.productDescriptionController.text;
    finalJson['price'] = double.parse(state.productPriceController.text);
    finalJson['quantity'] = double.parse(state.productQuantityController.text);
    finalJson['net_weight'] = state.netWeight;
    finalJson['barcode'] = state.barcode.text;
    finalJson['manufacturer_brand'] = state.brandName.text;
    finalJson['manufacturing date'] = state.manufacturerDate;
    finalJson['expiration_date'] = state.expiryDate;
    finalJson['categories'] = state.categories.map((e) => e.label).toList();
    state = state.copyWith(finalJson: finalJson);
  }

  Future<void> startProcessing() async {
    state = state.copyWith(
      textProcessingState: TextProcessingState.loading,
      imageProcessingState: ImageProcessingState.loading,
      audioProcessingState: AudioProcessingState.loading,
    );

    if (state.selectedAudio != null) {
      await callBashiniASRApi();
      state = state.copyWith(audioProcessingState: AudioProcessingState.complete);
    } else {
      state = state.copyWith(audioProcessingState: AudioProcessingState.error);
    }

    if (state.userEnteredPromptController.text.isNotEmpty) {
      await callGeminiProApi();
      state = state.copyWith(textProcessingState: TextProcessingState.complete);
    } else {
      state = state.copyWith(textProcessingState: TextProcessingState.error);
    }

    if (state.selectedImage != null) {
      await callGeminiVisionApi();
      state = state.copyWith(imageProcessingState: ImageProcessingState.complete);
    } else {
      state = state.copyWith(imageProcessingState: ImageProcessingState.error);
    }

    _logger.d("Gemini Pro Response${state.geminiProResponse ?? ''}");
    _logger.d("Bashini Response${state.bashiniASRResponse ?? ''}");
    _logger.d("Gemini Pro Vision Response${state.geminiProVisionResponse ?? ''}");

    combinedResponse();
  }

  void pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      bool isValidFile = result.files.single.path!.endsWith(".xlsx") ||
          result.files.single.path!.endsWith(".xls") ||
          result.files.single.path!.endsWith(".csv") ||
          result.files.single.path!.endsWith(".txt");
      if (isValidFile) {
        File file = File(result.files.single.path!);

        // TODO : Add code to send the spreadsheet to the backend

        _logger.i("Picked file ${file.path}");
      } else {
        _logger.e("Picked file is not a spreadsheet");
      }
    } else {
      _logger.e("No file picked");
    }
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

  // void startRecording() async {
  //   if (await state.audioRecorder.hasPermission()) {
  //     state = state.copyWith(isRecording: true);
  //
  //
  //
  //     _logger.e('No permission to record audio');
  //   }
  // }
  //
  // void stopRecording() async {
  //   await state.audioRecorder.stop();
  //    _bashiniASRApi.bashiniASR(
  //     APIConstants.modelIdMapASR['hi']!,
  //     base64Encode(encodedAudio),
  //     'hi',
  //   );
  //   state = state.copyWith(isRecording: false);
  // }

  Future<CroppedFile?> _cropImage(XFile image, BuildContext context) {
    return ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [WebUiSettings(context: context, showZoomer: true, enableZoom: true)],
    );
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

  void setLanguageCode(String languageCode) {
    state = state.copyWith(selectedLanguageCode: languageCode);
  }

  // void resetAllFields() {
  //   state = ShelfState(
  //     productId: 0,
  //     productNameController: TextEditingController(),
  //     productDescriptionController: TextEditingController(),
  //     productPrice: 0.0,
  //     quantity: 0.0,
  //     categories: [],
  //     netWeight: 0.0,
  //     barcode: TextEditingController(),
  //     brandName: TextEditingController(),
  //     manufacturerDate: '',
  //     expiryDate: '',
  //     selectedImage: null,
  //     selectedAudio: null,
  //     userEnteredPromptController: TextEditingController(),
  //     selectedLanguageCode: 'en',
  //     bashiniASRResponse: '',
  //     textProcessingState: TextProcessingState.idle,
  //     imageProcessingState: ImageProcessingState.idle,
  //     audioProcessingState: AudioProcessingState.idle,
  //     // audioRecorder: AudioRecorder(),
  //     // isRecording: false,
  //   );
  // }

  void resetImageSelection() {
    state = state.copyWith(selectedImage: null);
    _logger.d('Image selection reset');
  }

  void resetAudioSelection() {
    state = state.copyWith(selectedAudio: null);
    _logger.d('Audio selection reset');
  }
}
