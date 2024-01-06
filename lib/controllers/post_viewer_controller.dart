import 'package:get/get.dart';
import 'package:lost_flutter/models.dart';

import '../utils/server_utils.dart';

class PostViewerController extends GetxController{

  /// Observables
  var profilePic = ''.obs;

  /// Declarations
  final serverUtils = ServerUtils();

  /// Fetches profile pic from server
  Future<void> getProfilePic(rollNo) async {
    final UserDetails userDetails = await serverUtils.getUserDetails(rollNo);
    profilePic.value = userDetails.profilePic;
    update();
  }

}