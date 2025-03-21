import 'package:graduation_project/local_data/shared_preference.dart';

class AuthUtils {
  // جلب الـ userId مباشرة من AppLocalStorage كـ int
  static Future<int?> getUserIdDirectly() async {
    final userId = AppLocalStorage.getData('user_id');
    return userId as int?;
  }
}