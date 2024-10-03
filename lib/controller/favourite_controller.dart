import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pluton_test/model/add_post_model.dart';
import 'package:pluton_test/model/posts_model.dart';
import 'package:pluton_test/other_services/services/db_services.dart';

import '../other_services/utils/snackbar.dart';

class FavouriteController extends GetxController {
  List<Posts> _favPosts = [];
  List<Posts> get favPosts => _favPosts;
  RxList<int> favpostIds = <int>[].obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    runIsolate();
    // getdbPOsts();
  }

  addOrRemoveFav(Posts post, {bool? hideSnack}) {
    if (favpostIds.contains(post.id)) {
      _favPosts.removeWhere((pst) => post.id == pst.id);
      favpostIds.remove(post.id);
      removePostfromdb(post.id!);
      update();
      hideSnack == true
          ? null
          : showInSnackBar("Post  removed from Favourites", color: Colors.red);
    } else {
      _favPosts.add(post);
      addPOsttodb(post);
      favpostIds.add(post.id!);
      favpostIds.sort();
      update();
      hideSnack == true ? null : showInSnackBar("Post Added to Favourites");
    }
    log("$favpostIds");
  }

  //--------------------------------------- db Services-----------------------------
  PostsDatabase postsDatabase = PostsDatabase.instance;

  void isolateFunction(SendPort sendPort) async {
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    // Perform your long-running task here
    // ...

    // Send the result back to the main isolate

    List<AddPostModel> result = await postsDatabase.readAll();

    sendPort.send(result);
  }

  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;

  Future<void> runIsolate() async {
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(isolateFunction, receivePort.sendPort);

    List<AddPostModel> result = await receivePort.first;
    isolate.kill();
    _favPosts = AddPostModel.convertToPostsList(result);
    favpostIds.value = AddPostModel.getPostIds(result);

    favpostIds.sort();
    update();
    log("$result ------------------- $favpostIds");
    // Update UI or perform other actions with the result
  }

  addPOsttodb(Posts post) async {
    var res = postsDatabase.create(AddPostModel(
        id: post.id,
        title: post.title!,
        body: post.body!,
        userid: post.userId!,
        likes: post.reactions!.likes!,
        dislikes: post.reactions!.dislikes!));
    // log("$res ");
  }

  removePostfromdb(int id) async {
    var res = await postsDatabase.delete(id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    postsDatabase.close();
  }
}
