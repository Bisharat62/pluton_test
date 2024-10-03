import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluton_test/controller/favourite_controller.dart';
import 'package:pluton_test/other_services/utils/app_colors.dart';
import 'package:pluton_test/view/widgets/post_tile_widget.dart';

class SavedPostsScreen extends StatefulWidget {
  const SavedPostsScreen({super.key});

  @override
  State<SavedPostsScreen> createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        title: const Text(
          "Favourites",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: GetBuilder<FavouriteController>(builder: (controller) {
          return controller.favPosts.isEmpty
              ? const Center(child: Text("No Post Available"))
              : ListView.builder(
                  itemCount: controller.favPosts.length,
                  padding: const EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return PostTileWidget(
                        postValues: controller.favPosts[index], index: index);
                  },
                );
        }),
      ),
    );
  }
}
