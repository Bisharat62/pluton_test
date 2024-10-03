import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluton_test/controller/favourite_controller.dart';
import 'package:pluton_test/model/add_post_model.dart';
import 'package:pluton_test/model/posts_model.dart';
import 'package:pluton_test/other_services/utils/alert_boxes.dart';
import 'package:pluton_test/other_services/utils/snackbar.dart';

import '../other_services/services/api_services.dart';

class PostController extends GetxController {
  PostsData? postModelData;
  List<Posts> _postData = [];
  final List<Posts> postDataApi = [];
  RxBool isLoading = true.obs;
  RxBool isErrorOccured = false.obs;
  RxBool isReachedLastPost = false.obs;
  List<Posts> get postsData => _postData;
  int _skip = 0;
  final int _limit = 10;
  final RxDouble _lastMaxScrollExtent =
      0.0.obs; //variable created for maxExtent of list view
  final ScrollController scrollController = ScrollController();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchData();
  }

  onScrollListener() {
    Future.delayed(const Duration(seconds: 3), () {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        if (scrollController.position.maxScrollExtent !=
            _lastMaxScrollExtent.value) {
          _lastMaxScrollExtent.value =
              scrollController.position.maxScrollExtent;
          fetchData();
        }
      }
    });
  }

// fetch posts data---------------------------------------------------------------------------------------
  void fetchData({bool? startFromZero}) async {
    try {
      isLoading.value = true;
      isErrorOccured.value = false;
      if (startFromZero == true) {
        _skip = 0;
        update();
      }
      final response = await APIService.instance.request(
        '?limit=$_limit&skip=$_skip', // enter the endpoint for required API call
        DioMethod.get,
      );
      if (response.statusCode == 200) {
        // Success: Process the response data
        print('API call successful: ${response.data}');
        postModelData = PostsData.fromJson(response.data);
        // log("$post");
        postDataApi.addAll(postModelData!.posts!);
        _postData.addAll(postModelData!.posts!);
        if (postModelData!.posts!.isEmpty) {
          isReachedLastPost.value = true;
          showInSnackBar("No More Posts To Load");
        } else {
          isReachedLastPost.value = false;
          _skip += 10;
        }
        isLoading.value = false;
        update();
      } else {
        isLoading.value = false;
        isErrorOccured.value = true;
        // Error: Handle the error response
        print('API call failed: ${response.statusMessage}');
      }
    } catch (e) {
      isLoading.value = false;
      isErrorOccured.value = true;
      // Handle errors
      print('Error fetching data: $e');
      // return Future.error(e);
    }
  }

// add  posts data---------------------------------------------------------------------------------------
  void addPost(
    AddPostModel addpost,
  ) async {
    showLoader();
    try {
      // Example of calling the request method with parameters
      final response = await APIService.instance.request(
        '/add', // enter the endpoint for required API call
        DioMethod.post,
        param: addpost.toJson(),
        contentType: 'application/json',
      );
// Handle the response
      if (response.statusCode == 201) {
        titleController.clear();
        bodyController.clear();
        hideLoader();
        showInSnackBar("Post Added Successfully");
        //all these conditions are used to not repeat post id when we are adding new post
        // this is occured because posts/add api dosent realy add new post to database online,
        // so i have created localy temporary list which will perform functionality for user View
        _postData = [
          Posts(
              id: postModelData == null
                  ? response.data["id"]
                  : Get.find<FavouriteController>().favpostIds.last >
                          postModelData!.total!
                      ? Get.find<FavouriteController>().favpostIds.last
                      : postModelData!.total! + 1 == response.data["id"] &&
                              postModelData!.total! < _postData.first.id!
                          ? _postData.first.id! + 1
                          : response.data["id"],
              body: addpost.body,
              title: addpost.title,
              userId: addpost.userid,
              reactions: Reactions(dislikes: 0, likes: 0)),
          ..._postData
        ];
        update();
        // Success: Process the response data
        log('API call successful: ${response.data}');
      } else {
        log('API call failed: ${response.statusCode}');
        hideLoader();
        showInSnackBar("Some Thing Wrong ", color: Colors.red);
        // Error: Handle the error response
      }
    } catch (e) {
      hideLoader();
      showInSnackBar("Some Thing Wrong TryAgain", color: Colors.red);
      // Error: Handle network errors
      print('Network error occurred: $e');
    }
  }

// delete  posts data---------------------------------------------------------------------------------------
  void deletePost(
    int postId,
    int index,
  ) async {
    final FavouriteController favouriteController =
        Get.find<FavouriteController>();
    showLoader();
    try {
      // Example of calling the request method with parameters
      final response = await APIService.instance.request(
        '/$postId', // enter the endpoint for required API call
        DioMethod.delete,
        // param: addpost.toJson(),
        contentType: 'application/json',
      );
// Handle the response
      if (response.statusCode == 200) {
        if (favouriteController.favpostIds.contains(postId)) {
          await favouriteController.addOrRemoveFav(_postData[index],
              hideSnack: true);
          log("inside--------- fav post delete");
        }
        _postData.removeAt(index);
        update();
        hideLoader();
        showInSnackBar("Post deleted Successfully", color: Colors.red);

        // Success: Process the response data
        log('API call successful: ${response.data}');
      } else {
        log('API call failed: ${response.statusCode}');
        hideLoader();
        showInSnackBar("Some Thing Wrong ", color: Colors.red);

        // Error: Handle the error response
      }
    } catch (e) {
      if (index < _postData.length) {
        if (favouriteController.favpostIds.contains(postId)) {
          await favouriteController.addOrRemoveFav(_postData[index],
              hideSnack: true);
          log("inside--------- fav post delete");
        }
        _postData
            .removeAt(index); //this condition is for temperoray stored data ,
        //when we add post is dosent refelct to api databse thats why iam storing it for temporary

        hideLoader();
        showInSnackBar("Post deleted Successfully", color: Colors.red);
        update();
      } else {
        hideLoader();
        showInSnackBar("Some Thing Wrong TryAgain", color: Colors.red);
        // Error: Handle network errors
        print('Network error occurred: $e');
      }
    }
  }

  //-----------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------
  //-----------------------------------------------------------------------------------------------------------
  // functions for deleting multiple posts
  // basically dummy json dose'nt provide to delete multiple posts
  // this functionality added for single instance of app life and all functionality is performed on temporary data
  // because api dosent provide functionality for this

  bool isLongPressed = false;
  RxList<int> markedListIndexes = <int>[].obs;
  RxBool yesNo = false.obs;

  updateLongpressed(bool val) {
    isLongPressed = val;
    update();
  }

  addOrRemovedMarked(int index) {
    if (markedListIndexes.contains(index)) {
      markedListIndexes.remove(index);
    } else {
      markedListIndexes.add(index);
    }
  }

  removeSelectedIndexes() async {
    bool confirm = await showConfirmationDialog("Delete Selected Posts",
        "Are You Sure Do You Wants To Delete Selected Posts?");

    log("$confirm");
    if (confirm) {
      for (int index in markedListIndexes.reversed) {
        _postData.removeAt(index);
      }
      markedListIndexes.value = [];
      if (_postData.length < 5) {
        fetchData();
      }
      update();
      Get.back();
      showInSnackBar("Selected Posts Are Deleted", color: Colors.red);
    }
  }

  deleteallPOsts() async {
    bool confirm = await showConfirmationDialog(
        "Delete All Posts", "Are You Sure Do You Wants To Delete All Posts?");
    if (confirm) {
      _postData = [];
      update();
      Get.back();
      showInSnackBar("All Posts Are Deleted", color: Colors.red);
    }
  }
}
