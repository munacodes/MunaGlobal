import 'package:flutter/material.dart';

class CategoryModel {
  final String title;
  final List<CategoryModel>? subCategories;
  final Function? onTap;
  const CategoryModel({
    required this.title,
    this.subCategories,
    this.onTap,
  });
}
