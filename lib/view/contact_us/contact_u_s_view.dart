import 'package:flutter/material.dart';
import 'package:list_and_life/base/extensions/context_extension.dart';
import 'package:list_and_life/res/assets_res.dart';

class ContactUsView extends StatelessWidget {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "We're here to help! Reach out to us through any of the following methods.",
              style: context.textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildContactOption(
              iconPath: AssetsRes.IC_EMAIL_SERVICE,
              title: 'Email',
              subtitle: 'Send us your queries',
              detail: 'am5803@gmail.com',
            ),
            const SizedBox(height: 25),
            _buildContactOption(
              iconPath: AssetsRes.IC_PHONE_SERVICE,
              title: 'Phone',
              subtitle: 'Call us for immediate assistance',
              detail: '+1(555) 000-0000',
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Image.asset(
        assetPath,
        scale: 3,
      ),
    );
  }

  Widget _buildContactOption({
    required String iconPath,
    required String title,
    required String subtitle,
    required String detail,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey),
            ),
            child: Image.asset(
              iconPath,
              scale: 3.6,
            ),
          ),
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 9),
                Text(
                  subtitle,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
                const SizedBox(height: 9),
                Text(
                  detail,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
