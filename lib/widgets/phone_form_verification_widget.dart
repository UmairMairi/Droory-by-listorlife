// phone_verification_widget.dart - FIXED VERSION

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/helpers/db_helper.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/routes/app_routes.dart';
import 'package:list_and_life/view_model/profile_vm.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/otp_form_verification_screen.dart';
import 'package:provider/provider.dart';

class PhoneVerificationWidget extends StatefulWidget {
  final Function(bool isVerified, String? phone) onPhoneStatusChanged;
  final VoidCallback? onAutoSubmit;

  const PhoneVerificationWidget({
    super.key,
    required this.onPhoneStatusChanged,
    this.onAutoSubmit,
  });

  @override
  State<PhoneVerificationWidget> createState() =>
      _PhoneVerificationWidgetState();
}

class _PhoneVerificationWidgetState extends State<PhoneVerificationWidget> {
  final TextEditingController phoneController = TextEditingController();
  bool isPhoneVerified = false;
  String? originalPhone;
  late ProfileVM profileViewModel;
  bool _isNavigatingToOtp = false;

  @override
  void initState() {
    super.initState();
    profileViewModel = context.read<ProfileVM>();
    _initializePhone();
  }

  void _initializePhone() {
    final user = DbHelper.getUserModel();
    if (user?.phoneNo != null) {
      setState(() {
        phoneController.text = user!.phoneNo!;
        originalPhone = user!.phoneNo!;
        isPhoneVerified = user!.phoneVerified == 1;
      });
      widget.onPhoneStatusChanged(isPhoneVerified, user!.phoneNo!);
    }
  }

  void _onPhoneChanged(String value) {
    final user = DbHelper.getUserModel();
    final isCurrentUserPhone = (value == originalPhone);
    setState(() {
      isPhoneVerified = isCurrentUserPhone && (user?.phoneVerified == 1);
    });
    widget.onPhoneStatusChanged(isPhoneVerified, value);
  }

  Future<void> _sendVerification() async {
    if (phoneController.text.trim().isEmpty) {
      DialogHelper.showToast(message: StringHelper.phoneRequired);
      return;
    }
    if (phoneController.text.trim().length < 10) {
      DialogHelper.showToast(message: StringHelper.invalidPhoneNumber);
      return;
    }

    DialogHelper.showLoading();

    try {
      // Step 1: Check if phone exists
      bool phoneExists = await profileViewModel.checkPhoneExists(
        phoneNumber: phoneController.text.trim(),
        countryCode: '+20',
      );

      if (phoneExists) {
        DialogHelper.hideLoading();
        DialogHelper.showToast(
            message: "This phone number is already registered");
        return;
      }

      // Step 2: Send OTP (phone is available)
      await profileViewModel.sendVerificationPhoneWithoutCheck(
        countryCode: '+20',
        phone: phoneController.text.trim(),
      );

      DialogHelper.hideLoading();

      // Step 3: Navigate to OTP screen on success
      _navigateToOTPScreen();
    } catch (e) {
      DialogHelper.hideLoading();

      // Handle specific error messages
      String errorStr = e.toString().toLowerCase();
      String message;

      if (errorStr.contains('already exist') ||
          errorStr.contains('already registered')) {
        message = "This phone number is already registered";
      } else if (errorStr.contains('network') || errorStr.contains('timeout')) {
        message = "Network error. Please check your connection";
      } else {
        message = "Failed to send verification code. Please try again.";
      }

      DialogHelper.showToast(message: message);
      print("❌ Phone verification error: $e");
    }
  }

