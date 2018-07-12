import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

int selectedPage = 0;
List bodyPages = [
  Container(
    color: Colors.red,
  ),
  Container(
    color: Colors.blue,
  ),
];

class _HomePageState extends State<HomePage> {
  selectPage(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (selectedPage == 0)? 'Feed' : 'Map',
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              child: Text('A'),
              backgroundColor: Colors.red,
            ),
            onPressed: () => print('Opening profile'),
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => print('Opening menu'),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          height: 56.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(
                  Icons.map,
                  color: (selectedPage == 1)? Colors.black : Colors.black54,
                ),
                onPressed: () => selectPage(1),
              ),
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: (selectedPage == 0)? Colors.black : Colors.black54,
                ),
                onPressed: () => selectPage(0),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () => print('Adding photo'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
