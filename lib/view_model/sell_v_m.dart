import 'package:go_router/go_router.dart';
import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/res/assets_res.dart';
import 'package:list_and_life/routes/app_routes.dart';

class SellVM extends BaseViewModel {
  List<Item> data = [
    Item(
      title: "Cars",
      image: AssetsRes.IC_CAR_CAT_IMAGE,
    ),
    Item(title: "Mobiles", image: AssetsRes.IC_MOBILE_CAT_IMGE),
    Item(title: "Furniture", image: AssetsRes.IC_FURNITURE_CAT_IMGE),
    Item(title: "Clothes", image: AssetsRes.IC_CLOTHES_CAT_IMGE),
    Item(title: "Laptops", image: AssetsRes.IC_LAPTOP_CAT_IMGE),
  ];

  void handelSellCat({required int index}) async {
    switch (index) {
      case 0:
        context.push(Routes.chooseLocationView);
        break;
      case 1:
        context.push(Routes.mobileSubcategoryView);
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
    }
  }
}

class Item {
  String title = "";
  String image = "";

  Item({
    required this.title,
    required this.image,
  });
}
