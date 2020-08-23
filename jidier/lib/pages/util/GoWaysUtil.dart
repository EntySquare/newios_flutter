/*出行方式偏好设置*/

import 'package:myflutter/pages/util/SharedPreferencesUtil.dart';

class GoWaysUtil {
  /* 保存出行方式  0  表示驾车 1,表示公交,2,表示步行 */
  static saveGoWay(int ways) async {
    await SharedPreferencesUtil.saveInt("ways", ways);
  }

  static Future<int> getGoWay() async {
    int way = await SharedPreferencesUtil.getInt("ways");

    return way;
  }
}
