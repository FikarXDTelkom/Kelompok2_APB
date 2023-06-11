import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class AccountSettingPage extends StatefulWidget {
  final String profileEmail;
  final String profileId;

  AccountSettingPage({
    required this.profileEmail,
    required this.profileId,
  });

  @override
  _AccountSettingPageState createState() => _AccountSettingPageState();
}

class _AccountSettingPageState extends State<AccountSettingPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _idController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _roleController = TextEditingController();
  TextEditingController _profilePictureController = TextEditingController();
  String _profilePictureUrl = '';

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
        Map<String, dynamic> userData =
            snapshot.data() as Map<String, dynamic>;

        setState(() {
          _emailController.text = userData['email'];
          _idController.text = userData['id'];
          _phoneNumberController.text = userData['phoneNumber'];
          _roleController.text = userData['role'];
          _profilePictureUrl = userData['profileImageUrl'];
        });
      }
    }
  }

  Future<void> _uploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Here, you can upload the pickedImage to a storage service like Firebase Storage
      // and get the URL of the uploaded image.

      // For demonstration purposes, let's assume we already have the image URL.
      String imageUrl = 'gs:/flutter-aplikasi-wong-pak-wong.appspot.com';

      setState(() {
        _profilePictureUrl = imageUrl;
        _profilePictureController.text = imageUrl;
      });
      // You can also update the profile picture URL in the Firestore collection here.
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'profileImageUrl': pickedImage,
        });
      }
    } catch (e) {
      // Handle any error that occurred while updating the profile picture URL in Firestore
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error Updating Profile Picture'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    }
  }
  void _updateAccountSettings() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Update the email address
        String newEmail = _emailController.text;
        await user.updateEmail(newEmail);

        // Update the password
        String newPassword = _passwordController.text;
        if (newPassword.isNotEmpty) {
          await user.updatePassword(newPassword);
        }

        // Update other user data in Firestore
        String uid = user.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'email': newEmail,
          'id': _idController.text,
          'phoneNumber': _phoneNumberController.text,
          'role': _roleController.text,
          'profileImageUrl': _profilePictureController.text,
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Account Settings Updated'),
              content: Text('Your account settings have been successfully updated.'),
              actions: [
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle any error that occurred while updating account settings
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error Updating Account Settings'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Setting Page'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: _uploadProfilePicture,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: _profilePictureUrl.isNotEmpty
                  ? NetworkImage(_profilePictureUrl)
                  : null,
              child: _profilePictureUrl.isEmpty
                  ? Icon(Icons.person, size: 50)
                  : null,
            ),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          TextField(
            controller: _idController,
            decoration: InputDecoration(labelText: 'ID'),
          ),
          TextField(
            controller: _phoneNumberController,
            decoration: InputDecoration(labelText: 'Phone Number'),
          ),
          TextField(
            controller: _roleController,
            decoration: InputDecoration(labelText: 'Role'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _updateAccountSettings,
            child: Text('Update Account Settings'),
          ),
        ],
      ),
    );
  }
}
