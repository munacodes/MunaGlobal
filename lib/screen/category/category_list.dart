import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/format_time/format_time.dart';
import 'package:muna_global/screen/category/category_exports.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class CategoryList extends StatefulWidget {
  const CategoryList({super.key});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String? image;
  String? name;

  qwert({required String name, required String image}) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('Category')
          .orderBy('Categories', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final post = snapshot.data!.docs[index];
              return CategorySingleItem(
                image: post[image],
                name: post[name],
              );
            },
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Column(
              children: const [
                Text(
                  'No user or result for this category',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Invite friends to join',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: qwert(
          name: name!,
          image: image!,
        ),
      ),
    );
  }
}
