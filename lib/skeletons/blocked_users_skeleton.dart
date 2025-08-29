import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../res/assets_res.dart';
import '../widgets/image_view.dart';

class BlockedUsersSkeleton extends StatelessWidget {
  final bool isLoading;
  const BlockedUsersSkeleton({super.key, required this.isLoading});
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
        enabled: isLoading,
        child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: 10,
            itemBuilder: (context, snapshot) {
              return Card(
                child: ListTile(
                  leading: const ImageView.rect(
                      image: AssetsRes.DUMMY_CAR_FIRST, width: 50, height: 50),
                  title: const Text("User Name"),
                  trailing: TextButton(
                    child: const Text('Unblock'),
                    onPressed: () {},
                  ),
                ),
              );
            }));
  }
}
