import 'package:avatar_flow/core/utils/toast_utils.dart';

class ErrorDialog {
  static void show({String? title, required String message}) {
    ToastUtils.error(message);
  }
}
