import 'package:get/get.dart';
import 'package:app_name/model/user_model.dart';

class UserController extends GetxController {
  // Observable for the current user
  var currentUser = UserModel().obs;

  void updateUser(UserModel user) {
    currentUser.value = user;
  }

  void clearUser() {
    currentUser.value = UserModel();
  }
}
