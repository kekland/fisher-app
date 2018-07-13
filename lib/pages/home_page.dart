import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fisher/pages/maps_page.dart';
import 'package:fisher/pages/new_post_page.dart';
import 'package:fisher/pages/news_page.dart';
import 'package:fisher/widgets/bottom_sheet_fix.dart';
import 'package:flutter/material.dart';
import 'package:map_view/location.dart';
import 'package:map_view/map_options.dart';
import 'package:map_view/map_view.dart';
import 'package:map_view/map_view_type.dart';
import 'package:map_view/polygon.dart';
import 'package:map_view/toolbar_action.dart';
import 'package:xml/xml.dart' as xml;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

int selectedPage = 0;
List bodyPages = [
  NewsPage(),
];

class _HomePageState extends State<HomePage> {
  MapView map = new MapView();

  Map<String, List<Location>> mapPolygons;

  getDataForMap() async {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    final FirebaseStorage storage = FirebaseStorage.instance;

    Stream<List<int>> stream = new Stream.fromFuture(storage.ref().child('fish_restrictions.kml').getData(1000000));
    String restrictionData = '';
    await stream.transform(utf8.decoder).transform(const LineSplitter()).listen((line) {
      restrictionData += line.trim();
    }).asFuture<String>();

    restrictionData = restrictionData.replaceAll('  ', '');
    var restrictionsXml = xml.parse(restrictionData);
    var polygons = restrictionsXml.findAllElements('Placemark');

    polygons.forEach((polygon) {
      try {
        String name = polygon.firstChild.text;

        debugPrint(name);
        String coordinates = polygon.findAllElements('coordinates').single.text;

        List<Location> locations = [];
        List numbers = coordinates.split(',');
        for (int i = 0; i < numbers.length - 2; i += 2) {
          String lat = numbers[i];
          String long = numbers[i + 1];

          double latitude = double.parse(lat);
          double longitude = double.parse(long);

          locations.add(new Location(longitude, latitude));
        }

        map.addPolygon(Polygon(
          name,
          locations,
          fillColor: Colors.red.withAlpha(60),
          strokeColor: Colors.red,
        ));
      } catch (e) {
        print(e);
      }
    });

    DataSnapshot snapshot = (await database.reference().child('fish_bucket').once());
    Map values = snapshot.value;
    values.forEach((id, val) {
      Map value = val as Map;
      map.addMarker(Marker(id, value['type'], value['latitude'] as double, value['longitude'] as double));
    });
  }

  initState() {
    MapView.setApiKey("AIzaSyB0lGAk7-lhQ5OFED6SOcoDD2e81YoVssE");
    super.initState();
    map.onMapReady.listen((_) => getDataForMap());
  }

  showMap() async {
    map.show(
      MapOptions(
        showCompassButton: true,
        showMyLocationButton: true,
        showUserLocation: true,
        mapViewType: MapViewType.normal,
        title: 'Fishing Map',
      ),
      toolbarActions: [
        ToolbarAction('Close', 1),
      ],
    );
  }

  GlobalKey<ScaffoldState> scaffold = new GlobalKey();
  selectPage(int index) {
    if (index == 1) {
      showMap();
    } else {
      setState(() {
        selectedPage = index;
      });
    }
  }

  openNewPost(BuildContext context) {
    //Navigator.of(context).pushNamed('/new_post');
    showModalBottomSheetFixed(
        context: context,
        dismissOnTap: false,
        resizeToAvoidBottomPadding: true,
        builder: (BuildContext ctx) {
          return NewCatchBottomSheetPage();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffold,
      appBar: AppBar(
        title: Text((selectedPage == 0) ? 'Feed' : 'Map', style: TextStyle(fontFamily: 'Futura')),
        actions: [
          PopupMenuButton<int>(
            onSelected: (int sel) async {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Please, wait'),
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 24.0),
                          Text('Logging out'),
                        ],
                      ),
                    );
                  });
              final FirebaseAuth auth = FirebaseAuth.instance;
              await auth.signOut();

              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/registration');
            },
            itemBuilder: (context) => <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 0,
                    child: const Text('Log out'),
                  ),
                ],
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
                  color: (selectedPage == 1) ? Colors.blue.shade500 : Colors.black54,
                ),
                onPressed: () => selectPage(1),
              ),
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: (selectedPage == 0) ? Colors.blue.shade500 : Colors.black54,
                ),
                onPressed: () => selectPage(0),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () => openNewPost(context),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: NewsPage(),
    );
  }
}
