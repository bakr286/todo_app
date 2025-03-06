import 'package:flutter/material.dart';

class Category {
  final String label;
  final Color color;

  const Category({
    required this.label,
    required this.color,
  });
}

class Categories {
  static final List<Category> categories = [
    Category(
      label: 'Personal',
      color: Colors.blue,
    ),
    Category(
      label: 'Work',
      color: Colors.red,
    ),
    Category(
      label: 'Academic',
      color: Colors.green,
    ),
  ];
}