import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../components/login_button.dart';
import '../components/textfield.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
final userid;
final documerntReference;
  ProfilePage({super.key,
  required this.documerntReference,
    required this.userid
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  bool _isLoading = false;
  final TextEditingController _controller =TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
           // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child:Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: _image != null
                          ? FileImage(_image!)
                          : const AssetImage('assets/avatar.png') as ImageProvider,
                      child: _image == null
                          ? const Icon(
                        Icons.camera_alt,
                        size: 30,
                        color: Colors.blue,
                      )
                          : null,
                    ),
                    Positioned(
                      // Center the edit icon over the avatar
                      top: 90,
                      left: 90,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        color: Colors.black,
                        child: Icon(
                          Icons.edit,
                          size: 30, // Adjust size as needed
                          color: Colors.blue, // You can change the color as needed
                        ),
                      ),
                    ),
                  ],
                )
              ),
              const SizedBox(height: 50,),
              MyTextfield(
                  icon: const Icon(Icons.person),
                  name: 'UserName',
                  obst: false,
                  controller: _controller),
              const SizedBox(height: 10,),
              GestureDetector(
                child: const LoginButton(
                  name: 'Done',
                ),
                onTap: (){
                  _saveProfile(widget.documerntReference,widget.userid);
                  },
              ),
              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.green[100],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }
  Future<void> _saveProfile(DocumentReference documerntReference,String userid) async {
    setState(() {
      _isLoading = true;
    });
    if (_image != null) {
      try {
        Reference storageRef = _storage.ref().child('profile_images/$userid.jpg');
        UploadTask uploadTask = storageRef.putFile(_image!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        await documerntReference.update({
          'username':_controller.text,
          'imageurl':downloadUrl,

        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
        );
      } catch (e) {

      }
      finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
    else {
      try{
      await documerntReference.update({
        'username': _controller.text,
        'imageurl': 'https://firebasestorage.googleapis.com/v0/b/coupchat1.appspot.com/o/avatar.png.png?alt=media&token=7a21d7fa-c6f5-4ac3-b45a-aaeca09c1275',

      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => false,
      );
    } catch(e){

      }

    }
  }
}


