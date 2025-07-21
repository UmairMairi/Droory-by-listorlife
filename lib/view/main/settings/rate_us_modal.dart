// TODO Implement this library.
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:list_and_life/res/font_res.dart'; // Adjust import as per your project
import 'package:list_and_life/base/helpers/string_helper.dart'; // Adjust import as per your project

class RateUsModal extends StatefulWidget {
  @override
  _RateUsModalState createState() => _RateUsModalState();
}

class _RateUsModalState extends State<RateUsModal> {
  int selectedRating = 0;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _openAppStore() async {
    const String appStoreUrl =
        "https://apps.apple.com/app/daroory/id123456789"; // Replace with your App Store URL
    const String playStoreUrl =
        "https://play.google.com/store/apps/details?id=com.yourapp.daroory"; // Replace with your Play Store URL

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      if (await canLaunch(appStoreUrl)) {
        await launch(appStoreUrl);
      }
    } else {
      if (await canLaunch(playStoreUrl)) {
        await launch(playStoreUrl);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // Confetti widget for celebration effect on submission
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            particleDrag: 0.05,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 0.05,
            shouldLoop: false,
            colors: const [
              Colors.green,
              Colors.blue,
              Colors.pink,
              Colors.orange,
              Colors.purple,
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // SVG icon at the top
                SvgPicture.asset(
                  'assets/rate_us_icon.svg', // Ensure this SVG exists in your assets
                  width: 48,
                  height: 48,
                  color: Colors.grey[400],
                ),
                const Gap(16),
                Text(
                  StringHelper
                      .enjoyingDaroory, // Assuming StringHelper is defined
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: FontRes.POPPINS_MEDIUM,
                  ),
                ),
                const Gap(8),
                Text(
                  StringHelper.rateUsOnAppStore,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontFamily: FontRes.POPPINS_REGULAR,
                  ),
                ),
                const Gap(24),
                // Rating stars with SVGs
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedRating = index + 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          transform: Matrix4.identity()
                            ..scale(selectedRating > index ? 1.2 : 1.0),
                          child: SvgPicture.asset(
                            selectedRating > index
                                ? 'assets/star_filled.svg' // Ensure this SVG exists
                                : 'assets/star_empty.svg', // Ensure this SVG exists
                            width: 32,
                            height: 32,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const Gap(24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          StringHelper.maybeLater,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontFamily: FontRes.POPPINS_REGULAR,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: selectedRating > 0
                            ? () async {
                                _confettiController
                                    .play(); // Confetti on submission
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                Navigator.of(context).pop();
                                _openAppStore();
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          StringHelper.rateNow,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: FontRes.POPPINS_REGULAR,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
