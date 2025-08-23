import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/image_picker_helper.dart';
import 'package:list_and_life/base/network/base_client.dart';
import 'package:list_and_life/chat_bubble/image_preview_screen.dart';
import 'package:list_and_life/models/inbox_model.dart';
import 'package:list_and_life/models/message_model.dart';
import 'package:list_and_life/models/user_model.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/view_model/chat_vm.dart';
import 'package:list_and_life/widgets/app_error_widget.dart';
import 'package:list_and_life/widgets/app_loading_widget.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/image_view.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../../base/helpers/string_helper.dart';
import '../../../base/network/api_constants.dart';
import '../../../base/network/api_request.dart';
import '../../../models/common/map_response.dart';
import '../../../chat_bubble/message_bar_with_suggetion.dart';
import '../../../main.dart';
import '../../../res/font_res.dart';
import '../../../routes/app_routes.dart';
import '../../../base/utils/utils.dart';
import '../../../base/helpers/LocationService.dart';
import '../../../models/city_model.dart';
import '../../../models/product_detail_model.dart';
import 'package:image_picker/image_picker.dart';

class MessageView extends StatefulWidget {
  final InboxModel? chat;
  const MessageView({super.key, this.chat});

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late ChatVM viewModel;
  ProductDetailModel? _fullProductDetail;
  bool _isLoadingProduct = true;

  @override
  void initState() {
    super.initState();
    viewModel = context.read<ChatVM>();

    // Fetch full product details
    _fetchProductDetails();

    WidgetsBinding.instance.addPostFrameCallback((d) {
      isMessageScreenOpen = true;
      viewModel.initListeners();
      viewModel.chatItems.clear();
      viewModel.messageStreamController.sink.add([]);
      viewModel.currentProductId = widget.chat?.productId ?? 0;

      // Force reset unread count locally
      widget.chat?.unread_count = 0;

      // Reset in viewModel
      viewModel.resetUnreadCount(
        productId: widget.chat?.productId,
        otherUserId: widget.chat?.senderId == DbHelper.getUserModel()?.id
            ? widget.chat?.receiverDetail?.id
            : widget.chat?.senderDetail?.id,
      );

      viewModel.updateChatScreenId(
        roomId: widget.chat?.lastMessageDetail?.roomId,
      );

      viewModel.readChatStatus(
        receiverId: widget.chat?.senderId == DbHelper.getUserModel()?.id
            ? widget.chat?.receiverDetail?.id
            : widget.chat?.senderDetail?.id,
        senderId: widget.chat?.senderId == DbHelper.getUserModel()?.id
            ? widget.chat?.senderDetail?.id
            : widget.chat?.receiverDetail?.id,
        roomId: widget.chat?.lastMessageDetail?.roomId ?? 0,
      );

      viewModel.getMessageList(
        receiverId: widget.chat?.senderId == DbHelper.getUserModel()?.id
            ? widget.chat?.receiverDetail?.id
            : widget.chat?.senderDetail?.id,
        productId: widget.chat?.productId,
      );
    });
  }

