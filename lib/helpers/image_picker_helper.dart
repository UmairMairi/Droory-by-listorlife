import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static late Completer<String?> _imagePickerCompleter;

  static bool _isLoading = false;

  // Add a getter to access the loading state.
  static bool get isLoading => _isLoading;

  ///for picking image from camera and gallery
  static Future<String?> openImagePicker(
      {required BuildContext context, bool isCropping = false}) async {
    _imagePickerCompleter = Completer<String?>();

    showModalBottomSheet(
      context: context,
      useRootNavigator: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext bc) => GestureDetector(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          decoration: const BoxDecoration(
              color: Colors.black87,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              color: Colors.pinkAccent,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x194A841C),
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 19,
                                ),
                              ]),
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Camera",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        )
                      ],
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      _isLoading = true;
                      try {
                        String? selectedImage =
                            await pickImageFromCamera(isCropping: isCropping);
                        if (selectedImage != null) {
                          _completeImagePicker(
                              selectedImage); // Complete the Future with the selected image path
                        }
                        await Future.delayed(const Duration(milliseconds: 250));
                        _isLoading = false;
                      } catch (e) {
                        await Future.delayed(const Duration(milliseconds: 250));
                        _isLoading = false;
                      } finally {
                        await Future.delayed(const Duration(milliseconds: 250));
                        _isLoading = false;
                      }
                    },
                  ),
                  const SizedBox(
                    width: 60,
                  ),
                  GestureDetector(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: const BoxDecoration(
                              color: Color(0xff6BBBAE),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x194A841C),
                                  offset: Offset(0.0, 1.0), //(x,y)
                                  blurRadius: 19,
                                ),
                              ]),
                          child: const Icon(
                            Icons.image_rounded,
                            size: 25,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Gallery",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 12),
                        )
                      ],
                    ),
                    onTap: () async {
                      Navigator.pop(context);
                      _isLoading = true;
                      try {
                        String? selectedImage =
                            await pickImageFromGallery(isCropping: isCropping);
                        if (selectedImage != null) {
                          _completeImagePicker(
                              selectedImage); // Complete the Future with the selected image path
                        }
                        await Future.delayed(const Duration(milliseconds: 250));
                        _isLoading = false;
                      } catch (e) {
                        await Future.delayed(const Duration(milliseconds: 250));
                        _isLoading = false;
                      } finally {
                        await Future.delayed(const Duration(milliseconds: 250));
                        _isLoading = false;
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                child: const Padding(
                  padding: EdgeInsets.all(13.0),
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(FocusScopeNode());
        },
      ),
    );

    return _imagePickerCompleter.future;
  }

  Future<Uint8List?> pickImageForWeb(
      {bool isCropping = false,
      CropAspectRatioPreset? cropAspectRatioPreset}) async {
    XFile? path = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (path != null && isCropping) {
      Uint8List? croppedPath =
          await cropSelectedImageWeb(path.path, cropAspectRatioPreset);
      return croppedPath;
    }
    if (path != null) {
      return path.readAsBytes();
    }

    return null;
  }

  static Future<String?> pickImageFromGallery(
      {bool isCropping = false,
      CropAspectRatioPreset? cropAspectRatioPreset}) async {
    XFile? path = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (path != null && isCropping) {
      String? croppedPath =
          await cropSelectedImage(path.path, cropAspectRatioPreset);
      return croppedPath;
    }
    return path?.path;
  }

  /// Pick image from Gallery and return cropped image
  Future<List<File>?> pickMultipleImagesFromGallery(
      {CropAspectRatioPreset? cropAspectRatioPreset}) async {
    List<XFile>? paths = await ImagePicker().pickMultiImage(imageQuality: 30);
    List<File> selectedImages = [];
    if (paths.isNotEmpty) {
      for (XFile file in paths) {
        selectedImages.add(File(file.path));
      }
    }
    return selectedImages;
  }

  /// Pick image from Camera and return cropped image
  static Future<String?> pickImageFromCamera(
      {bool isCropping = false,
      CropAspectRatioPreset? cropAspectRatioPreset}) async {
    XFile? path = await ImagePicker().pickImage(source: ImageSource.camera);
    if (path != null && isCropping) {
      String? croppedPath =
          await cropSelectedImage(path.path, cropAspectRatioPreset);
      return croppedPath;
    }
    return path?.path;
  }

  /// Takes image input
  static Future<String?> cropSelectedImage(
      String imageFile, CropAspectRatioPreset? cropAspectRatioPreset) async {
    CroppedFile? croppedFile;
    croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile,
      compressQuality: 60,
      aspectRatioPresets: [
        cropAspectRatioPreset ?? CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );
    return croppedFile?.path;
  }

  Future<Uint8List?> cropSelectedImageWeb(
      String imageFile, CropAspectRatioPreset? cropAspectRatioPreset) async {
    CroppedFile? croppedFile;
    croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile,
      compressQuality: 60,
      aspectRatioPresets: [
        cropAspectRatioPreset ?? CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
        ),
      ],
    );
    return XFile(croppedFile?.path ?? '').readAsBytes();
  }

  static void _completeImagePicker(String? imagePath) {
    if (!_imagePickerCompleter.isCompleted) {
      _imagePickerCompleter.complete(imagePath);
    }
  }
}
