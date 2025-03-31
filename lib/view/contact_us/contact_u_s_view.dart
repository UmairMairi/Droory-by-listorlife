import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:list_and_life/base/helpers/string_helper.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/base/network/api_constants.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringHelper.contactUs),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: Text(
                StringHelper.hereToHelp,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            _buildContactOption(
              iconPath: AssetsRes.IC_CONTACT_MAIL,
              title: StringHelper.email,
              subtitle: StringHelper.sendUsYourQueries,
              detail: "info@daroory.com",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EmailContactForm(),
                  ),
                );
              },
              iconSize: 48,
            ),
            const Divider(),
            _buildContactOption(
              iconPath: AssetsRes.Contact_Whats,
              title: StringHelper.whatsapp,
              subtitle: StringHelper.messageUsOnWhatsapp,
              detail: "+201158774889",
              onTap: _launchWhatsAppChat,
              iconSize: 48,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required String iconPath,
    required String title,
    required String subtitle,
    required String detail,
    required VoidCallback onTap,
    double iconSize = 48,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque, // Makes entire area clickable
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchWhatsAppChat() async {
    const phoneNumber = "201158774889";
    const message = "Hello, I would like to inquire about your services.";
    final whatsappUrl =
        "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      throw 'Could not launch WhatsApp';
    }
  }
}

class EmailContactForm extends StatefulWidget {
  const EmailContactForm({super.key});

  @override
  State<EmailContactForm> createState() => _EmailContactFormState();
}

class _EmailContactFormState extends State<EmailContactForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final url = Uri.parse(ApiConstants.contactFormUrl());
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode({
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'phone': '+20${_phoneController.text.trim()}',
            'subject': _subjectController.text.trim(),
            'message': _messageController.text.trim(),
          }),
        );

        if (response.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(StringHelper.messageSentSuccess),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          }
        } else {
          throw Exception(StringHelper.failedToSendMessage);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(StringHelper.failedToSendMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          StringHelper.sendMessage,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringHelper.leaveMessageDescription,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 32),
              _buildInputField(
                label: StringHelper.name,
                isRequired: true,
                controller: _nameController,
                hintText: StringHelper.enterName,
                requiredError: StringHelper.nameRequired,
              ),
              const SizedBox(height: 24),
              _buildInputField(
                label: StringHelper.email,
                isRequired: true,
                controller: _emailController,
                hintText: StringHelper.enterEmail,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return StringHelper.emailRequired;
                  }
                  if (!RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value.trim())) {
                    return StringHelper.enterValidEmail;
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              _buildInputField(
                label: StringHelper.phoneNumber,
                isRequired: true,
                controller: _phoneController,
                hintText: StringHelper.enterPhoneNumber,
                requiredError: StringHelper.phoneRequired,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return StringHelper.phoneRequired;
                  }
                  if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return StringHelper.invalidPhoneNumber;
                  }
                  return null;
                },
                prefixText: '+20 ',
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 24),
              _buildInputField(
                label: StringHelper.subject,
                isRequired: true,
                controller: _subjectController,
                hintText: StringHelper.enterSubject,
                requiredError: StringHelper.subjectRequired,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return StringHelper.subjectRequired;
                  }
                  if (value.trim().length < 5) {
                    return StringHelper.subjectTooShort;
                  }
                  if (value.trim().length > 100) {
                    return StringHelper.subjectTooLong;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _buildInputField(
                label: StringHelper.description,
                isRequired: true,
                controller: _messageController,
                hintText: StringHelper.typeMessage,
                requiredError: StringHelper.messageRequired,
                maxLines: 5,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          StringHelper.sendMessage,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required bool isRequired,
    required TextEditingController controller,
    required String hintText,
    String? requiredError,
    String? Function(String?)? validator,
    int maxLines = 1,
    String? prefixText,
    TextInputType? keyboardType,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (isRequired)
              const Text(
                " *",
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintText: hintText,
            prefixText: prefixText,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.blue, width: 1),
            ),
            counterText: maxLength != null ? '' : null,
          ),
          validator: validator ??
              (value) => value?.isEmpty ?? true ? requiredError : null,
        ),
      ],
    );
  }
}
