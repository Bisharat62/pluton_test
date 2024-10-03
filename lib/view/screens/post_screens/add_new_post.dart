import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluton_test/controller/post_controller.dart';
import 'package:pluton_test/model/add_post_model.dart';
import 'package:pluton_test/other_services/global_widgets/custom_button.dart';
import 'package:pluton_test/other_services/global_widgets/spacer_widget.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final PostController _postController = Get.find<PostController>();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add New Post",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              vertical(0.02),
              TextFormField(
                controller: _postController.titleController,
                maxLength: 100,
                validator: (value) =>
                    value!.isEmpty ? "Please Enter Title" : null,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: const InputDecoration(
                    label: Text(
                      "Title",
                      style: TextStyle(color: Colors.black),
                    ),
                    hintText: "Title",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w400, color: Colors.black),
                    focusColor: Colors.black,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    )),
              ),
              vertical(0.02),
              TextFormField(
                controller: _postController.bodyController,
                maxLines: 5,
                textAlign: TextAlign.start,
                validator: (value) =>
                    value!.isEmpty ? "Please Enter Body" : null,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: const InputDecoration(
                    label: Text(
                      "Body",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    focusColor: Colors.black,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    )),
              ),
              vertical(0.03),
              CustomButton(
                  ontap: () {
                    if (_formKey.currentState!.validate()) {
                      _postController.addPost(AddPostModel(
                          title: _postController.titleController.text,
                          body: _postController.titleController.text,
                          userid: 25,
                          likes: 0,
                          dislikes: 0));
                    }
                  },
                  width: 1.0,
                  text: "Add Post")
            ],
          ),
        ),
      ),
    );
  }
}
