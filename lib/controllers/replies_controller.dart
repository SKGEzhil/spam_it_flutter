import 'package:get/get.dart';

import '../globals.dart';
import '../models.dart';
import '../utils/server_utils.dart';
import 'network_connectivity_controller.dart';

class RepliesController extends GetxController {

  /// Observables
  var isOpened = false.obs;
  List<Reply> items = <Reply>[].obs;

  /// Declarations
  final serverUtils = ServerUtils();

  /// GetX Controllers
  final NetworkController networkController = Get.put(NetworkController());

  /// Fetches all replies from server
  Future<void> fetchData() async {
    if(networkController.connectionType != 0){
      List<Reply> replies = await serverUtils
          .getAllReplies(roll_no_); // Wait for the future to complete
      items = replies;
    }
    update();
  }

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }


}