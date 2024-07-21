import 'package:list_and_life/base/base.dart';
import 'package:list_and_life/view_model/chat_vm.dart';
import 'package:persistent_bottom_nav_bar_plus/persistent_bottom_nav_bar_plus.dart';
import 'package:provider/provider.dart';

import '../helpers/db_helper.dart';
import '../sockets/socket_helper.dart';

class MainVM extends BaseViewModel {
  final PersistentTabController navController =
      PersistentTabController(initialIndex: 0);

  @override
  void onInit() {
    // TODO: implement onInit
    if (!DbHelper.getIsGuest()) {
      SocketHelper().connectUser();
    }
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    if (!DbHelper.getIsGuest()) {
      var model = context.read<ChatVM>();
      model.initListeners();
    }
    super.onReady();
  }
}
