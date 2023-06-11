import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'management.dart';
import 'setting_page.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final String profileEmail;
  final String profileId;

  ProfilePage({required this.profileEmail, required this.profileId});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String phoneNumber = '';
  String role = '';
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  void fetchProfileData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String uid = user.uid;

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          phoneNumber = data['phoneNumber'] ?? '';
          role = data['role'] ?? '';
          profileImageUrl = data['profileImageUrl'] ??'';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
            );
          },
        ),
        title: Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: Container(
                width: 48,
                child: Image.asset('assets/logo.png'),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.indigo,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountEmail: Text(
                widget.profileEmail,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountName: Text(
                'ID: ${widget.profileId}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(profileImageUrl),
              ),
              decoration: BoxDecoration(
                color: Colors.indigo,
              ),
            ),
            ListTile(
              title: Text(
                'Profile',
                style: TextStyle(color: Colors.indigo),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(
                'Management',
                style: TextStyle(color: Colors.indigo),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManagementPage(
                    profileEmail: widget.profileEmail,
                    profileId: widget.profileId,
                  )),
                );
              },
            ),
            ListTile(
              title: Text(
                'Setting',
                style: TextStyle(color: Colors.indigo),
              ),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingPage(
                    profileEmail: widget.profileEmail,
                    profileId: widget.profileId,
                  )),
                 );
              },
            ),
            ListTile(
              title: Text(
                'Logout',
                style: TextStyle(color: Colors.indigo),
              ),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade100, Colors.indigo.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text(
              'Profile Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              backgroundImage: NetworkImage(profileImageUrl),
              radius: 60,
            ),
            SizedBox(height: 20),
            Text(
              'Email: ${widget.profileEmail}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'ID: ${widget.profileId}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Phone Number: $phoneNumber',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Role: $role',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
