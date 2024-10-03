import 'package:pluton_test/model/posts_model.dart';

class AddPostModel {
  final int? id;
  final String title;
  final String body;
  final int userid;
  final int likes;
  final int dislikes;

  AddPostModel(
      {this.id,
      required this.title,
      required this.body,
      required this.userid,
      required this.likes,
      required this.dislikes});

  Map<String, dynamic> toJson() {
    return {
      'id': id ?? 0,
      'title': title,
      'body': body,
      'userId': userid,
      'likes': likes,
      'dislikes': dislikes,
    };
  }

  factory AddPostModel.fromJson(Map<String, dynamic> json) {
    return AddPostModel(
      id: json['id'] as int?,
      title: json['title'] as String,
      body: json['body'] as String,
      userid: json['userId'],
      likes: json['likes'] as int,
      dislikes: json['dislikes'] as int,
    );
  }

  static List<Posts> convertToPostsList(List<AddPostModel> addPostModels) {
    List<Posts> posts = [];
    for (AddPostModel addPostModel in addPostModels) {
      posts.add(Posts(
        id: addPostModel.id,
        title: addPostModel.title,
        body: addPostModel.body,
        tags: [], // Assuming no tags data in AddPostModel (modify if needed)
        reactions: Reactions(
            likes: addPostModel.likes, dislikes: addPostModel.dislikes),
        views: 0, // Assuming initial views are 0 (adjust if applicable)
        userId: addPostModel.id,
      ));
    }
    return posts;
  }

  static List<int> getPostIds(List<AddPostModel> addPostModels) {
    return addPostModels.map((post) => post.id!).toList();
  }
}
