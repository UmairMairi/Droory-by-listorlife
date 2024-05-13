import 'package:flutter/material.dart';

abstract class BaseViewModel extends ChangeNotifier {
  // Add common properties or methods that you want in all ViewModels

  late BuildContext _context;

  BuildContext get context => _context;

  setContext(BuildContext mContext) {
    _context = mContext;
  }

  // Function to be called during initialization
  void onInit() {
    // You can implement specific initialization logic here
  }

// Function to be called after initialization
  void onReady() {
    // You can implement specific initialization logic here
  }

  // Function to be called on dispose
  void onClose() {
    // You can implement specific initialization logic here
  }
}