  Future<void> _fetchProductDetails() async {
    if (widget.chat?.productId == null) {
      setState(() {
        _isLoadingProduct = false;
      });
      return;
    }

    try {
      ApiRequest apiRequest = ApiRequest(
        url: ApiConstants.getProductUrl(id: '${widget.chat?.productId}'),
        requestType: RequestType.get,
      );

      var response = await BaseClient.handleRequest(apiRequest);

      MapResponse<ProductDetailModel> model =
          MapResponse<ProductDetailModel>.fromJson(
              response, (json) => ProductDetailModel.fromJson(json));

      if (model.body != null) {
        setState(() {
          _fullProductDetail = model.body;
          _isLoadingProduct = false;
        });
      } else {
        setState(() {
          _isLoadingProduct = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingProduct = false;
      });
    }
  }

  @override
  void dispose() {
    isMessageScreenOpen = false;
    super.dispose();
  }

  bool _isCurrentLanguageArabic() {
    return Directionality.of(context) == TextDirection.rtl;
  }

  String _getLocalizedLocationFromCoordinates(double lat, double lng) {
    bool isArabic = _isCurrentLanguageArabic();
    CityModel? nearestCity = LocationService.findNearestCity(lat, lng);

    if (nearestCity != null) {
      if (nearestCity.districts != null) {
        for (var district in nearestCity.districts!) {
          if (district.neighborhoods != null) {
            for (var neighborhood in district.neighborhoods!) {
              double distance = LocationService.calculateDistance(
                  lat, lng, neighborhood.latitude, neighborhood.longitude);
              if (distance <= (neighborhood.radius ?? 2.0)) {
                return isArabic
                    ? "${neighborhood.arabicName}، ${district.arabicName}، ${nearestCity.arabicName}"
                    : "${neighborhood.name}, ${district.name}, ${nearestCity.name}";
              }
            }
          }
          double distanceToDistrict = LocationService.calculateDistance(
              lat, lng, district.latitude, district.longitude);
          if (distanceToDistrict <= (district.radius ?? 5.0)) {
            return isArabic
                ? "${district.arabicName}، ${nearestCity.arabicName}"
                : "${district.name}, ${nearestCity.name}";
          }
        }
      }
      return isArabic ? nearestCity.arabicName : nearestCity.name;
    }
    return isArabic ? "كل مصر" : "All Egypt";
  }

  String _getLocalizedLocationForProduct(ProductDetailModel? data) {
    bool isArabic = _isCurrentLanguageArabic();

    if (data == null) {
      return isArabic ? "مصر" : "Egypt";
    }

    // Priority 1: Use stored English names
    if (data.city != null && data.city!.isNotEmpty) {
      CityModel? cityModel = LocationService.findCityByName(data.city!);
      if (cityModel != null) {
        String cityName = isArabic ? cityModel.arabicName : cityModel.name;

        if (data.districtName != null && data.districtName!.isNotEmpty) {
          DistrictModel? districtModel =
              LocationService.findDistrictByName(cityModel, data.districtName!);
          if (districtModel != null) {
            String districtName =
                isArabic ? districtModel.arabicName : districtModel.name;

            if (data.neighborhoodName != null &&
                data.neighborhoodName!.isNotEmpty &&
                data.neighborhoodName != 'null') {
              NeighborhoodModel? neighborhoodModel =
                  LocationService.findNeighborhoodByName(
                      districtModel, data.neighborhoodName!);
              if (neighborhoodModel != null) {
                String neighborhoodName = isArabic
                    ? neighborhoodModel.arabicName
                    : neighborhoodModel.name;
                return "$neighborhoodName، $districtName، $cityName";
              }
            }
            return "$districtName، $cityName";
          }
        }
        return cityName;
      }
    }

    // Priority 2: Coordinates
    if (data.latitude != null && data.longitude != null) {
      double? lat = double.tryParse(data.latitude!);
      double? lng = double.tryParse(data.longitude!);

      if (lat != null && lng != null && !(lat == 0.0 && lng == 0.0)) {
        String result = _getLocalizedLocationFromCoordinates(lat, lng);
        return result;
      }
    }

    // Priority 3: Parse 'nearby' directly if city was null
    if (data.nearby != null && data.nearby!.isNotEmpty) {
      List<String> parts =
          data.nearby!.split(',').map((e) => e.trim()).toList();
      String finalCityEng = "";
      String finalDistrictEng = "";
      String finalNeighborhoodEng = "";

      if (parts.length == 3) {
        finalNeighborhoodEng = parts[0];
        finalDistrictEng = parts[1];
        finalCityEng = parts[2];
      } else if (parts.length == 2) {
        finalDistrictEng = parts[0];
        finalCityEng = parts[1];
      } else if (parts.length == 1) {
        finalCityEng = parts[0];
      }

      if (finalCityEng.isNotEmpty) {
        CityModel? cityModelFromNearby =
            LocationService.findCityByName(finalCityEng);
        if (cityModelFromNearby != null) {
          String cityNearbyLocalized = isArabic
              ? cityModelFromNearby.arabicName
              : cityModelFromNearby.name;
          if (finalDistrictEng.isNotEmpty) {
            DistrictModel? districtModelFromNearby =
                LocationService.findDistrictByName(
                    cityModelFromNearby, finalDistrictEng);
            if (districtModelFromNearby != null) {
              String districtNearbyLocalized = isArabic
                  ? districtModelFromNearby.arabicName
                  : districtModelFromNearby.name;
              if (finalNeighborhoodEng.isNotEmpty) {
                NeighborhoodModel? neighborhoodModelFromNearby =
                    LocationService.findNeighborhoodByName(
                        districtModelFromNearby, finalNeighborhoodEng);
                if (neighborhoodModelFromNearby != null) {
                  String neighborhoodNearbyLocalized = isArabic
                      ? neighborhoodModelFromNearby.arabicName
                      : neighborhoodModelFromNearby.name;
                  return "$neighborhoodNearbyLocalized، $districtNearbyLocalized، $cityNearbyLocalized";
                }
              }
              return "$districtNearbyLocalized، $cityNearbyLocalized";
            }
          }
          return cityNearbyLocalized;
        }
      }
      // If parsing fails, return nearby as is
      return data.nearby!;
    }

    return isArabic ? "مصر" : "Egypt";
  }

  String parseAmount(dynamic amount) {
    if (amount == null || "$amount".isEmpty || "$amount" == "null") return "0";

    // Try to parse as number
    num? parsedAmount;
    if (amount is num) {
      parsedAmount = amount;
    } else if (amount is String) {
      parsedAmount = num.tryParse(amount);
    }

    if (parsedAmount == null || parsedAmount == 0) return "0";

    return Utils.formatPrice(parsedAmount.toStringAsFixed(0));
  }

  String _getPriceDisplay() {
    // Use full product detail if available, otherwise fall back to chat product detail
    final product = _fullProductDetail ?? widget.chat?.productDetail;

    if (product == null) {
      return "${StringHelper.egp} 0";
    }

    // For jobs category (9)
    if (product.categoryId == 9) {
      // Convert to dynamic first to handle any type
      dynamic salaryFrom = product.salleryFrom;
      dynamic salaryTo = product.salleryTo;

      // Check if salaries are valid
      num? fromNum;
      num? toNum;

      // Parse salaryFrom
      if (salaryFrom != null) {
        if (salaryFrom is num) {
          fromNum = salaryFrom;
        } else {
          // Try to parse as string
          String salaryFromStr = salaryFrom.toString();
          if (salaryFromStr.isNotEmpty && salaryFromStr != 'null') {
            fromNum = num.tryParse(salaryFromStr);
          }
        }
      }

      // Parse salaryTo
      if (salaryTo != null) {
        if (salaryTo is num) {
          toNum = salaryTo;
        } else {
          // Try to parse as string
          String salaryToStr = salaryTo.toString();
          if (salaryToStr.isNotEmpty && salaryToStr != 'null') {
            toNum = num.tryParse(salaryToStr);
          }
        }
      }

      if (fromNum != null && toNum != null && fromNum > 0 && toNum > 0) {
        return "${StringHelper.egp} ${parseAmount(fromNum)} - ${parseAmount(toNum)}";
      }
    }

    // For all other categories
    dynamic price = product.price;

    num? priceNum;

    // Parse price
    if (price != null) {
      if (price is num) {
        priceNum = price;
      } else {
        // Try to parse as string
        String priceStr = price.toString();
        if (priceStr.isNotEmpty && priceStr != 'null') {
          priceNum = num.tryParse(priceStr);
        }
      }
    }

    if (priceNum != null && priceNum > 0) {
      return "${StringHelper.egp} ${parseAmount(priceNum)}";
    }

    return "${StringHelper.egp} 0";
  }

  // Get product status
  String _getProductStatus() {
    final product = _fullProductDetail ?? widget.chat?.productDetail;
    if (product == null) return 'expired';

    // First check if sold
    if (product.sellStatus?.toLowerCase() == 'sold') return 'sold';

    // Then check if expired based on createdAt or approvalDate
    if (product.approvalDate != null && product.approvalDate!.isNotEmpty) {
      try {
        DateTime approvalDate = DateTime.parse(product.approvalDate!);
        DateTime expirationDate = approvalDate.add(Duration(days: 30));
        if (DateTime.now().isAfter(expirationDate)) {
          return 'expired';
        }
      } catch (e) {
        // If parsing fails, fall back to createdAt check
      }
    }

    // Check based on createdAt
    if (product.createdAt != null && product.createdAt!.isNotEmpty) {
      try {
        DateTime createdDate = DateTime.parse(product.createdAt!);
        if (DateTime.now().difference(createdDate).inDays > 30) {
          return 'expired';
        }
      } catch (e) {
        return 'expired'; // If parsing fails, consider it expired
      }
    }

    // If status is 0 (under review) or 2 (rejected), it's not live
    if (product.status == 0 || product.status == 2) {
      return 'expired'; // Show as expired for UI consistency
    }

    return 'live';
  }

  // Quick status check using only chat product detail
  String _getQuickProductStatus(ProductDetailModel? product) {
    if (product == null) return 'expired';

    if (product.sellStatus?.toLowerCase() == 'sold') return 'sold';

    if (product.createdAt != null && product.createdAt!.isNotEmpty) {
      try {
        DateTime createdDate = DateTime.parse(product.createdAt!);
        if (DateTime.now().difference(createdDate).inDays > 30) {
          return 'expired';
        }
      } catch (e) {
        return 'expired';
      }
    }

    return 'live';
  }

  // Check if should show not available screen
  bool _shouldShowNotAvailableScreen() {
    String status = _getProductStatus();
    return status == 'expired' || status == 'sold';
  }

  // Show not available screen
  Widget _buildNotAvailableScreen() {
    String status = _getProductStatus();
    bool isArabic = _isCurrentLanguageArabic();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios, // This will always point left
            color: Colors.black,
          ),
          onPressed: () => context.pop(),
        ),
        // title: Text(
        //   widget.chat?.senderId == DbHelper.getUserModel()?.id
        //       ? "${widget.chat?.receiverDetail?.name ?? ''} ${widget.chat?.receiverDetail?.lastName ?? ''}"
        //       : "${widget.chat?.senderDetail?.name ?? ''} ${widget.chat?.senderDetail?.lastName ?? ''}",
        //   style: TextStyle(color: Colors.black, fontSize: 16),
        //   textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        // ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Product image
              Container(
                width: 200,
                height: 150,
                child: Lottie.asset(
                  AssetsRes
                      .NOT_AVAILABLE_LOTTIE, // You'll need to add this to your assets
                  width: 200,
                  height: 150,
                  fit: BoxFit.contain,
                  repeat: false,
                ),
              ),
              const SizedBox(height: 24),

