import 'package:flutter/material.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/image_view.dart';

class BlockedUsersList extends StatelessWidget {
  const BlockedUsersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Blocked'),
          centerTitle: true,
        ),
        body: ListView.builder(
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
