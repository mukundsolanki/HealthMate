// @dart=2.17
import 'package:flutter/material.dart';
import 'package:heathmate/screens/about.dart';
import 'package:heathmate/screens/profile.dart';

class Commonscaffold extends StatefulWidget {
  final Widget body;

  const Commonscaffold({super.key, required this.body});

  @override
  State<Commonscaffold> createState() => _CommonscaffoldState();
}

class _CommonscaffoldState extends State<Commonscaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            title: const Text(
              "HealthMate",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: widget.body,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple, Colors.deepPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
              
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
                        
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
               
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutPage()));
                 
              },
            ),
          ],
        ),
      ),
    );
  }
}