import 'package:flutter/material.dart';
import 'package:list_and_life/base/base.dart';

import '../../res/assets_res.dart';
import 'api_request.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage(
      {super.key, required this.callBack, required this.apiRequest});
  final ApiRequest apiRequest;
  final Function(ApiRequest apiRequest) callBack;

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
              const Text(
                'No internet connection found.Please check your connection or try again.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    await callBack(apiRequest);
                  },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: context.theme.primaryColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    'Refresh',
                    style: context.titleMedium?.copyWith(color: Colors.white),
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
