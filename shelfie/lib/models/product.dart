

import 'package:image_picker/image_picker.dart';

class Product {
  String? productName;
  XFile? image;
  String? description;
  double? price;
  double? quantity;
  List<String>? categories;
  double? netWeight;
  String? barcode;
  String? manufacturerBrand;
  String? manufacturingDate;
  String? expirationDate;
  double bashiniTime;
  double geminiProTime;
  double geminiVisionTime;

  Product({
    this.productName,
    this.image,
    this.description,
    this.price,
    this.quantity,
    this.categories,
    this.netWeight,
    this.barcode,
    this.manufacturerBrand,
    this.manufacturingDate,
    this.expirationDate,
    this.bashiniTime = 0,
    this.geminiProTime = 0,
    this.geminiVisionTime = 0,
  });


}