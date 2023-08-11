import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muna_global/format_time/format_time.dart';
import 'package:muna_global/screen/category/catergory.dart';
import 'package:muna_global/screen/message_and_chat/message_export.dart';
import 'package:muna_global/screen/screens/details_page.dart';
import 'package:muna_global/widgets/widgets_exports.dart';

class MyHomeScreen extends StatefulWidget {
  const MyHomeScreen({super.key});

  @override
  State<MyHomeScreen> createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  _buildTrendingImageSlider() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      height: 150,
      // height: 240,
      child: Carousel(
        boxFit: BoxFit.fill,
        autoplay: true,
        showIndicator: false,
        borderRadius: true,
        radius: const Radius.circular(25),
        images: const [
          AssetImage('assets/images/Shirt 1.jpg'),
          AssetImage('assets/images/Hood.png'),
          AssetImage('assets/images/Man Watch 2.jpg'),
          AssetImage('assets/images/Shoe 1.jpg'),
          AssetImage('assets/images/Suits.jpg'),
        ],
      ),
    );
  }

  hotDealsItems({required String image}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(image),
        ),
      ),
    );
  }

  Widget _buildHotDealsImageSlider() {
    return Container(
      height: 120,
      width: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 120,
          aspectRatio: 6.5,
          autoPlay: true,
          pauseAutoPlayOnTouch: true,
          scrollDirection: Axis.horizontal,
        ),
        items: [
          hotDealsItems(image: 'assets/images/Shoe 4.jpg'),
          hotDealsItems(image: 'assets/images/image 18.png'),
          hotDealsItems(image: 'assets/images/Suits.jpg'),
          hotDealsItems(image: 'assets/images/Hood.png'),
          hotDealsItems(image: 'assets/images/image 20.png'),
        ],
      ),
    );
  }

  Widget _buildNewArrivalsImageSlider() {
    return Container(
      height: 380,
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Products')
            .orderBy('Timestamp', descending: true)
            .limit(4)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final post = snapshot.data!.docs[index];
                return GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                              image:
                                  CachedNetworkImageProvider(post['ImageUrl']),
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              post['Name of Product'],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                post['Description'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              '₦ ${post['Price'].toDouble()}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'No Product yet',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: const [
                  Text(
                    'Something went wrong',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'Pleast try again later',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
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
    );
  }

  Widget _buildCategorySection({required String text, required IconData icon}) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.black,
          size: 40,
        ),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  otherDealsItems({required String image}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(image),
        ),
      ),
    );
  }

  Widget _buildOtherDealsImageSlider() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
      ),
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 6.5,
          autoPlay: true,
          pauseAutoPlayOnTouch: true,
          scrollDirection: Axis.vertical,
        ),
        items: [
          otherDealsItems(
            image: 'assets/images/image 3.png',
          ),
          otherDealsItems(
            image: 'assets/images/image 10.png',
          ),
          otherDealsItems(
            image: 'assets/images/image 15.png',
          ),
          otherDealsItems(
            image: 'assets/images/image 18.png',
          ),
          otherDealsItems(
            image: 'assets/images/image 20.png',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          'Muna Global',
          style: TextStyle(color: Colors.blue, fontSize: 30),
        ),
        actions: [
          Container(
            width: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const MessagesPage(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.question_answer_outlined,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const NotificationFeed(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHotDealsImageSlider(),
                      _buildOtherDealsImageSlider(),
                    ],
                  ),
                  Card(
                    elevation: 3,
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Category',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const CategoryPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'View All',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildCategorySection(
                                  text: 'Fashion',
                                  icon: Icons.class_outlined,
                                ),
                                _buildCategorySection(
                                  text: 'Computer',
                                  icon: Icons.computer_outlined,
                                ),
                                _buildCategorySection(
                                  text: 'Phones',
                                  icon: Icons.phone_android_outlined,
                                ),
                                _buildCategorySection(
                                  text: 'Funitures',
                                  icon: Icons.chair_outlined,
                                ),
                                _buildCategorySection(
                                  text: 'Motors',
                                  icon: Icons.directions_car_outlined,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Trending',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTrendingImageSlider(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'New Arrivals',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'View All',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildNewArrivalsImageSlider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
