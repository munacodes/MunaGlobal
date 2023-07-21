import 'package:flutter/material.dart';

class CategoryListItems {
  // TODO: USE NAVIGATOR . POP TO POP BACK CATEGORY

  decorationContainer({required String name}) {
    return Container(
      height: 50,
      child: Card(
        color: Colors.grey[300],
        child: Center(
          child: Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  merchant() {
    return Container(
      height: 300,
      child: ListView(
        children: [
          decorationContainer(name: 'Clothing & Accessories'),
          decorationContainer(name: 'Shoes'),
          decorationContainer(name: 'Jewelry'),
          decorationContainer(name: 'Cards & Gifts'),
          decorationContainer(name: 'Department Stores'),
          decorationContainer(name: 'Sporting Goods'),
        ],
      ),
    );
  }

  automotive() {
    return Container(
      height: 300,
      child: ListView(
        children: [
          decorationContainer(name: 'Auto Dealers'),
          decorationContainer(name: 'Motocylce Sales & Repairs'),
          decorationContainer(name: 'Detail & Carwash'),
          decorationContainer(name: 'Auto Accessories'),
          decorationContainer(name: 'Rental & leasing'),
          decorationContainer(name: 'Service, Repair & Parts'),
          decorationContainer(name: 'Towing'),
        ],
      ),
    );
  }

  computersAndElectronics() {
    return Container(
      height: 300,
      child: ListView(
        children: [
          decorationContainer(name: 'Computer Programming & Supports'),
          decorationContainer(name: 'Consumer Electronic & Accessories'),
        ],
      ),
    );
  }

  foodAndDining() {
    return Container(
      height: 300,
      child: ListView(
        children: [
          decorationContainer(name: 'Desserts, Catering & Supplies'),
          decorationContainer(name: 'Fast Food'),
          decorationContainer(name: 'Grocery & Beverages'),
          decorationContainer(name: 'Restaurants'),
        ],
      ),
    );
  }

  travelAndTransport() {
    return Container(
      height: 300,
      child: ListView(
        children: [
          decorationContainer(name: 'Travel & Tourism'),
          decorationContainer(name: 'Transportation'),
          decorationContainer(name: 'Hotel & Motel'),
          decorationContainer(name: 'Packaging & Shipping'),
          decorationContainer(name: 'Moving & Storage'),
          decorationContainer(name: 'Sporting Goods'),
        ],
      ),
    );
  }

  realEstate() {
    return Container(
      height: 300,
      child: ListView(
        children: [
          decorationContainer(name: 'Agencies & Brokerage'),
          decorationContainer(name: 'Property Management'),
          decorationContainer(name: 'Apartment & Home Rental'),
          decorationContainer(name: 'Agents & Brokers'),
          decorationContainer(name: 'Mortage Brokers & Lender'),
          decorationContainer(name: 'Title Company'),
        ],
      ),
    );
  }

  homeAndGarden() {
    return Container(
      height: 300,
      child: ListView(
        children: [
          decorationContainer(name: 'Home Improvements & Repairs'),
          decorationContainer(name: 'Cleaning'),
          decorationContainer(name: 'Antiques & Collectibles'),
          decorationContainer(name: 'Carfts, Hobbies & Sports'),
          decorationContainer(name: 'Flower Shops'),
          decorationContainer(name: 'Home Goods'),
          decorationContainer(name: 'Landscape &  Lawn Service'),
          decorationContainer(name: 'Pest Control'),
          decorationContainer(name: 'Pool Supplies & Service'),
          decorationContainer(name: 'Security System & Services'),
          decorationContainer(name: 'Home Furnishings'),
        ],
      ),
    );
  }

  constructionAndContractors() {
    return Container(
      height: 300,
      child: ListView(
        children: [
          decorationContainer(name: 'Architects, Engineers & Surveyors'),
          decorationContainer(name: 'Building Materials & Supplies'),
          decorationContainer(name: 'Construction Compaines'),
          decorationContainer(name: 'Electricians'),
          decorationContainer(name: 'Plumbers'),
          decorationContainer(name: 'Environmental Assessment'),
          decorationContainer(name: 'Blasting & Demolition'),
          decorationContainer(name: 'Inspectors'),
          decorationContainer(name: 'Plaster & Concrete'),
        ],
      ),
    );
  }

  bussinessSupportAndSupplies() {
    return Container(
      height: 300,
      child: ListView(
        children: [
          decorationContainer(name: 'Offices Supplies'),
          decorationContainer(name: 'Printing & Publishing'),
          decorationContainer(name: 'Marketing & Communications'),
          decorationContainer(name: 'Consultants'),
        ],
      ),
    );
  }

  personalCareAndServices() {
    return Container(
      height: 300,
      child: ListView(
        children: [
          decorationContainer(name: 'Exercise & Fitness'),
          decorationContainer(name: 'Massage & Body Work'),
          decorationContainer(name: 'Barber Salons '),
          decorationContainer(name: 'Beauty & Nail Salons'),
          decorationContainer(name: 'Animal Care & Supplies'),
          decorationContainer(name: 'Dry Clearning & Laudromats'),
          decorationContainer(name: 'Tailors'),
          decorationContainer(name: 'Shoe Repairs'),
        ],
      ),
    );
  }

  manufacturingWholesalesAndDistribution() {
    return Container(
      height: 300,
      child: ListView(
        children: [
          decorationContainer(name: 'Distribution'),
          decorationContainer(name: 'Import & Export'),
          decorationContainer(name: 'Manufacturing'),
          decorationContainer(name: 'Wholesale'),
        ],
      ),
    );
  }

  others3() {
    return Container(
      height: 300,
      child: ListView(
        children: [
          decorationContainer(name: 'Clothing & Accessories'),
          decorationContainer(name: 'Shoes'),
          decorationContainer(name: 'Jewelry'),
          decorationContainer(name: 'Cards & Gifts'),
          decorationContainer(name: 'Department Stores'),
          decorationContainer(name: 'Sporting Goods'),
        ],
      ),
    );
  }

  others4() {
    return Container(
      height: 300,
      child: ListView(
        children: [
          decorationContainer(name: 'Clothing & Accessories'),
          decorationContainer(name: 'Shoes'),
          decorationContainer(name: 'Jewelry'),
          decorationContainer(name: 'Cards & Gifts'),
          decorationContainer(name: 'Department Stores'),
          decorationContainer(name: 'Sporting Goods'),
        ],
      ),
    );
  }
}

class Category {
  decorationContainer({required String name}) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 50,
        child: Card(
          color: Colors.grey[300],
          child: Center(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  categoryitem(context) {
    return Container(
      height: 450,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            decorationContainer(name: 'Merchant'),
            decorationContainer(name: 'Automotive'),
            decorationContainer(name: 'Computers and Electronics'),
            decorationContainer(name: 'Food and Dining'),
            decorationContainer(name: 'Travel and Transport'),
            decorationContainer(name: 'Real Estates'),
            decorationContainer(name: 'Home and Garden'),
            decorationContainer(name: 'Construction and Contractors'),
            decorationContainer(name: 'Bussiness Support and Supplies'),
            decorationContainer(name: 'Personal Care and Services'),
            decorationContainer(
                name: 'Manufacturing Wholesales and Distribution'),
            decorationContainer(name: 'Others3'),
            decorationContainer(name: 'Others4'),
          ],
        ),
      ),
    );
  }
}
