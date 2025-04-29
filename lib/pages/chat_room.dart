import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupchat/chat/chat_service.dart';
import 'package:coupchat/pages/seeUSERprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coupchat/components/prfofile_photo.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart';
import '../components/preview_image.dart';
import '../components/themes.dart';
import '../components/voice_message.dart';

class ChatRoom extends StatefulWidget {
  final String senderID;
  final String reciverID;
  final String Username;
  final String uniqueUsername;
  final Widget? image;
  final bool isverfies;
  final String token;
  final String currentUserName;
  const ChatRoom({
    super.key,
    required this.senderID,
    required this.reciverID,
    required this.Username,
    this.image,
    required this.uniqueUsername,
    required this.isverfies,
    required this.token,
    required this.currentUserName,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatService _chatService = ChatService();
  DocumentReference? messageReff;

  @override
  Widget build(BuildContext context) {
    List<Color> themeColors = ThemeManager.getThemeColors(ThemeManager.currentThemeIndex);
    final tilelen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: themeColors[1],
      appBar: AppBar(
        leadingWidth: tilelen / 7.5,
        titleSpacing: 0,
        leading: Row(
          children: [
            BackButton(color: themeColors[6]),
            PrfofilePhoto(
              image: widget.image,
              height: tilelen / 18.5,
              weight: tilelen / 18.5,
            ),
          ],
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Seeuserprofile(
                  image: widget.image,
                  username: widget.Username,
                  uniquename: widget.uniqueUsername,
                  verfied: widget.isverfies
                      ? Row(
                    children: [
                      Text(
                        widget.Username,
                        style: TextStyle(
                            color: themeColors[6],
                            fontFamily: 'PlaywriteCU',
                            fontSize: 30),
                      ),
                      const SizedBox(width: 3),
                      const Icon(Icons.verified_rounded, color: Colors.blueAccent, size: 21),
                    ],
                  )
                      : Row(
                    children: [
                      Text(widget.Username,
                          style: TextStyle(
                              color: themeColors[6],
                              fontFamily: 'PlaywriteCU',
                              fontSize: 30))
                    ],
                  ),
                ),
              ),
            );
          },
          child: Row(
            children: [
              Text(
                widget.Username,
                style: TextStyle(fontFamily: 'PlaywriteCU', color: themeColors[6]),
              ),
              const SizedBox(width: 3),
              Icon(
                widget.isverfies ? Icons.verified_rounded : null,
                color: Colors.blueAccent,
                size: 18,
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(children: [
              GestureDetector(child: Icon(Icons.call)),
              GestureDetector(child: Icon(Icons.videocam))
            ],),
          )
        ],
        backgroundColor: themeColors[0],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          MessageInputWidget(
            reciverID: widget.reciverID,
            chatService: _chatService,
            token: widget.token,
            currentUserName: widget.currentUserName,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _auth.currentUser!.uid;
    return StreamBuilder(
      stream: _chatService.getMessage(widget.reciverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading..');
        }
        List<DocumentSnapshot> docs = snapshot.data!.docs;

        List<Widget> messageWidgets =
        docs.map((doc) => _buildMessageItem(doc)).toList().reversed.toList();
        return ListView(
          reverse: true,
          children: messageWidgets,
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    List<Color> themeColors = ThemeManager.getThemeColors(ThemeManager.currentThemeIndex);
    final width = MediaQuery.of(context).size.width;
    final contwidth = width - (width / 5);
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentuser = data['senderId'] == _auth.currentUser!.uid;
    DateTime dateTime = data['timestamp'].toDate();
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    bool isMsgseen = data['seen'];

    if (!isCurrentuser && !isMsgseen) {
      updateSeenStatus(doc.reference);
    }
    if (data['type'] == 'voicenote') {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
        child: Column(
          crossAxisAlignment: isCurrentuser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: contwidth),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: isCurrentuser ? themeColors[10] : themeColors[9],
              ),
              child: Column(
                children: [
                  VoiceMessage(
                    audioUrl: data['audiourl'],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontFamily: 'PlaywriteCU',
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: isCurrentuser
                          ? (isMsgseen ? themeColors[13] : themeColors[11])
                          : themeColors[12],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    if (data['type'] == 'image') {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
        child: Column(
          crossAxisAlignment: isCurrentuser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImagePreviewScreen(imageUrl: data['mediaurl']),
                  ),
                );
              },
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: contwidth / 1.5,
                  maxHeight: 300,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: isCurrentuser ? Colors.grey[300] : Colors.white,
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: data['mediaurl'],
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Text(
                        formattedTime,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 10,
                            color: isCurrentuser
                                ? (isMsgseen ? themeColors[13] : themeColors[11])
                                : themeColors[12],
                            fontFamily: 'PlaywriteCU'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
      child: Column(
        crossAxisAlignment: isCurrentuser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: contwidth),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isCurrentuser ? themeColors[10] : themeColors[9],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data['message'],
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: isCurrentuser ? themeColors[11] : themeColors[12],
                      fontFamily: 'PlaywriteCU'),
                ),
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontFamily: 'PlaywriteCU',
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: isCurrentuser
                        ? (isMsgseen ? themeColors[13] : themeColors[11])
                        : themeColors[12],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void updateSeenStatus(DocumentReference messageRef) async {
    await messageRef.update({'seen': true});
  }
}

// Separate stateful widget for message input
class MessageInputWidget extends StatefulWidget {
  final String reciverID;
  final ChatService chatService;
  final String token;
  final String currentUserName;

  const MessageInputWidget({
    Key? key,
    required this.reciverID,
    required this.chatService,
    required this.token,
    required this.currentUserName,
  }) : super(key: key);

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  final TextEditingController tosend = TextEditingController();
  final ValueNotifier<bool> _isTextEmptyNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _isRecordingNotifier = ValueNotifier<bool>(false);
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    tosend.addListener(_updateTextEmptyStatus);
  }

  void _updateTextEmptyStatus() {
    _isTextEmptyNotifier.value = tosend.text.isEmpty;
  }

  @override
  void dispose() {
    tosend.removeListener(_updateTextEmptyStatus);
    tosend.dispose();
    _isTextEmptyNotifier.dispose();
    _isRecordingNotifier.dispose();
    _recorder.closeRecorder();
    super.dispose();
  }

  void sendMessage() async {
    if (tosend.text.isNotEmpty) {
      await widget.chatService.sendMessage(
        widget.reciverID,
        tosend.text,
        false,
        widget.token,
        widget.currentUserName,
      );
      tosend.clear();
    }
  }

  Future<void> startRecording() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission not granted');
    }

    await _recorder.openRecorder();
    await _recorder.startRecorder(
      toFile: '${DateTime.now().millisecondsSinceEpoch}_voice_note.aac',
      codec: Codec.aacADTS,
    );

    _isRecordingNotifier.value = true;
  }

  Future<void> stopRecording() async {
    final path = await _recorder.stopRecorder();
    await _recorder.closeRecorder();
    _isRecordingNotifier.value = false;

    if (path != null) {
      String audioUrl = await widget.chatService.uploadVoiceNote(path);
      await widget.chatService.sendVoiceNote(
        widget.reciverID,
        audioUrl,
        false,
        widget.token,
        widget.currentUserName,
      );
    }
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
          _isLoading = false;
        });

        _showImagePreviewDialog(compressedImageFile);
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

  void _showImagePreviewDialog(File imageFile) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0.1),
            ),
          ),
          Center(
            child: AlertDialog(
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                'Preview',
                style: TextStyle(
                  fontFamily: 'PlaywriteCU',
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () async {
                            Navigator.pop(context);
                            await _sendImage(imageFile);
                          },
                          child: const Text(
                            'Send',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendImage(File imageFile) async {
    String imageUrl = await widget.chatService.uploadImage(imageFile);
    await widget.chatService.sendMedia(
      widget.reciverID,
      imageUrl,
      false,
      widget.token,
      widget.currentUserName,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Color> themeColors = ThemeManager.getThemeColors(ThemeManager.currentThemeIndex);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ValueListenableBuilder<bool>(
        valueListenable: _isRecordingNotifier,
        builder: (context, isRecording, _) {
          return Row(
            crossAxisAlignment: !isRecording ? CrossAxisAlignment.end : CrossAxisAlignment.center,
            mainAxisAlignment: isRecording ? MainAxisAlignment.end : MainAxisAlignment.center,
            children: [
              isRecording
                  ? const IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.fiber_manual_record,
                    color: Colors.redAccent,
                  ))
                  : Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {
                    showMenu(
                      color: themeColors[1],
                      context: context,
                      position: const RelativeRect.fromLTRB(0, 550, 0, 0),
                      items: [
                        PopupMenuItem(
                          onTap: _pickImage,
                          value: 'option1',
                          child: Row(
                            children: [
                              Icon(Icons.photo, color: themeColors[6]),
                              SizedBox(width: 2),
                              Text('Media',
                                  style: TextStyle(
                                      fontFamily: 'PlaywriteCU', color: themeColors[6])),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'option2',
                          child: Row(
                            children: [
                              Icon(Icons.file_copy, color: themeColors[6]),
                              SizedBox(width: 2),
                              Text('Document',
                                  style: TextStyle(
                                      fontFamily: 'PlaywriteCU', color: themeColors[6])),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'option3',
                          child: Row(
                            children: [
                              Icon(Icons.add_location, color: themeColors[6]),
                              SizedBox(width: 2),
                              Text('Location',
                                  style: TextStyle(
                                      fontFamily: 'PlaywriteCU', color: themeColors[6])),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: themeColors[0],
                    ),
                    child: Icon(Icons.attach_file, color: themeColors[6]),
                  ),
                ),
              ),
              Expanded(
                child: isRecording
                    ? SizedBox(
                  height: 100,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Lottie.asset('assets/crntrec.json'),
                        Lottie.asset('assets/crntrec.json'),
                        Lottie.asset('assets/crntrec.json'),
                      ],
                    ),
                  ),
                )
                    : TextField(
                  cursorColor: themeColors[6],
                  minLines: 1,
                  maxLines: 5,
                  style: TextStyle(color: themeColors[6]),
                  decoration: InputDecoration(
                      hintText: 'Type a message',
                      hintStyle:
                      TextStyle(fontFamily: 'PlaywriteCU', color: themeColors[15]),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: themeColors[14],
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(color: themeColors[6], width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: themeColors[0]),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                      )),
                  controller: tosend,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: themeColors[0],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isTextEmptyNotifier,
                      builder: (context, isTextEmpty, _) {
                        return isTextEmpty
                            ? GestureDetector(
                          onLongPress: startRecording,
                          onLongPressUp: stopRecording,
                          child: Icon(
                            Icons.mic,
                            size: isRecording ? 38 : 28,
                            color: themeColors[6],
                          ),
                        )
                            : GestureDetector(
                          onTap: sendMessage,
                          child: Icon(
                            Icons.send_sharp,
                            color: themeColors[6],
                            size: 28,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}