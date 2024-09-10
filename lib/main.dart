import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Here I used 2 lists, one to store data and other to store searched data
  List<dynamic> items = [];
  List<dynamic> filteredItems = [];
  //This is the search controller for search bar
  TextEditingController searchController = TextEditingController();

  //updates the data when fetched from API, set-state is the basic state management tool
  @override
  void initState() {
    super.initState();
    fetchItems().then((data) {
      setState(() {
        items = data;
        filteredItems = data;
      });
    });
  }

  //This is the main function where we send the HTTP Get request, using async method
  Future<List<dynamic>> fetchItems() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load items');
    }
  }

  //Dialog Box to show if you want to process to next step or cancel it
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: const Text(
            "Confirmation",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          content: const Text("Do you want to proceed?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Proceed"),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //Main body "Build Method"
  //Here App bar, and body UI is created
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API List - Search Bar (TEST)'),
        centerTitle: true,
        elevation: 5.0,
        backgroundColor: Colors.blueAccent,
        titleTextStyle: const TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  filteredItems = items
                      .where((item) =>
                      item['title'].toLowerCase().contains(value.toLowerCase()))
                      .toList();
                });
              },
            ),
          ),

          //Expanded function for responsive screen size so that child can cover the available space
          //Next I used card for each Title
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  elevation: 4.0,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(
                      filteredItems[index]['title'],
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                _showConfirmationDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 15.0),
              ),
              child: const Text(
                'Proceed',
                style: TextStyle(fontSize: 16.0, color: Colors.white),

              ),
            ),
          ),
        ],
      ),
    );
  }
}
