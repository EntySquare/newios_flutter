import 'package:myflutter/main.dart';

class ContactsUtil {
  static List contacts;
  static Map<String, String> map=Map();

  static getContacts() async {
    contacts  = await MyApp.platform.invokeMethod("getContacts");
    for (Map itemMap in contacts) {
      String phoneNumber = itemMap['phoneNumber'];
           phoneNumber=phoneNumber.trim();
      phoneNumber = phoneNumber.replaceAll(" ","");
      if (phoneNumber.length > 11) {
        phoneNumber =
            phoneNumber.substring(phoneNumber.length - 11, phoneNumber.length);
      }
      map[phoneNumber] = itemMap['name'];
    }
  }

  static String getNameFromPhoneNamber(String phoneNmber) {
    if (map == null) {
      return "未知";
    } else {
      String name = map[phoneNmber];

      return name == null ? "未知" : name;
    }
  }
}
