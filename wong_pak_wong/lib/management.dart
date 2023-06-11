import 'package:flutter/material.dart';
import 'package:wong_pak_wong/item_detail_page.dart';
import 'setting_page.dart';
import 'login_page.dart';
import 'profile_page.dart' as UserProfilePage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManagementPage extends StatefulWidget {
  final String profileEmail;
  final String profileId;

  ManagementPage({
    required this.profileEmail,
    required this.profileId,
  });

  @override
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
  ];

  TextEditingController _addItemController = TextEditingController();
  String profileImageUrl = '';

  @override
  void initState() {
    super.initState();
    fetchProfileData(); // Fetch profile data from Firestore
  }

  void fetchProfileData() async {
    // Retrieve the currently authenticated user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Get the user's UID
      String uid = user.uid;

      // Query the Firestore collection to fetch the profile data based on the UID
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          profileImageUrl = data['profileImageUrl'] ?? '';
        });
      }
    }
  }

  void _addItem() {
    setState(() {
      items.add(_addItemController.text);
    });
    _showNotification('Item Added', 'Item ${_addItemController.text} has been added.');
    _addItemController.clear();
  }

  void _updateItem(int index, String updatedItem) {
    setState(() {
      items[index] = updatedItem;
    });
    _showNotification('Item Updated', 'Item ${items[index]} has been updated.');
  }

  void _deleteItem(int index) {
    setState(() {
      items.removeAt(index);
    });
    _showNotification('Item Deleted', 'Item has been deleted.');
  }

  void _showNotification(String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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
              leading: Icon(Icons.account_circle_rounded,color: Colors.lightBlue,) ,
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
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 3,
              child: ListTile(
                title: Text(
                  items[index],
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteItem(index);
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemDetailPage(itemName: items[index]),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Item', style: TextStyle(color: Colors.indigo)),
                content: TextField(
                  controller: _addItemController,
                  decoration: InputDecoration(
                    labelText: 'Item Name',
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel', style: TextStyle(color: Colors.indigo)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text('Add', style: TextStyle(color: Colors.indigo)),
                    onPressed: () {
                      if (_addItemController.text.isNotEmpty) {
                        _addItem();
                        Navigator.pop(context);
                      } else {
                        _showNotification('Invalid Input', 'Please enter an item name.');
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
