import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/widgets/favorite_button.dart';

import '../../models/setting_item_model.dart';
import '../../routes/app_routes.dart';

class SeeProfileView extends StatelessWidget {
  const SeeProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("See Profile"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
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
                            ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  "https://img.freepik.com/free-psd/silver-sedan-car_53876-84522.jpg?w=740&t=st=1716212531~exp=1716213131~hmac=4b00f0679340aa976396da9aa7199a5d976904dbc084a3a227c3096c8732bd33",
                                  height: 100,
                                  width: 120,
                                  fit: BoxFit.cover,
                                )),
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
                                    style: TextStyle(
                                        color: Color(0xff7E8392), fontSize: 12),
                                  ),
                                  const Text(
                                    "2022 - 17000 KM",
                                    style: TextStyle(
                                        color: Color(0xff7E8392), fontSize: 12),
                                  ),
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "New York City",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
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
