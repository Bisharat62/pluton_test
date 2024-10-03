import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluton_test/controller/auth_controller.dart';
import 'package:pluton_test/controller/favourite_controller.dart';
import 'package:pluton_test/controller/post_controller.dart';
import 'package:pluton_test/other_services/global_widgets/spacer_widget.dart';
import 'package:pluton_test/other_services/utils/app_colors.dart';
import 'package:pluton_test/view/screens/post_screens/add_new_post.dart';
import 'package:pluton_test/view/screens/post_screens/saved_posts.dart';
import 'package:pluton_test/view/widgets/delete_post_widget.dart';
import 'package:pluton_test/view/widgets/post_tile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthController authController = Get.find<AuthController>();
  final PostController postController = Get.put(PostController());
  final FavouriteController favController = Get.put(FavouriteController());
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            )),
        title: const Text(
          "Home Screen",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const SavedPostsScreen());
              },
              icon: const Icon(
                Icons.favorite,
                size: 20,
              )),
          IconButton(
              onPressed: () {
                authController.signOutFromGoogle();
              },
              icon: const Icon(
                Icons.logout,
                size: 20,
              )),
        ],
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: GetBuilder<PostController>(
            // stream: null,
            builder: (controller) {
          return controller.isErrorOccured.value == true
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("SomeThing Went Wrong "),
                    vertical(0.02),
                    TextButton(
                        onPressed: () {
                          controller.fetchData();
                        },
                        child: const Text("Tap to Refresh"))
                  ],
                )
              : controller.isLoading.value == true &&
                      controller.postsData.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: AppColors.blue,
                    ))
                  : Column(children: [
                      controller.isLongPressed == true
                          ? Row(
                              children: [
                                Obx(() {
                                  return controller.markedListIndexes.isEmpty
                                      ? TextButton(
                                          onPressed: () {
                                            controller.deleteallPOsts();
                                          },
                                          child: const Text(
                                            "Delete All",
                                            style: TextStyle(color: Colors.red),
                                          ))
                                      : TextButton(
                                          onPressed: () {
                                            controller.removeSelectedIndexes();
                                          },
                                          child: const Text(
                                            "Delete Selected",
                                            style: TextStyle(color: Colors.red),
                                          ));
                                }),
                                const Spacer(),
                                TextButton(
                                    onPressed: () {
                                      controller.updateLongpressed(false);
                                    },
                                    child: const Text("Cancel")),
                              ],
                            ).paddingSymmetric(horizontal: 5, vertical: 8)
                          : const SizedBox.shrink(),
                      Expanded(
                          child: controller.isLoading.value == false &&
                                  controller.postsData.isEmpty
                              ? const Center(child: Text("No Post Available"))
                              : controller.isLongPressed == true
                                  ? DeletePostsWidget()
                                  : ListView.builder(
                                      itemCount:
                                          controller.postsData.length + 1,
                                      padding: const EdgeInsets.only(top: 10),
                                      shrinkWrap: true,
                                      controller: controller.scrollController
                                        ..addListener(
                                            controller.onScrollListener),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        // Posts controller.postsData[index] = ;
                                        return index ==
                                                controller.postsData.length
                                            ? controller.isReachedLastPost
                                                        .value ==
                                                    true
                                                ? const SizedBox.shrink()
                                                : Center(
                                                    child:
                                                        const CircularProgressIndicator(
                                                    color: AppColors.blue,
                                                  ).paddingAll(10))
                                            : GestureDetector(
                                                onLongPressStart: (details) {
                                                  controller
                                                      .updateLongpressed(true);
                                                },
                                                child: PostTileWidget(
                                                  postValues: controller
                                                      .postsData[index],
                                                  index: index,
                                                  isfromHome: true,
                                                ),
                                              );
                                      },
                                    )),
                    ]);
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.blue,
        shape: const CircleBorder(),
        onPressed: () {
          Get.to(() => const AddPostScreen());
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
