import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lost_flutter/controllers/cab_sharing_controller.dart';
import 'package:lost_flutter/controllers/image_picker_controller.dart';
import 'package:lost_flutter/controllers/post_list_controller.dart';
import 'package:lost_flutter/controllers/post_tag_controller.dart';
import 'package:lost_flutter/globals.dart';
import 'package:lost_flutter/pages/home.dart';
import 'package:lost_flutter/utils/server_utils.dart';
import 'package:get/get.dart';
import 'package:lost_flutter/widgets/cab_sharing_container.dart';
import 'package:rive/rive.dart';

import '../widgets/post_tag.dart';
import '../widgets/time_tag.dart';
import '../widgets/title_text.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  XFile? image;

  final ImagePicker picker = ImagePicker();
  final serverUtils = ServerUtils();
  final subject = TextEditingController();
  final content = TextEditingController();
  final dataKey = new GlobalKey();
  final PostTagController postTagController = Get.put(PostTagController());
  final cabSharingFrom = TextEditingController();
  final cabSharingTo = TextEditingController();
  final CabSharingController cabSharingController =
      Get.put(CabSharingController());
  final ImagePickerController imagePickerController =
      Get.put(ImagePickerController());

  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {}

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool didPop) async {
        cabSharingController.fromLocation.value = 'From';
        cabSharingController.toLocation.value = 'To';
        postTagController.isCabSharing.value = false;
        postTagController.resetTags();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          flexibleSpace: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          elevation: 1,
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6784313725490196),
          title: TitleText(
            pageTitle: 'Create new post',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Obx(() {
                    return Column(
                      children: [
                        Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Subject:",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(68, 68, 68, 1.0)),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: subject,
                          maxLines: 1,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.deepOrangeAccent,
                                width: 1.5,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            focusColor: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                            key: dataKey,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Body:",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromRGBO(68, 68, 68, 1.0)),
                            )),
                        SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          onTap: () {
                            Scrollable.ensureVisible(dataKey.currentContext!);
                          },
                          controller: content,
                          maxLines: 4,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.deepOrangeAccent,
                                width: 1.5,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            focusColor: Colors.black,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black.withOpacity(0.1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Add a tag'),
                                    Expanded(
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: PostTag(
                                              tagName: 'Create new tag')),
                                    )
                                  ],
                                ),
                                Divider(
                                  height: 10,
                                  thickness: 1,
                                ),
                                Obx(() {
                                  return SingleChildScrollView(
                                    child: Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      children: postTagController.allTags
                                          .map((tag) => PostTag(tagName: tag))
                                          .toList(),
                                    ),
                                  );
                                })
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        postTagController.isCabSharing.value
                            ? CabSharingContainer(
                                cabDate: '',
                                cabFrom: '',
                                cabTo: '',
                                isCreatePost: true)
                            : SizedBox(),
                      ],
                    );
                  }),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    onTap: () {
                      imagePickerController.getImage(ImageSource.gallery);
                      // getImage(ImageSource.gallery);
                    },
                    child: Container(
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(255, 114, 33, 0.5),
                        // border: Border.all(
                        //     color: Colors.black,
                        //     width: 1
                        // )
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Attachment:",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                        color: Color.fromRGBO(68, 68, 68, 1.0)),
                                  ),
                                  Text(
                                    "Click here to attach image",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color.fromRGBO(68, 68, 68, 1.0)),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Stack(
                                  children: [
                                    GetBuilder<ImagePickerController>(
                                      builder: (_) => imagePickerController
                                                  .image ==
                                              null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://via.placeholder.com/500', // Placeholder image URL
                                                fit: BoxFit
                                                    .contain, // Ensure the image fits within the space
                                              ),
                                          )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Image.file(
                                                    File(imagePickerController
                                                        .image!
                                                        .path), // Placeholder image URL
                                                    fit: BoxFit
                                                        .contain, // Ensure the image fits within the space
                                                  )),
                                            ),
                                    ),
                                    GetBuilder<ImagePickerController>(
                                        builder: (_) =>

                                            imagePickerController.image ==
                                                    null
                                                ? SizedBox()
                                                :
                                            Positioned(
                                              right: 0.0,
                                              child: GestureDetector(
                                                onTap: () {
                                                  imagePickerController
                                                      .resetImage();
                                                  // imagePickerController.image = null;
                                                  // imagePickerController.image.value = XFile('');
                                                },
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: CircleAvatar(
                                                    radius: 10.0,
                                                    backgroundColor:
                                                        Colors.black,
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.white,
                                                      size: 15.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: CupertinoButton(
                    color: Colors.black,
                    child: Text('Post'),
                    onPressed: () async {
                      var cabDetails = {
                        'from': cabSharingController.fromLocation.value,
                        'to': cabSharingController.toLocation.value,
                        'time': cabSharingController.dateTime.value
                      };
                      final tags = postTagController.selectedTags;
                      if(imagePickerController.image != null){
                        await serverUtils
                            .uploadImage(imagePickerController.image);
                      }

                      serverUtils.createPost(
                          roll_no_,
                          subject.text,
                          content.text,
                          post_image_link,
                          tags,
                          cabDetails,
                          context);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