              // Status indicator
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                      status == 'sold' ? Colors.orange[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: status == 'sold'
                        ? Colors.orange[300]!
                        : Colors.red[300]!,
                  ),
                ),
                child: Text(
                  status == 'sold' ? StringHelper.sold : StringHelper.expired,
                  style: TextStyle(
                    color:
                        status == 'sold' ? Colors.orange[700] : Colors.red[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                ),
              ),
              const SizedBox(height: 16),

              // Not Available text
              Text(
                StringHelper.notAvailable,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                status == 'sold'
                    ? (isArabic
                        ? 'عذراً، هذا المنتج لم يعد متاحاً - تم بيعه'
                        : 'Sorry, this listing is not available anymore - it has been sold')
                    : (isArabic
                        ? 'عذراً، هذا المنتج لم يعد متاحاً - انتهت صلاحيته'
                        : 'Sorry, this listing is not available anymore - it has expired'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),
              const SizedBox(height: 40),

              // Back to Chat button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    StringHelper.backToChat,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to show native attachment picker
  void _showNativeAttachmentPicker() async {
    bool isArabic = _isCurrentLanguageArabic();

    if (Platform.isIOS) {
      // TRUE Native iOS Action Sheet
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                await _handleGallerySelection();
              },
              child: Text(
                StringHelper.photoLibrary,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                await _handleCameraSelection();
              },
              child: Text(
                StringHelper.camera,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                Navigator.pop(context);
                await _handleFileSelection();
              },
              child: Text(
                StringHelper.chooseFile,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: Text(
              StringHelper.cancel,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            ),
          ),
        ),
      );
    } else {
      // Android Bottom Sheet
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text(
                    StringHelper.gallery,
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _handleGallerySelection();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text(
                    StringHelper.camera,
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _handleCameraSelection();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.insert_drive_file),
                  title: Text(
                    StringHelper.chooseFile,
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    await _handleFileSelection();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Future<void> _handleFileSelection() async {
    bool isArabic = _isCurrentLanguageArabic();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        String filePath = result.files.single.path!;
        String fileName = result.files.single.name;
        int fileSize = result.files.single.size;

        // Check file size (limit to 50MB)
        if (fileSize > 50 * 1024 * 1024) {
          DialogHelper.showToast(message: "File size must be less than 50MB");
          return;
        }

        // Show uploading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  StringHelper.uploadingFile,
                  textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                ),
              ],
            ),
          ),
        );

        // Upload file using existing upload method
        String uploadedUrl = await BaseClient.uploadFile(filePath: filePath);
        Navigator.pop(context); // Close loading dialog

        // Create file message with filename and url
        String fileMessage = "$fileName|$uploadedUrl";

        // Send file message with type 5
        viewModel.sendMessage(
            message: fileMessage,
            type: 5, // File message type
            receiverId: widget.chat?.senderId == DbHelper.getUserModel()?.id
                ? widget.chat?.receiverDetail?.id
                : widget.chat?.senderDetail?.id,
            productId: widget.chat?.productId);
      }
    } catch (e) {
      DialogHelper.showToast(message: "Error selecting file");
    }
  }

  Future<void> _handleGallerySelection() async {
    bool isArabic = _isCurrentLanguageArabic();

    var images =
        await ImagePickerHelper.pickMultipleImagesFromGallery(compress: true);

    if (images != null && images.isNotEmpty) {
      // Limit to 10 images
      if (images.length > 10) {
        DialogHelper.showToast(
            message: "You can only send up to 10 images at once");
        images = images.take(10).toList();
      }

      // Show preview screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImagePreviewScreen(
            imagePaths: images!,
            onConfirm: (selectedImages) async {
              // Show uploading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        StringHelper.uploadingImages,
                        textDirection:
                            isArabic ? TextDirection.rtl : TextDirection.ltr,
                      ),
                    ],
                  ),
                ),
              );

              // Upload all images
              List<String> uploadedUrls = [];
              for (var imagePath in selectedImages) {
                String value =
                    await BaseClient.uploadImage(imagePath: imagePath);
                uploadedUrls.add(value);
              }

              Navigator.pop(context); // Close loading dialog

              // Send based on count
              if (uploadedUrls.length == 1) {
                // Single image - use existing type 3
                viewModel.sendMessage(
                    message: uploadedUrls.first,
                    type: 3,
                    receiverId:
                        widget.chat?.senderId == DbHelper.getUserModel()?.id
                            ? widget.chat?.receiverDetail?.id
                            : widget.chat?.senderDetail?.id,
                    productId: widget.chat?.productId);
              } else {
                // Multiple images - use type 4
                viewModel.sendMessage(
                    message: uploadedUrls.join(','),
                    type: 4,
                    receiverId:
                        widget.chat?.senderId == DbHelper.getUserModel()?.id
                            ? widget.chat?.receiverDetail?.id
                            : widget.chat?.senderDetail?.id,
                    productId: widget.chat?.productId);
              }
            },
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraSelection() async {
    bool isArabic = _isCurrentLanguageArabic();

    var image = await ImagePickerHelper.pickImageFromCamera();
    if (image != null) {
      // Show uploading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                StringHelper.uploadingImage,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),
            ],
          ),
        ),
      );

      String value = await BaseClient.uploadImage(imagePath: image);
      Navigator.pop(context);

      viewModel.sendMessage(
          message: value,
          type: 3,
          receiverId: widget.chat?.senderId == DbHelper.getUserModel()?.id
              ? widget.chat?.receiverDetail?.id
              : widget.chat?.senderDetail?.id,
          productId: widget.chat?.productId);
    }
  }

  // Show native block/report action sheet
  void _showBlockReportActionSheet() {
    bool isArabic = _isCurrentLanguageArabic();

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _showReportDialog();
              },
              isDestructiveAction: true,
              child: Text(
                StringHelper.reportUser,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _showBlockDialog();
              },
              isDestructiveAction: true,
              child: Text(
                viewModel.blockedUser
                    ? StringHelper.unblockUser
                    : StringHelper.blockUser,
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: Text(
              StringHelper.cancel,
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.report, color: Colors.red),
                  title: Text(
                    StringHelper.reportUser,
                    style: TextStyle(color: Colors.red),
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showReportDialog();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.block, color: Colors.red),
                  title: Text(
                    viewModel.blockedUser
                        ? StringHelper.unblockUser
                        : StringHelper.blockUser,
                    style: TextStyle(color: Colors.red),
                    textDirection:
                        isArabic ? TextDirection.rtl : TextDirection.ltr,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _showBlockDialog();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AppAlertDialogWithWidget(
        description: '',
        onTap: () {
          if (viewModel.reportTextController.text.trim().isEmpty) {
            DialogHelper.showToast(
                message: StringHelper.pleaseEnterReasonOfReport);
            return;
          }
          context.pop();
          viewModel.reportBlockUser(
              report: true,
              reason: viewModel.reportTextController.text,
              userId: "${widget.chat?.senderId == DbHelper.getUserModel()?.id ? widget.chat?.receiverDetail?.id : widget.chat?.senderDetail?.id}");
        },
        icon: AssetsRes.IC_REPORT_USER,
        showCancelButton: true,
        isTextDescription: false,
        content: AppTextField(
          controller: viewModel.reportTextController,
          maxLines: 4,
          hint: StringHelper.reason,
        ),
        cancelButtonText: StringHelper.no,
        title: StringHelper.reportUser,
        buttonText: StringHelper.yes,
      ),
    );
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (context) => AppAlertDialogWithWidget(
        description: viewModel.blockedUser
            ? StringHelper.areYouSureWantToUnblockThisUser
            : StringHelper.areYouSureWantToBlockThisUser,
        onTap: () {
          context.pop();
          viewModel.reportBlockUser(
              productId: widget.chat?.productId,
              userId:
                  "${widget.chat?.senderId == DbHelper.getUserModel()?.id ? widget.chat?.receiverDetail?.id : widget.chat?.senderDetail?.id}");
        },
        icon: AssetsRes.IC_BLOCK_USER,
        showCancelButton: true,
        cancelButtonText: StringHelper.no,
        title: viewModel.blockedUser
            ? StringHelper.unblockUser
            : StringHelper.blockUser,
        buttonText: StringHelper.yes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = _isCurrentLanguageArabic();

    // Check if should show not available screen
    if (!_isLoadingProduct && _shouldShowNotAvailableScreen()) {
      return _buildNotAvailableScreen();
    }

    // Also check with just the chat product detail (before full product loads)
    if (_isLoadingProduct && widget.chat?.productDetail != null) {
      // Quick check using existing chat product detail
      final quickStatus = _getQuickProductStatus(widget.chat?.productDetail);
      if (quickStatus == 'expired' || quickStatus == 'sold') {
        return _buildNotAvailableScreen();
      }
    }

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 60,
          backgroundColor: Colors.white,
          elevation: 0,
          leadingWidth: 40,
          leading: InkWell(
            onTap: () {
              viewModel.currentProductId = 0;
              context.pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Icon(
                  Icons.arrow_back_ios, // Use the same arrow for both languages
                  size: 20,
                  color: Colors.black),
            ),
          ),
          title: GestureDetector(
            onTap: () {
              // Navigate to user profile
              if (widget.chat?.productDetail?.userId ==
                  DbHelper.getUserModel()?.id) {
                context.push(Routes.myProfilePreview,extra: {'chat':widget.chat});
              } else {
                UserModel? userToShow;
                if (widget.chat?.senderId == DbHelper.getUserModel()?.id) {
                  final receiver = widget.chat?.receiverDetail;
                  if (receiver != null) {
                    userToShow = UserModel(
                      id: receiver.id,
                      name: receiver.name,
                      lastName: receiver.lastName,
                      profilePic: receiver.profilePic,
                      createdAt: DateTime.now().toIso8601String(),
                    );
                  }
                } else {
                  final sender = widget.chat?.senderDetail;
                  if (sender != null) {
                    userToShow = UserModel(
                      id: sender.id,
                      name: sender.name,
                      lastName: sender.lastName,
                      profilePic: sender.profilePic,
                      createdAt: DateTime.now().toIso8601String(),
                    );
                  }
                }
                if (userToShow != null) {
                  context.push(Routes.seeProfile, extra: {"user":userToShow,"chat":widget.chat});
                }
              }
            },
            child: Row(
              children: [
                // User profile image
                ImageView.circle(
                  placeholder: AssetsRes.IC_USER_ICON,
                  image:
                      "${ApiConstants.imageUrl}/${widget.chat?.senderId == DbHelper.getUserModel()?.id ? widget.chat?.receiverDetail?.profilePic ?? '' : widget.chat?.senderDetail?.profilePic ?? ''}",
                  height: 40,
                  width: 40,
                ),
                const Gap(10),
                // User name with blocked indicator
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.chat?.senderId == DbHelper.getUserModel()?.id
                            ? "${widget.chat?.receiverDetail?.name ?? ''} ${widget.chat?.receiverDetail?.lastName ?? ''}"
                            : "${widget.chat?.senderDetail?.name ?? ''} ${widget.chat?.senderDetail?.lastName ?? ''}",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: FontRes.MONTSERRAT_SEMIBOLD,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textDirection:
                            isArabic ? TextDirection.rtl : TextDirection.ltr,
                      ),
                      // Show blocked indicator with ellipses
                      if (viewModel.blockedUser)
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            StringHelper.blocked,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.red[700],
                              fontWeight: FontWeight.w500,
                            ),
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon:
                  const Icon(Icons.more_vert, color: Colors.black87, size: 24),
              onPressed: _showBlockReportActionSheet,
            ),
            const SizedBox(width: 8),
          ],
          centerTitle: false,
        ),
        body: Column(
          children: [
            // Product Card Section with status indicator
            GestureDetector(
              onTap: () {
                String currentUserId = "${DbHelper.getUserModel()?.id}";
                String productUserId = "${widget.chat?.productDetail?.userId}";

                // Use full product detail if available
                final productToPass =
                    _fullProductDetail ?? widget.chat?.productDetail;

                if (productUserId == currentUserId) {
                  context.push(Routes.myProduct, extra: productToPass);
                } else {
                  context.push(Routes.productDetails, extra: productToPass);
                }
              },
              child: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    // Product image with status overlay
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ImageView.rect(
                            height: 70,
                            width: 70,
                            placeholder:
                                viewModel.getPlaceholderForChat(widget.chat),
                            image:
                                "${ApiConstants.imageUrl}/${widget.chat?.productDetail?.image ?? ""}",
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Status indicator
                        Positioned(
                          top: 4,
                          right: isArabic ? null : 4,
                          left: isArabic ? 4 : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getProductStatus() == 'live'
                                  ? Colors.green[600]
                                  : _getProductStatus() == 'sold'
                                      ? Colors.orange[600]
                                      : Colors.red[600],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              _getProductStatus() == 'live'
                                  ? StringHelper.active
                                  : _getProductStatus() == 'sold'
                                      ? StringHelper.sold
                                      : StringHelper.expired,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                              textDirection: isArabic
                                  ? TextDirection.rtl
                                  : TextDirection.ltr,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(12),
                    // Product details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.chat?.productDetail?.name ?? '',
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: FontRes.MONTSERRAT_SEMIBOLD,
                                color: Colors.black87,
                                fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                          const Gap(4),
                          Text(
                            _isLoadingProduct
                                ? "${StringHelper.egp} …"
                                : _getPriceDisplay(),
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: FontRes.MONTSERRAT_BOLD,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                          const Gap(4),
                          Text(
                            _isLoadingProduct
                                ? "…"
                                : _getLocalizedLocationForProduct(
                                    _fullProductDetail ??
                                        widget.chat?.productDetail),
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: isArabic
                                ? TextDirection.rtl
                                : TextDirection.ltr,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Messages List
            Expanded(
              child: StreamBuilder<List<MessageModel>>(
                  stream: viewModel.messageStreamController.stream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<MessageModel> data = snapshot.data ?? [];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              controller: viewModel.scrollController,
                              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
                              itemCount: data.length + 1, // +1 for safety tips
                              reverse: false,
                              shrinkWrap: true,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              itemBuilder: (context, index) {
                                // Safety tips always at index 0 (top)
                                if (index == 0) {
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.amber[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: Colors.amber[300]!),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.info_outline,
                                            color: Colors.amber[800], size: 20),
                                        const Gap(8),
                                        Expanded(
                                          child: Text(
                                            StringHelper.staySecureTranslatable,
                                            style: TextStyle(
                                              color: Colors.amber[900],
                                              fontSize: 12,
                                              height: 1.4,
                                            ),
                                            textDirection: isArabic
                                                ? TextDirection.rtl
                                                : TextDirection.ltr,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                // Messages start from index 1
                                int messageIndex = index - 1;

                                // If no messages, show empty space
                                if (data.isEmpty) {
                                  return SizedBox.shrink();
                                }

                                // Show messages in chronological order (oldest to newest)
                                List<MessageModel> reversedData =
                                    data.reversed.toList();
                                MessageModel currentMessage =
                                    reversedData[messageIndex];

                                // Find previous message for date header logic
                                MessageModel? previousMessage = messageIndex > 0
                                    ? reversedData[messageIndex - 1]
                                    : null;

                                return viewModel.getBubbleWithDateHeader(
                                  context: context,
                                  chat: widget.chat,
                                  data: currentMessage,
                                  previousMessage: previousMessage,
                                  type: currentMessage.messageType,
                                );
                              },
                            ),
                          ),
                          if ((widget.chat?.productDetail?.sellStatus ?? "").toLowerCase() != "sold") ...{
                            viewModel.blockedUser
                                ? SafeArea(
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        border: Border.all(
                                            color: Colors.red.shade200),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.block,
                                              color: Colors.red.shade600,
                                              size: 20),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              viewModel.blockText,
                                              style:
                                                  context.titleMedium?.copyWith(
                                                color: Colors.red.shade700,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                              textDirection: isArabic
                                                  ? TextDirection.rtl
                                                  : TextDirection.ltr,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Column(
                                    children: [
                                      // Horizontal Scrollable Conversation Starters
                                      Container(
                                        height: 36,
                                        margin: const EdgeInsets.only(
                                          left: 8,
                                          right: 8,
                                          bottom: 4,
                                          top: 4,
                                        ),
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: [
                                            StringHelper.hello,
                                            StringHelper.howAreYou,
                                            StringHelper.isItAvailable,
                                            StringHelper.canYouNegotiate,
                                            StringHelper.whereIsTheLocation,
                                            StringHelper.canISeeIt,
                                            StringHelper.whenCanWeMeet,
                                            StringHelper.isItStillForSale,
                                            StringHelper.whatIsTheCondition,
                                            StringHelper.canYouDeliverIt,
                                            StringHelper.finalPrice,
                                            StringHelper.notInterested,
                                            StringHelper.thankYou,
                                            StringHelper.goodLuck,
                                          ].length,
                                          itemBuilder: (context, index) {
                                            final suggestions = [
                                              StringHelper.hello,
                                              StringHelper.howAreYou,
                                              StringHelper.isItAvailable,
                                              StringHelper.canYouNegotiate,
                                              StringHelper.whereIsTheLocation,
                                              StringHelper.canISeeIt,
                                              StringHelper.whenCanWeMeet,
                                              StringHelper.isItStillForSale,
                                              StringHelper.whatIsTheCondition,
                                              StringHelper.canYouDeliverIt,
                                              StringHelper.finalPrice,
                                              StringHelper.notInterested,
                                              StringHelper.thankYou,
                                              StringHelper.goodLuck,
                                            ];

                                            return Container(
                                              margin: const EdgeInsets.only(
                                                  right: 6),
                                              child: InkWell(
                                                onTap: () {
                                                  viewModel
                                                          .messageTextController
                                                          .text =
                                                      suggestions[index];
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 12,
                                                      vertical: 6),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                    border: Border.all(
                                                        color: Colors
                                                            .grey.shade300),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      suggestions[index],
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors
                                                            .grey.shade700,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                      textDirection: isArabic
                                                          ? TextDirection.rtl
                                                          : TextDirection.ltr,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),

                                      // Custom Message Input Bar
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.05),
                                              offset: Offset(0, -1),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: SafeArea(
                                          top: false,
                                          bottom: true,
                                          minimum:
                                              const EdgeInsets.only(bottom: 0),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 6),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                // Native attachment button
                                                IconButton(
                                                  icon: Icon(Icons.attach_file,
                                                      color: Colors.grey[600]),
                                                  onPressed:
                                                      _showNativeAttachmentPicker,
                                                ),

                                                // Message input field
                                                Expanded(
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                      minHeight: 40,
                                                      maxHeight: 100,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey[100],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: TextField(
                                                      controller: viewModel
                                                          .messageTextController,
                                                      textInputAction:
                                                          TextInputAction.send,
                                                      keyboardType:
                                                          TextInputType
                                                              .multiline,
                                                      maxLines: null,
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      textDirection: TextDirection
                                                          .ltr, // Force LTR to prevent character flipping
                                                      textAlign: TextAlign
                                                          .start, // Always start from left
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: StringHelper
                                                            .typeHere,
                                                        hintStyle: TextStyle(
                                                            color: Colors
                                                                .grey[400]),
                                                        border:
                                                            InputBorder.none,
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        16,
                                                                    vertical:
                                                                        10),
                                                        isDense: true,
                                                      ),
                                                      onSubmitted: (value) {
                                                        if (value
                                                            .trim()
                                                            .isNotEmpty) {
                                                          viewModel.sendMessage(
                                                              message: value,
                                                              type: 1,
                                                              receiverId: widget
                                                                          .chat
                                                                          ?.senderId ==
                                                                      DbHelper.getUserModel()
                                                                          ?.id
                                                                  ? widget
                                                                      .chat
                                                                      ?.receiverDetail
                                                                      ?.id
                                                                  : widget
                                                                      .chat
                                                                      ?.senderDetail
                                                                      ?.id,
                                                              productId: widget
                                                                  .chat
                                                                  ?.productId);
                                                          viewModel
                                                              .messageTextController
                                                              .clear();
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),

                                                const SizedBox(width: 4),

                                                // Send button
                                                IconButton(
                                                  icon: Icon(Icons.send,
                                                      color: context
                                                          .theme.primaryColor),
                                                  onPressed: () {
                                                    final message = viewModel
                                                        .messageTextController
                                                        .text
                                                        .trim();
                                                    if (message.isNotEmpty) {
                                                      viewModel.sendMessage(
                                                          message: message,
                                                          type: 1,
                                                          receiverId: widget
                                                                      .chat
                                                                      ?.senderId ==
                                                                  DbHelper.getUserModel()
                                                                      ?.id
                                                              ? widget
                                                                  .chat
                                                                  ?.receiverDetail
                                                                  ?.id
                                                              : widget
                                                                  .chat
                                                                  ?.senderDetail
                                                                  ?.id,
                                                          productId: widget
                                                              .chat?.productId);
                                                      viewModel
                                                          .messageTextController
                                                          .clear();
                                                    }
                                                  },
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      BoxConstraints.tightFor(
                                                          width: 40,
                                                          height: 40),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          } else ...{
                            SafeArea(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  border:
                                      Border.all(color: Colors.orange.shade200),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.sell,
                                        color: Colors.orange.shade600,
                                        size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      StringHelper.productSoldOut,
                                      style: context.titleMedium?.copyWith(
                                        color: Colors.orange.shade700,
                                        fontSize: 14,
                                      ),
                                      textDirection: isArabic
                                          ? TextDirection.rtl
                                          : TextDirection.ltr,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          }
                        ],
                      );
                    }
                    if (snapshot.hasError) {
                      return const AppErrorWidget();
                    }
                    return const AppLoadingWidget();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
