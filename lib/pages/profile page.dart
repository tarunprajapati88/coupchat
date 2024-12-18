import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../components/loading.dart';
import '../components/login_button.dart';
import '../components/textfield.dart';
import 'home_page.dart';

class ProfilePage extends StatefulWidget {
final dynamic userid;
  final dynamic documerntReference;

  const ProfilePage({
    super.key,
    required this.documerntReference,
    this.userid,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  bool _isLoading = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controlleruid = TextEditingController();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    _initializeFCM();
    requestPermission();
    _requestNotificationsPermission();

  }
  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  Future<void> _requestNotificationsPermission() async {
    PermissionStatus status = await Permission.notification.request();
      await Permission.microphone.request();
    if (status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notification permission Granted")),
      );
      //fcm token
      String? token = await FirebaseMessaging.instance.getToken();
      _fcmToken=token;

    } else if (status.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notification permission denied. You may miss important updates.")),
      );
    } else if (status.isPermanentlyDenied) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notifications are permanently denied. Please enable them in the app settings.")),
      );
    }
  }
  Future<void> _initializeFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    setState(() {
      _fcmToken = token;
    });
    print('FCM Token: $_fcmToken');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        title: const Text('Create Profile'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : const AssetImage('assets/avatar.png.png') as ImageProvider,
                        ),
                        Positioned(
                          top: 90,
                          left: 90,
                          child: ClipOval(
                            child: Container(
                              color: Colors.black,
                              child: const Icon(
                                Icons.edit,
                                size: 30,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  MyTextfield(
                    icon: const Icon(Icons.person),
                    name: 'Name',
                    obst: false,
                    controller: _controller,
                    focusNode: _focusNode1,
                    focusNode2: _focusNode2,
                  ),
                  const SizedBox(height: 10),
                  MyTextfield(
                    icon: const Icon(Icons.account_circle_outlined),
                    name: 'Create Unique Username',
                    obst: false,
                    controller: _controlleruid,
                    focusNode: _focusNode2,
                    focusNode2: null,
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    child: LoginButton(
                      name: 'Done',
                      color: Colors.grey.shade400,
                    ),
                    onTap: () {
                      _saveProfile(widget.documerntReference, widget.userid);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          if (_isLoading)
            IgnorePointer(
              ignoring: !_isLoading,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child:  Center(
                  child: Loading(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _isLoading = true;
      });

      final imageFile = File(pickedImage.path);
      final directory = await getTemporaryDirectory();
      final targetPath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      try {
        final compressedImage = await FlutterImageCompress.compressAndGetFile(
          imageFile.path,
          targetPath,
          quality: 60,
        );
        final compressedImageFile = File(compressedImage!.path);
        setState(() {
          _image = compressedImageFile;
          _isLoading = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error during compression: ${e.toString()}")),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveProfile(DocumentReference documentReference, String userid) async {
    setState(() {
      _isLoading = true;
    });

    String imageUrl;

    try {
      if (_image != null) {

        Reference storageRef = _storage.ref().child('profile_images/$userid.jpg');
        UploadTask uploadTask = storageRef.putFile(_image!);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        imageUrl = await taskSnapshot.ref.getDownloadURL();
      } else {
        imageUrl = 'https://firebasestorage.googleapis.com/v0/b/coupchat1.appspot.com/o/avatar.png.png?alt=media&token=7a21d7fa-c6f5-4ac3-b45a-aaeca09c1275';
      }

      DocumentSnapshot documentSnapshot = await documentReference.get();
      Map<String, dynamic>? data = documentSnapshot.data() as Map<String, dynamic>?;
      String uid = data?['uid'];
      String email = data?['email'];


      await _firestore.collection('Users').doc(uid).set({
        'uid': uid,
        'email': email,
        'username': _controller.text,
        'imageurl': imageUrl,
        'Isverified': false,
        'uniqueUsername': _controlleruid.text,
        'usernameLower': _controller.text.toLowerCase(),
        'uniqueUsernameLower': _controlleruid.text.toLowerCase(),
        'fcmtoken': _fcmToken ?? "",
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

}
