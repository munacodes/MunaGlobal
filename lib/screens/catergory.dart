import 'package:flutter/material.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  showDialogBox() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: CategoryListItems().merchant(),
      ),
    );
  }

  categoryLists({required String image, required String name}) {
    return GestureDetector(
      onTap: showDialogBox,
      child: Container(
        child: Column(
          children: [
            Card(
              color: Colors.grey[400],
              elevation: 7.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Image(
                height: 150,
                width: 150,
                alignment: Alignment.center,
                image: AssetImage(image),
              ),
            ),
            Text(
              name,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text(
          'Category',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      categoryLists(
                          image: 'assets/images/Hood.png', name: 'Merchant'),
                      categoryLists(
                          image: 'assets/images/Hood.png', name: 'Automotive'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      categoryLists(
                        image: 'assets/images/Hood.png',
                        name: 'Computer & Electronics',
                      ),
                      categoryLists(
                          image: 'assets/images/Hood.png',
                          name: 'Food & Dining'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      categoryLists(
                          image: 'assets/images/Hood.png',
                          name: 'Construction & Contractors'),
                      categoryLists(
                          image: 'assets/images/Hood.png', name: 'Real Estate'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      categoryLists(
                        image: 'assets/images/Hood.png',
                        name: 'Personal Care & Services',
                      ),
                      categoryLists(
                          image: 'assets/images/Hood.png',
                          name: 'Home & Garden'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      categoryLists(
                          image: 'assets/images/Hood.png',
                          name: 'Travel & Transport'),
                      categoryLists(
                          image: 'assets/images/Hood.png', name: 'Cloth'),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
