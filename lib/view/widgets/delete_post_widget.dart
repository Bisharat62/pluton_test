import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluton_test/controller/post_controller.dart';
import 'package:pluton_test/view/widgets/post_tile_widget.dart';

import '../../other_services/utils/app_colors.dart';

class DeletePostsWidget extends StatelessWidget {
  DeletePostsWidget({super.key});
  final PostController controller = Get.find<PostController>();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: controller.postsData.length + 1,
      padding: const EdgeInsets.only(top: 10),
      shrinkWrap: true,
      controller: controller.scrollController,
      itemBuilder: (BuildContext context, int index) {
        // Posts controller.postsData[index] = ;
        return index == controller.postsData.length
            ? controller.isReachedLastPost.value == true
                ? const SizedBox.shrink()
                : Center(
                    child: const CircularProgressIndicator(
                    color: AppColors.blue,
                  ).paddingAll(10))
            : GestureDetector(
                onTap: () {
                  controller.addOrRemovedMarked(index);
                  // controller.updateLongpressed(true);
                },
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Obx(() {
                          return Icon(
                              controller.markedListIndexes.contains(index)
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank);
                        })),
                    Expanded(
                      child: PostTileWidget(
                        postValues: controller.postsData[index],
                        index: index,
                        isfromHome: true,
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
