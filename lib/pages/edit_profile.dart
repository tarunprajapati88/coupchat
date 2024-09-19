import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupchat/components/textfield2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../components/login_button.dart';
import 'home_page.dart';

class EditProfile extends StatefulWidget {
   final String? oldname;
   final String? oldnameid;
   final String? imageUrl;
   final String userid;
  final DocumentReference documentReference;
   const EditProfile({super.key,
  required this.documentReference, required this.oldname,required this.oldnameid, required this.imageUrl, required this.userid,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? _image;
  bool _isLoading = false;
  late TextEditingController _controller;
  late TextEditingController _controlleruid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.oldname);
    _controlleruid = TextEditingController(text: widget.oldnameid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Edit Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  const SizedBox(height: 40,),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                            radius: 60,
                            backgroundImage: _image != null
                                ? FileImage(_image!)
                                : NetworkImage(widget.imageUrl!) as ImageProvider
                        ),
                        Positioned(
                          top: 90,
                          left: 90,
                          right: 0,
                          bottom: 0,
                          child: ClipOval(
                            child: Container(
                              color: Colors.black,
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40,),
                  MyTextfield2(
                    icon: const Icon(Icons.person),
                    name: 'Edit Name',
                    obst: false,
                    controller: _controller,
                  ),
                  const SizedBox(height: 10,),
                  MyTextfield2(
                    icon: const Icon(Icons.account_circle_outlined),
                    name: 'Edit Unique username',
                    obst: false,
                    controller: _controlleruid,
                  ),
                  const SizedBox(height: 10,),
                  GestureDetector(
                    child: const LoginButton(
                      name: 'Done',
                    ),
                    onTap: () {
                      _saveProfile(widget.documentReference, widget.userid);
                    },
                  ),
              const SizedBox(height: 10,),
              if (_isLoading)
          Center(
        child: CircularProgressIndicator(
        color: Colors.green[100],
        ),)
                ]
            ),
          ),
        )
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
        source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _saveProfile(DocumentReference documerntReference, String userid) async {
    setState(() {
      _isLoading = true;
    });
    if (_image != null) {
      try {
        Reference storageRef = _storage.ref().child(
            'profile_images/$userid.jpg');
        UploadTask uploadTask = storageRef.putFile(_image!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        await _firestore.collection('Users').doc(userid).update({
          'username': _controller.text,
          'imageurl': downloadUrl,
          'uniqueUsername': _controlleruid.text
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
        );
      } catch (e) {
        AlertDialog(title: Text(e.toString()),);
      }
      finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
    else{
      try {
        await _firestore.collection('Users').doc(userid).update({
          'username': _controller.text,
          'uniqueUsername': _controlleruid.text
        });

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
        );
      } catch (e) {
        AlertDialog(title: Text(e.toString()),);
      }
      finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


}
