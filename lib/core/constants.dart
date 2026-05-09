
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType {
  basic,
  success,
  error,
  warning,
}

class Constants {
  static var userDetails = "UserDetails";
  static var userExperience = "UserExperience";
  static var userSkillSet = "UserSkillSet";

  static showToast({required String message, ToastType? type}) {
    if(type == null || type == ToastType.basic) {
      Fluttertoast.showToast(msg: message);
    } else if(type == ToastType.success) {
      Fluttertoast.showToast(msg: message);
    }
    else if(type == ToastType.error) {
      Fluttertoast.showToast(msg: message);
    }
    else if(type == ToastType.warning) {
      Fluttertoast.showToast(msg: message);
    }
  }

}