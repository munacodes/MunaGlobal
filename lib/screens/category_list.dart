import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/format_time/format_time.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class CategoryList extends StatefulWidget {
  final String name;
  final String image;
  const CategoryList({super.key, required this.name, required this.image});

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
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
                    image: post[widget.image],
                    name: post[widget.name],
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
        ),
      ),
    );
  }
}
