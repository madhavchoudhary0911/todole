import 'package:get/get.dart';
import 'package:todole/data/taskdb.dart';
import 'package:todole/db/helper.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  Future<int> addTask({Task? task}) async {
    return await Helper.insert(task);
  }
}
