import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static late Completer<String?> _imagePickerCompleter;

  static bool isLoading = false;

  ///for picking image from camera and gallery
  static Future<String?> openImagePicker({
    required BuildContext context,
    bool isCropping = false,
    bool isCircle = false,
    bool forMultiple = false, // Add this parameter
  }) async {
    _imagePickerCompleter = Completer<String?>();

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        if (Platform.isIOS) {
          return CupertinoActionSheet(
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text(StringHelper.camera),
                onPressed: () async {
                  Navigator.pop(context);
                  isLoading = true;
                  try {
                    String? selectedImage = await pickImageFromCamera(
                      isCropping: isCropping,
                      isCircle: isCircle,
                    );
                    if (selectedImage != null) {
                      _completeImagePicker(selectedImage);
                    }
                    await Future.delayed(const Duration(milliseconds: 250));
                    isLoading = false;
                  } catch (e) {
                    await Future.delayed(const Duration(milliseconds: 250));
                    isLoading = false;
                  }
                },
              ),
              CupertinoActionSheetAction(
                child: Text(StringHelper.gallery),
                onPressed: () async {
                  Navigator.pop(context);
                  if (forMultiple) {
                    // Return special marker for multiple selection
                    _completeImagePicker('OPEN_MULTI_GALLERY');
                  } else {
                    // Single image selection
                    isLoading = true;
                    try {
                      String? selectedImage = await pickImageFromGallery(
                        isCropping: isCropping,
                        isCircle: isCircle,
                      );
                      if (selectedImage != null) {
                        _completeImagePicker(selectedImage);
                      }
                      await Future.delayed(const Duration(milliseconds: 250));
                      isLoading = false;
                    } catch (e) {
                      await Future.delayed(const Duration(milliseconds: 250));
                      isLoading = false;
                    }
                  }
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: const Text('Cancel'),
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context);
                _completeImagePicker(null);
              },
            ),
          );
        } else {
          // Android
          return SafeArea(
            child: Container(
              color: Colors.white,
              child: Wrap(
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('Camera'),
                    onTap: () async {
                      Navigator.pop(context);
                      isLoading = true;
                      try {
                        String? selectedImage = await pickImageFromCamera(
                          isCropping: isCropping,
                          isCircle: isCircle,
                        );
                        if (selectedImage != null) {
                          _completeImagePicker(selectedImage);
                        }
                        await Future.delayed(const Duration(milliseconds: 250));
                        isLoading = false;
                      } catch (e) {
                        await Future.delayed(const Duration(milliseconds: 250));
                        isLoading = false;
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () async {
                      Navigator.pop(context);
                      if (forMultiple) {
                        // Return special marker for multiple selection
                        _completeImagePicker('OPEN_MULTI_GALLERY');
                      } else {
                        // Single image selection
                        isLoading = true;
                        try {
                          String? selectedImage = await pickImageFromGallery(
                            isCropping: isCropping,
                            isCircle: isCircle,
                          );
                          if (selectedImage != null) {
                            _completeImagePicker(selectedImage);
                          }
                          await Future.delayed(
                              const Duration(milliseconds: 250));
                          isLoading = false;
                        } catch (e) {
                          await Future.delayed(
                              const Duration(milliseconds: 250));
                          isLoading = false;
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }
      },
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

  static Future<String?> pickImageFromGallery({
    bool isCropping = false,
    bool isCircle = false,
  }) async {
    // 1) Pick
    XFile? picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return null;
    String filePath = picked.path;

    // 2) Optional crop
    if (isCropping) {
      String? cropped = await cropSelectedImage(filePath, isCircle: isCircle);
      if (cropped != null) filePath = cropped;
    }

    // 3) Compress with fallback
    String finalPath = filePath;
    try {
      final dir = await getTemporaryDirectory();
      final target = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final compressed = await FlutterImageCompress.compressAndGetFile(
        filePath,
        target,
        quality: 75,
        minWidth: 800,
        minHeight: 600,
      );
      if (compressed != null && await File(compressed.path).exists()) {
        finalPath = compressed.path;
      }
    } catch (e) {
      print('⚠️ Compression failed, using original: $e');
    }

    print('✔️ Image path returned: $finalPath');
    return finalPath;
  }

  static Future<List<String>?> pickMultipleImagesFromGallery({
    bool compress = true,
  }) async {
    // 1) Let user pick multiple
    List<XFile>? picks = await ImagePicker().pickMultiImage();
    if (picks == null || picks.isEmpty) return null;

    final dir = await getTemporaryDirectory();
    List<String> finalPaths = []; // ← declare this

    // 2) Loop & compress
    for (var xfile in picks) {
      String path = xfile.path;

      if (compress) {
        try {
          final target =
              '${dir.path}/${DateTime.now().millisecondsSinceEpoch}_${finalPaths.length}.jpg';
          final compressed = await FlutterImageCompress.compressAndGetFile(
            path,
            target,
            quality: 75,
            minWidth: 800,
            minHeight: 600,
          );
          if (compressed != null && await File(compressed.path).exists()) {
            path = compressed.path;
          }
        } catch (e) {
          print('⚠️ Multi-compress failed for $path: $e');
        }
      }

      finalPaths.add(path);
      print('✔️ Multi-picked: $path (${await File(path).length()} bytes)');
    }

    return finalPaths;
  }

  /// Pick image from Camera and return cropped image
  static Future<String?> pickImageFromCamera(
      {bool isCropping = false, bool isCircle = false}) async {
    XFile? path = await ImagePicker().pickImage(source: ImageSource.camera);
    if (path != null && isCropping) {
      String? croppedPath =
          await cropSelectedImage(path.path, isCircle: isCircle);
      return croppedPath;
    }
    return path?.path;
  }

  /// Takes image input and provides all available crop styles
  static Future<String?> cropSelectedImage(
    String imageFile, {
    bool isCircle = false,
    int compressQuality = 60, // Adjustable compression quality
    int maxWidth = 1024,
    int maxHeight = 1920,
  }) async {
    CroppedFile? croppedFile;
    croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile,
      compressQuality: compressQuality,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
          cropStyle: isCircle ? CropStyle.circle : CropStyle.rectangle,
        ),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          rotateButtonsHidden: true,
          aspectRatioLockEnabled: true,
          hidesNavigationBar: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
          aspectRatioLockDimensionSwapEnabled: true,
          cropStyle: isCircle ? CropStyle.circle : CropStyle.rectangle,
          showCancelConfirmationDialog: true,
          // Allows switching between aspect ratios
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
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          lockAspectRatio: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
          ],
        ),
        IOSUiSettings(
          minimumAspectRatio: 16 / 9,
          rectX: 16,
          rectY: 9,
          rotateButtonsHidden: true,
          aspectRatioLockEnabled: true,
          aspectRatioLockDimensionSwapEnabled: true,
          cropStyle: CropStyle.rectangle,
          showCancelConfirmationDialog: true,
          aspectRatioPresets: [
            CropAspectRatioPreset.ratio16x9,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
          ],
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
