import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluton_test/model/posts_model.dart';

import '../../controller/favourite_controller.dart';
import '../../other_services/global_widgets/spacer_widget.dart';
import '../../other_services/utils/alert_boxes.dart';
import '../../other_services/utils/app_colors.dart';

class PostTileWidget extends StatelessWidget {
  final Posts postValues;
  final int index;
  final bool? isfromHome;
  PostTileWidget(
      {super.key,
      required this.postValues,
      required this.index,
      this.isfromHome});

  final FavouriteController favController = Get.put(FavouriteController());

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              postValues.title.toString(),
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
            trailing: Wrap(
              children: [
                IconButton(onPressed: () {
                  favController.addOrRemoveFav(postValues);
                }, icon: Obx(() {
                  return Icon(
                    favController.favpostIds.contains(postValues.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: AppColors.red,
                  );
                })),
                isfromHome == true
                    ? IconButton(
                        onPressed: () {
                          showDeleteConfirmationDialog(index);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.red,
                        ))
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          Text(
            postValues.body.toString(),
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
          ).paddingSymmetric(horizontal: 17),
          Row(
            children: [
              const Icon(
                Icons.thumb_up_alt,
                color: Colors.green,
              ),
              horizontal(0.005),
              Text(
                postValues.reactions!.likes.toString(),
                style: const TextStyle(color: Colors.green),
              ),
              const Spacer(),
              const Icon(
                Icons.thumb_down,
                color: AppColors.red,
              ),
              horizontal(0.01),
              Text(
                postValues.reactions!.dislikes.toString(),
                style: const TextStyle(color: AppColors.red),
              )
            ],
          ).paddingSymmetric(horizontal: 17, vertical: 10)
        ],
      ),
    );
  }
}
