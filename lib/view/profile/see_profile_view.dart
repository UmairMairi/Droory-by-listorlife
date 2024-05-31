import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/app_elevated_button.dart';
import 'package:list_and_life/widgets/app_outline_button.dart';
import 'package:list_and_life/widgets/app_text_field.dart';
import 'package:list_and_life/widgets/favorite_button.dart';
import 'package:share_plus/share_plus.dart';

import '../../models/setting_item_model.dart';
import '../../routes/app_routes.dart';

class SeeProfileView extends StatefulWidget {
  const SeeProfileView({super.key});

  @override
  State<SeeProfileView> createState() => _SeeProfileViewState();
}

class _SeeProfileViewState extends State<SeeProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("See Profile"),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
              offset: const Offset(0, 40),
              icon: const Icon(Icons.more_vert),
              onSelected: (int value) {
                switch (value) {
                  case 1:

                    ///Share Profile
                    Share.share(
                        "Check this user profile in List or Lift app url: www.google.com");
                    return;
                  case 2:

                    ///Report User
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          int selectedReport = 0;
                          return SingleChildScrollView(
                            padding: EdgeInsets.only(
                              top: 10.0,
                              right: 10,
                              left: 10,
                              bottom: context.viewInsets.bottom,
                            ),
                            child:
                                StatefulBuilder(builder: (context, setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    'Report User',
                                    style: context.textTheme.titleMedium,
                                  ),
                                  RadioListTile<int?>(
                                      value: 1,
                                      title: const Text(
                                          'Inappropriate profile picture'),
                                      groupValue: selectedReport,
                                      onChanged: (int? value) {
                                        selectedReport = value ?? 0;
                                        setState(() {});
                                      }),
                                  RadioListTile<int?>(
                                      value: 2,
                                      title: const Text(
                                          'This user is threatening me'),
                                      groupValue: selectedReport,
                                      onChanged: (int? value) {
                                        selectedReport = value ?? 0;
                                        setState(() {});
                                      }),
                                  RadioListTile<int?>(
                                      value: 3,
                                      title: const Text(
                                          'This User is insulting me'),
                                      groupValue: selectedReport,
                                      onChanged: (int? value) {
                                        selectedReport = value ?? 0;
                                        setState(() {});
                                      }),
                                  RadioListTile<int?>(
                                      value: 4,
                                      title: const Text('Spam'),
                                      groupValue: selectedReport,
                                      onChanged: (int? value) {
                                        selectedReport = value ?? 0;
                                        setState(() {});
                                      }),
                                  RadioListTile<int?>(
                                      value: 5,
                                      title: const Text('Fraud'),
                                      groupValue: selectedReport,
                                      onChanged: (int? value) {
                                        selectedReport = value ?? 0;
                                        setState(() {});
                                      }),
                                  RadioListTile<int?>(
                                      value: 6,
                                      title: const Text('Other'),
                                      groupValue: selectedReport,
                                      onChanged: (int? value) {
                                        selectedReport = value ?? 0;
                                        setState(() {});
                                      }),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    child: AppTextField(
                                      animation: false,
                                      lines: 3,
                                      title: 'Comment',
                                      hint: 'Write here...',
                                    ),
                                  ),
                                  const Gap(10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: AppOutlineButton(
                                          onTap: () {
                                            context.pop();
                                          },
                                          title: 'Cancel',
                                        )),
                                        const Gap(20),
                                        Expanded(
                                            child: AppElevatedButton(
                                          onTap: () {
                                            context.pop();
                                          },
                                          title: 'Send',
                                        ))
                                      ],
                                    ),
                                  ),
                                  const Gap(20),
                                ],
                              );
                            }),
                          );
                        });

                    return;
                  case 3:

                    ///Block User
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          int selectedReport = 0;
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child:
                                StatefulBuilder(builder: (context, setState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Text(
                                    'Block User',
                                    style: context.textTheme.titleMedium,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    child: Text(
                                        'Block John Marker? Blocked contacts will no longer be able to send you messages.'),
                                  ),
                                  const Gap(10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: AppOutlineButton(
                                          onTap: () {
                                            context.pop();
                                          },
                                          title: 'Cancel',
                                        )),
                                        const Gap(20),
                                        Expanded(
                                            child: AppElevatedButton(
                                          onTap: () {
                                            context.pop();
                                            context.pop();
                                          },
                                          height: 40,
                                          title: 'Block',
                                        ))
                                      ],
                                    ),
                                  ),
                                  const Gap(20),
                                ],
                              );
                            }),
                          );
                        });
                    return;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                    const PopupMenuItem(
                      value: 1,
                      child: Text('Share Profile'),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      child: Text('Report User'),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      child: Text('Block User'),
                    ),
                  ]),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const Row(
              children: [
                CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(AssetsRes.DUMMY_PROFILE)),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "John Marker",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 15,
                          ),
                          Gap(05),
                          Text(
                            "Member since Mar 2018",
                            style: TextStyle(
                                color: Color(0xff7E8392), fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Row(
              children: [
                Icon(
                  Icons.help_outline,
                  size: 15,
                ),
                SizedBox(width: 5),
                Text(
                  "Deals in sale and purchase of used certified cars",
                  style: TextStyle(color: Color(0xff7E8392), fontSize: 12),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            ListView.builder(
                itemCount: 3,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      context.push(
                        Routes.productDetails,
                        extra: SettingItemModel(
                            imageList: [
                              AssetsRes.DUMMY_CAR_IMAGE1,
                              AssetsRes.DUMMY_CAR_IMAGE2,
                              AssetsRes.DUMMY_CAR_IMAGE3,
                              AssetsRes.DUMMY_CAR_IMAGE4,
                            ],
                            title: 'EGP300',
                            subTitle:
                                'Maruti Suzuki Swift 1.2 VXI (O), 2015, Petrol',
                            description: '2015 - 48000 km',
                            location: 'New York City',
                            timeStamp: 'Today',
                            longDescription:
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.'),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 10, left: 5, right: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Image(
                                image: CachedNetworkImageProvider(
                                    "https://img.freepik.com/free-psd/silver-sedan-car_53876-84522.jpg?w=740&t=st=1716212531~exp=1716213131~hmac=4b00f0679340aa976396da9aa7199a5d976904dbc084a3a227c3096c8732bd33",
                                    scale: 7)),
                            /*  ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  "https://img.freepik.com/free-psd/silver-sedan-car_53876-84522.jpg?w=740&t=st=1716212531~exp=1716213131~hmac=4b00f0679340aa976396da9aa7199a5d976904dbc084a3a227c3096c8732bd33",
                                  height: 100,
                                  width: 120,
                                  fit: BoxFit.cover,
                                )),*/
                            const SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "EGP300",
                                        style: TextStyle(
                                            color: Color(0xffFF385C),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      FavoriteButton(onTap: () {})
                                    ],
                                  ),
                                  const Text(
                                    "Hyundai i20 N Line 1.0 N8 Tu...",
                                  ),
                                  const Text(
                                    "2022 - 17000 KM",
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            AssetsRes.IC_LOACTION_ICON,
                                            height: 14,
                                            width: 14,
                                          ),
                                          const Gap(8),
                                          const Text(
                                            "New York City",
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const Text(
                                        "Today",
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
