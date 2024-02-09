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

final shelfProvider = StateNotifierProvider<ShelfStateNotifier, ShelfState>(
  (ref) => ShelfStateNotifier(ref),
);

class ShelfState {
  final int productId;
  final TextEditingController productNameController;
  final TextEditingController productDescriptionController;
  final double productPrice;
  final double quantity;
  final List<String> categories;
  final double netWeight;
  final TextEditingController barcode;
  final TextEditingController brandName;
  final String manufacturerDate;
  final String expiryDate;
  final XFile? selectedImage;
  final Uint8List? selectedAudio;
  final TextEditingController userEnteredPromptController;
  final String selectedLanguageCode;
  final String? bashiniASRResponse;
  // final AudioRecorder audioRecorder;
  // final bool isRecording;

  ShelfState({
    required this.productId,
    required this.productNameController,
    required this.productDescriptionController,
    required this.productPrice,
    required this.quantity,
    required this.categories,
    required this.netWeight,
    required this.barcode,
    required this.brandName,
    required this.manufacturerDate,
    required this.expiryDate,
    this.selectedImage,
    this.selectedAudio,
    required this.userEnteredPromptController,
    required this.selectedLanguageCode,
    this.bashiniASRResponse,
    // required this.audioRecorder,
    // required this.isRecording,
  });

  ShelfState copyWith({
    int? productId,
    TextEditingController? productNameController,
    TextEditingController? productDescriptionController,
    double? productPrice,
    double? quantity,
    List<String>? categories,
    double? netWeight,
    TextEditingController? barcode,
    TextEditingController? brandName,
    String? manufacturerDate,
    String? expiryDate,
    XFile? selectedImage,
    Uint8List? selectedAudio,
    TextEditingController? userEnteredPromptController,
    String? selectedLanguageCode,
    String? bashiniASRResponse,
    // AudioRecorder? audioRecorder,
    // bool? isRecording,
  }) {
    return ShelfState(
      productId: productId ?? this.productId,
      productNameController: productNameController ?? this.productNameController,
      productDescriptionController: productDescriptionController ?? this.productDescriptionController,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      categories: categories ?? this.categories,
      netWeight: netWeight ?? this.netWeight,
      barcode: barcode ?? this.barcode,
      brandName: brandName ?? this.brandName,
      manufacturerDate: manufacturerDate ?? this.manufacturerDate,
      expiryDate: expiryDate ?? this.expiryDate,
      selectedImage: selectedImage,
      selectedAudio: selectedAudio,
      userEnteredPromptController: userEnteredPromptController ?? this.userEnteredPromptController,
      selectedLanguageCode: selectedLanguageCode ?? this.selectedLanguageCode,
      bashiniASRResponse: bashiniASRResponse,
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
          productPrice: 0.0,
          quantity: 0.0,
          categories: [],
          netWeight: 0.0,
          barcode: TextEditingController(),
          brandName: TextEditingController(),
          manufacturerDate: '',
          expiryDate: '',
          userEnteredPromptController: TextEditingController(),
          selectedLanguageCode: 'en',
          bashiniASRResponse: '',
          // audioRecorder: AudioRecorder(),
          // isRecording: false,
        ));

  final Logger _logger = Logger();
  final GeminiApi _geminiApi;
  final BashiniASRApi _bashiniASRApi;


  void callGeminiApi() async {
    final String userEnteredPrompt = state.userEnteredPromptController.text;
    final XFile image = state.selectedImage!;
    _logger.d('User entered prompt: $userEnteredPrompt');
    final String response =
        await _geminiApi.proVisionModel(image: image, prompt: APIConstants.proVisionPrompt + userEnteredPrompt);
    _logger.i('Gemini response: $response');
  }

  void callBashiniASRApi() async {
   final String response = await _bashiniASRApi.bashiniASR(
      APIConstants.modelIdMapASR[state.selectedLanguageCode]!,
      base64Encode(state.selectedAudio!),
      state.selectedLanguageCode,
    );
   state = state.copyWith(bashiniASRResponse: response);
    _logger.i('Bashini response: $response');
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
      bool isValidFile = result.files.single.name.endsWith(".mp3") ||
          result.files.single.name.endsWith(".wav");
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
    _logger.d(pickedFile?.path);
  }

  void setLanguageCode(String languageCode) {
    state = state.copyWith(selectedLanguageCode: languageCode);
  }

  void resetAllFields() {
    state = ShelfState(
      productId: 0,
      productNameController: TextEditingController(),
      productDescriptionController: TextEditingController(),
      productPrice: 0.0,
      quantity: 0.0,
      categories: [],
      netWeight: 0.0,
      barcode: TextEditingController(),
      brandName: TextEditingController(),
      manufacturerDate: '',
      expiryDate: '',
      selectedImage: null,
      selectedAudio: null,
      userEnteredPromptController: TextEditingController(),
      selectedLanguageCode: 'en',
      bashiniASRResponse: '',
      // audioRecorder: AudioRecorder(),
      // isRecording: false,
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
}
