import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'management.dart';
import 'profile_page.dart' as UserProfilePage;
import 'account_setting.dart';

class SettingPage extends StatefulWidget {
  final String profileEmail;
  final String profileId;

  SettingPage({required this.profileEmail, required this.profileId});

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
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
          profileImageUrl = data['profileImageUrl'] ??'';
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting Page'),
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
              title: Text('Profile', style: TextStyle(color: Colors.indigo)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfilePage.ProfilePage(
                    profileEmail: widget.profileEmail,
                    profileId: widget.profileId,
                  )),
                );
              },
            ),
            ListTile(
              title: Text('Management', style: TextStyle(color: Colors.indigo)),
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
              title: Text('Setting', style: TextStyle(color: Colors.indigo)),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Logout', style: TextStyle(color: Colors.indigo)),
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
        child: ListView(
          children: [
           ListTile(
              leading: Icon(Icons.account_circle, color: Colors.black),
              title: Text('Account Setting', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Edit your user account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AccountSettingPage(
                    profileEmail: widget.profileEmail,
                    profileId: widget.profileId,
                  )),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.black),
              title: Text('About', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Learn more about the application'),
              onTap: () {
                /*
                Navigator.push(
                  
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                  
                );
                */
              },
            ),
          ],
        ),
      ),
    );
  }
}
