import 'package:flutter/material.dart';
import 'package:muna_global/models/models_exports.dart';
import 'package:muna_global/screen/screens/screens_exports.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.of(context).pop(
        //       MaterialPageRoute(
        //         builder: (context) => const MyHomeScreen(),
        //       ),
        //     );
        //   },
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.black,
        //   ),
        // ),
        title: const Text(
          'Category',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: demoCategories.length,
                itemBuilder: (context, index) => ExpansionCategoryTile(
                  title: demoCategories[index].title,
                  subCategories: demoCategories[index].subCategories,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final demoCategories = [
  CategoryModel(
    title: 'Health & Beauty',
    subCategories: [
      CategoryModel(
        title: 'Skin Care',
        onTap: () {},
      ),
      CategoryModel(
        title: 'Hair & Scalp ',
        onTap: () {},
      ),
      CategoryModel(
        title: 'Nail & Cuticle',
        onTap: () {},
      ),
      CategoryModel(
        title: 'Oral Hygiene',
        onTap: () {},
      ),
    ],
  ),
  CategoryModel(
    title: 'Grocery',
    subCategories: [
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
    ],
  ),
  CategoryModel(
    title: 'Computers',
    subCategories: [
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
    ],
  ),
  CategoryModel(
    title: 'Electronics',
    subCategories: [
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
    ],
  ),
  CategoryModel(
    title: 'Phones & tablets',
    subCategories: [
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
    ],
  ),
  CategoryModel(
    title: 'Fashion',
    subCategories: [
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
    ],
  ),
  CategoryModel(
    title: 'Automobile',
    subCategories: [
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
    ],
  ),
  CategoryModel(
    title: 'Sporting Goods',
    subCategories: [
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
    ],
  ),
  CategoryModel(
    title: 'Home & Garden',
    subCategories: [
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
      CategoryModel(
        title: 'all clothing',
        onTap: () {},
      ),
    ],
  ),
];

class ExpansionCategoryTile extends StatelessWidget {
  final String title;
  final List<CategoryModel>? subCategories;
  const ExpansionCategoryTile(
      {super.key, required this.title, required this.subCategories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5.0,
        child: ExpansionTile(
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: List.generate(
            subCategories!.length,
            (index) => Column(
              children: [
                ListTile(
                  title: Text(
                    subCategories![index].title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {},
                ),
                const Divider(height: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