  void _navigateToOTPScreen() {
    if (_isNavigatingToOtp) return; // Prevent multiple navigations
    _isNavigatingToOtp = true;

    context.push(Routes.verifyOTP,extra: {
      'phoneNumber': phoneController.text.trim(),
      'countryCode': '+20',
      'onVerificationSuccess': () {
        print("DEBUG: OTP Verification Success Callback Called");

        setState(() {
          isPhoneVerified = true;
          originalPhone = phoneController.text.trim();
        });

        print("DEBUG: State updated - isPhoneVerified: $isPhoneVerified");
        widget.onPhoneStatusChanged(true, phoneController.text.trim());
        print("DEBUG: Parent notified of phone verification");

        // 🔧 FIX: Don't navigate back immediately, let the OTP screen handle it
        // The OTP screen will pop itself after calling this callback

        // Schedule auto-submit after the OTP screen has popped
        if (widget.onAutoSubmit != null) {
          print("DEBUG: Auto-submit callback is available, scheduling...");
          Future.delayed(Duration(milliseconds: 800), () {
            if (mounted && isPhoneVerified) {
              print("DEBUG: Triggering auto-submit now!");
              widget.onAutoSubmit!();
            } else {
              print(
                  "DEBUG: Auto-submit conditions not met - mounted: $mounted, isPhoneVerified: $isPhoneVerified");
            }
          });
        } else {
          print("DEBUG: No auto-submit callback provided");
        }
      },
    }).then((_) {
      // Reset the flag when returning from OTP screen
      _isNavigatingToOtp = false;

      print("DEBUG: Returned from OTP screen");
      if (mounted) {
        final user = DbHelper.getUserModel();
        setState(() {
          isPhoneVerified = user?.phoneVerified == 1 &&
              phoneController.text.trim() == user?.phoneNo;
          if (isPhoneVerified) {
            originalPhone = phoneController.text.trim();
          }
        });
        widget.onPhoneStatusChanged(
            isPhoneVerified, phoneController.text.trim());
        print(
            "DEBUG: State refreshed after returning - isPhoneVerified: $isPhoneVerified");
      }
    });
    return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtpFormVerificationScreen(
          phoneNumber: phoneController.text.trim(),
          countryCode: '+20',
          onVerificationSuccess: () {
            print("DEBUG: OTP Verification Success Callback Called");

            setState(() {
              isPhoneVerified = true;
              originalPhone = phoneController.text.trim();
            });

            print("DEBUG: State updated - isPhoneVerified: $isPhoneVerified");
            widget.onPhoneStatusChanged(true, phoneController.text.trim());
            print("DEBUG: Parent notified of phone verification");

            // 🔧 FIX: Don't navigate back immediately, let the OTP screen handle it
            // The OTP screen will pop itself after calling this callback

            // Schedule auto-submit after the OTP screen has popped
            if (widget.onAutoSubmit != null) {
              print("DEBUG: Auto-submit callback is available, scheduling...");
              Future.delayed(Duration(milliseconds: 800), () {
                if (mounted && isPhoneVerified) {
                  print("DEBUG: Triggering auto-submit now!");
                  widget.onAutoSubmit!();
                } else {
                  print(
                      "DEBUG: Auto-submit conditions not met - mounted: $mounted, isPhoneVerified: $isPhoneVerified");
                }
              });
            } else {
              print("DEBUG: No auto-submit callback provided");
            }
          },
        ),
      ),
    ).then((_) {
      // Reset the flag when returning from OTP screen
      _isNavigatingToOtp = false;

      print("DEBUG: Returned from OTP screen");
      if (mounted) {
        final user = DbHelper.getUserModel();
        setState(() {
          isPhoneVerified = user?.phoneVerified == 1 &&
              phoneController.text.trim() == user?.phoneNo;
          if (isPhoneVerified) {
            originalPhone = phoneController.text.trim();
          }
        });
        widget.onPhoneStatusChanged(
            isPhoneVerified, phoneController.text.trim());
        print(
            "DEBUG: State refreshed after returning - isPhoneVerified: $isPhoneVerified");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      title: "${StringHelper.phoneNumber} *",
      hint: StringHelper.phoneNumber,
      keyboardType: TextInputType.phone,
      controller: phoneController,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      onChanged: _onPhoneChanged,
      // ADD EGYPT FLAG PREFIX
      prefix: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Egypt Flag
            Text(
              "🇪🇬",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 6),
            // +20 Code
            Text(
              "+20",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            SizedBox(width: 8),
            // Divider line
            Container(
              height: 20,
              width: 1,
              color: Colors.grey.shade300,
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
      suffix: isPhoneVerified
          ? Icon(
              Icons.verified,
              color: Colors.green,
              size: 20,
            )
          : TextButton(
              onPressed: _sendVerification,
              child: Text(
                "Verify",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return StringHelper.phoneRequired;
        }
        if (value.trim().length < 10) {
          return StringHelper.invalidPhoneNumber;
        }
        return null;
      },
    );
  }
}
