import 'dart:io'; // Import for Socket

import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/base/helpers/dialog_helper.dart'; // Import DialogHelper
import 'package:list_and_life/base/helpers/string_helper.dart';
import '../../res/assets_res.dart';
import 'api_request.dart';

class NoInternetPage extends StatefulWidget {
  const NoInternetPage(
      {super.key, required this.callBack, required this.apiRequest});
  final ApiRequest apiRequest;
  final Function(ApiRequest apiRequest) callBack;

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage> {
  // State to handle the loading indicator on the button
  bool _isChecking = false;

  // The robust refresh function
  Future<void> _handleRefresh() async {
    // Prevent multiple taps while checking
    if (_isChecking) return;

    setState(() {
      _isChecking = true;
    });

    try {
      // Use a direct socket connection to reliably check for internet
      final socket = await Socket.connect('8.8.8.8', 53,
          timeout: const Duration(seconds: 5));
      socket.destroy();

      // If the connection succeeds, pop the page and retry the API call
      if (mounted) {
        Navigator.pop(context);
        widget.callBack(widget.apiRequest);
      }
    } on SocketException catch (_) {
      // If the connection fails, show a toast instead of a SnackBar
      if (mounted) {
        DialogHelper.showToast(message: StringHelper.noInternetFound);
      }
    } finally {
      // Always reset the loading state
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AssetsRes.IC_NO_WIFI),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Oops!",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                StringHelper.noInternetFound,
                style: const TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: _handleRefresh,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: _isChecking
                      // Show a loading indicator while checking
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      // Show the text otherwise
                      : Text(
                          StringHelper.refreshText,
                          style: context.titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
