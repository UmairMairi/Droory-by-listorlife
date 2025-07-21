// lib/base/helpers/profanity_filter.dart

import 'package:flutter/material.dart';
import 'package:list_and_life/base/helpers/string_helper.dart';

class ProfanityHelper {
  // Keep only the most obvious/explicit bad words
  static const List<String> _englishBadWords = [
    // Only very explicit words that are rarely legitimate
    "fuck", "fucking", "motherfucker", "fuckface", "fucked", "fucker",
    "shit", "bullshit", "shitty", "shithead",
    "bitch", "bitches", "son of a bitch",
    "bastard", "asshole", "dumbass",
    "cunt", "pussy", "cock", "dick", "penis", "vagina",
    "porn", "porno", "pornography", "sex", "sexy", "sexual",
    "rape",
    "raping",
    "rapist",
    "omak"
        "nazi",
    "terrorist",
    "bomb",
    "kill", "murder", "die", "death", "suicide",
    "neeek", "3at", "5awal", "khawal", "metnak", "a7ba", "kosomeen",
    "Kosomin", "zobry", "kosek", "labwa", "haneekak", "hanekha", "nektha",
    "kos omak",
    "yl3an"
        "deen omak"
        "deen ahlak"
        "Zeby",
    "Zobry"
        "zeb omak"
        "yel3n deek omak"
        "yel3am"
        "kosom omak"
        "kosomin omak"
        "ya khawal",
    "ya m3aras",
    "teez"
        // Drugs
        "cocaine",
    "heroin",
    "marijuana",
    "cannabis",
    "meth",
    "crack",
    "ecstasy",

    // Weapons
    "gun", "rifle", "pistol", "weapon", "knife", "sword",

    // Scam/illegal
    "scam", "stolen", "fraud", "counterfeit", "illegal", "fake",
  ];

  static const List<String> _arabicBadWords = [
    // Only the most explicit Arabic profanity
    "كس", "كسمك", "كس امك", "كس اختك",
    "زب", "زبك", "زبي",
    "نيك", "انيك", "منيك", "متناك", "neek",
    "شرموط", "شرموطة", "قحبة", "عاهرة", "sharmoota", "sharmoot",
    "خرا", "خراء", "خرة",
    "ابن كلب", "ابن القحبة", "ابن الوسخة",
    "يا كلب", "يا حمار", "يا ابن الحرام",
    "اقلب وجهك", "تسد بوزك",
    "لعين", "حقير", "وسخ",

    // Egyptian slang and transliterations
    "عرص", "3ars",
    "أحا", "a7a", "احا",
    "كسمك", "kosomak",
    "خول", "khawal", "خوال", "5awal",
    "ديوث", "dayooth",
    "منيك", "manyak", "manyook",
    "زاني", "zany",
    "لوطي", "louty",
    "فاجر", "fager",
    "ساقط", "saqet",
    "وسخة", "wesekha",
    "قذر", "qazr",
    "نذل", "nazl",

    // Violence/threats
    "اقتل", "اموت", "اذبح", "اضرب",

    // Scam/illegal in Arabic
    "نصب", "نصاب", "احتيال", "مسروق", "حرامي", "غش",
  ];

  // SIMPLE DETECTION - No fancy rules
  static bool containsProfanity(String text) {
    if (text.trim().isEmpty) return false;

    String lowerText = text.toLowerCase().trim();

    // Check English words
    for (String badWord in _englishBadWords) {
      // Check for whole word match using word boundaries
      RegExp wordRegex =
          RegExp(r'\b' + RegExp.escape(badWord.toLowerCase()) + r'\b');
      if (wordRegex.hasMatch(lowerText)) {
        return true;
      }
    }

    // Check Arabic words (no word boundaries for Arabic)
    for (String badWord in _arabicBadWords) {
      // For Arabic and transliterated words, use space/punctuation boundaries
      RegExp arabicRegex =
          RegExp('(^|\\s|[.,!?])' + RegExp.escape(badWord) + '(\\s|[.,!?]|\$)');
      if (arabicRegex.hasMatch(lowerText)) {
        return true;
      }
    }

    return false;
  }

  static List<String> getDetectedWords(String text) {
    List<String> detected = [];
    if (text.trim().isEmpty) return detected;

    String lowerText = text.toLowerCase().trim();

    // Check English words
    for (String badWord in _englishBadWords) {
      // Check for whole word match using word boundaries
      RegExp wordRegex =
          RegExp(r'\b' + RegExp.escape(badWord.toLowerCase()) + r'\b');
      if (wordRegex.hasMatch(lowerText)) {
        detected.add(badWord);
      }
    }

    // Check Arabic words
    for (String badWord in _arabicBadWords) {
      // For Arabic and transliterated words, use space/punctuation boundaries
      RegExp arabicRegex =
          RegExp('(^|\\s|[.,!?])' + RegExp.escape(badWord) + '(\\s|[.,!?]|\$)');
      if (arabicRegex.hasMatch(lowerText)) {
        detected.add(badWord);
      }
    }

    return detected;
  }

  static String cleanText(String text) {
    if (text.trim().isEmpty) return text;

    String result = text;

    // Replace English bad words
    for (String badWord in _englishBadWords) {
      String replacement = '*' * badWord.length;
      result = result.replaceAll(
          RegExp(RegExp.escape(badWord), caseSensitive: false), replacement);
    }

    // Replace Arabic bad words
    for (String badWord in _arabicBadWords) {
      String replacement = '*' * badWord.length;
      result = result.replaceAll(badWord, replacement);
    }

    return result;
  }

  // Simple validation for forms
  static String? validateText(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName} is required';
    }

    if (containsProfanity(value.trim())) {
      return 'Please remove inappropriate language from ${fieldName}';
    }

    return null;
  }

  // Additional methods that your views are using
  static bool isAppropriateForClassifieds(String text) {
    if (text.trim().isEmpty) return true;

    // Check for profanity
    if (containsProfanity(text)) return false;

    // Check for excessive caps (more than 70% uppercase)
    if (_hasExcessiveCaps(text)) return false;

    // Check for excessive repeated characters
    if (_hasExcessiveRepeatedChars(text)) return false;

    return true;
  }

  static bool _hasExcessiveCaps(String text) {
    if (text.length < 10) return false;

    int capsCount = 0;
    for (int i = 0; i < text.length; i++) {
      if (text[i].toUpperCase() == text[i] &&
          text[i].toLowerCase() != text[i]) {
        capsCount++;
      }
    }

    return (capsCount / text.length) > 0.7;
  }

  static bool _hasExcessiveRepeatedChars(String text) {
    // Check for 4+ repeated characters in a row
    RegExp repeatedChars = RegExp(r'(.)\1{3,}');
    return repeatedChars.hasMatch(text);
  }

  static void showSpamWarning(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info, color: Colors.orange, size: 24),
            SizedBox(width: 8),
            Text('Content Warning'),
          ],
        ),
        content: Text(
          'Your text appears to be spam (excessive capitals or repeated characters). Please write normally to improve listing quality.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // Professional popup for profanity error
  static void showProfanityError(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 360,
            minWidth: 280,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).dialogBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFFF6B6B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.warning_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                    SizedBox(height: 12),
                    Text(
                      StringHelper.contentNotAllowed,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Content
              Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      StringHelper.inappropriateLanguageMessage,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 24),

                    // OK Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF6B6B),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          StringHelper.ok,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
