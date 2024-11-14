import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coupchat/chat/chat_service.dart';
import 'package:coupchat/pages/seeUSERprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coupchat/components/prfofile_photo.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart';
import '../components/voice_message.dart';


class ChatRoom extends StatefulWidget {
  final String senderID;
  final String reciverID;
  final String Username;
  final String uniqueUsername;
  final Widget? image;
  final bool isverfies;

  const ChatRoom({
    super.key,
    required this.senderID,
    required this.reciverID,
    required this.Username,
    this.image,
    required this.uniqueUsername,
    required this.isverfies,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController tosend = TextEditingController();
  final ChatService _chatService = ChatService();
  DocumentReference? messageReff;
  bool _isTextEmpty = true;
  bool _isRecording = false;
  String? _audioFilePath;
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();



  @override
  void initState() {
    super.initState();
    tosend.addListener(() {
      setState(() {
        _isTextEmpty = tosend.text.isEmpty;
      });
    });
  }

  @override
  void dispose() {
    tosend.dispose();
    _recorder.closeRecorder();
    super.dispose();
  }

  void sendMessage() async {
    if (tosend.text.isNotEmpty) {
      DocumentReference messageRef =
      await _chatService.sendMessage(widget.reciverID, tosend.text, false,);
      tosend.clear();
      setState(() {
        messageReff = messageRef;
      });
    }
  }



  void updateSeenStatus(DocumentReference messageRef) async {
    await messageRef.update({'seen': true});
  }

  @override
  Widget build(BuildContext context) {
    final tilelen = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        leadingWidth: tilelen / 7.5,
        titleSpacing: 0,
        leading: Row(
          children: [
            const BackButton(),
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
                  verfied: Icon(
                    widget.isverfies ? Icons.verified_rounded : null,
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            );
          },
          child: Row(
            children: [
              Text(
                widget.Username,
                style: const TextStyle(),
              ),
              Icon(
                widget.isverfies ? Icons.verified_rounded : null,
                color: Colors.greenAccent,
              )
            ],
          ),
        ),
        backgroundColor: Colors.grey[300],
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _builduserInput(),
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
          crossAxisAlignment: isCurrentuser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(maxWidth: contwidth),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: isCurrentuser ? Colors.grey[300] : Colors.white,
              ),
              child: Column(
                children: [
                  VoiceMessage(
                  audioUrl:  data['audiourl'],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 10,
                      color: isCurrentuser
                          ? (isMsgseen ? Colors.brown : Colors.grey[600])
                          : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
      child: Column(
        crossAxisAlignment:
        isCurrentuser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [

          Container(
            constraints: BoxConstraints(maxWidth: contwidth),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: isCurrentuser ? Colors.grey[300] : Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data['message'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[800],
                  ),
                ),
                Text(
                  formattedTime,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 10,
                    color: isCurrentuser
                        ? (isMsgseen ? Colors.brown : Colors.grey[600])
                        : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _builduserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
          mainAxisAlignment: _isRecording?MainAxisAlignment.end:MainAxisAlignment.center,
        children: [
          _isRecording? const IconButton(onPressed: null, icon:Icon(Icons.fiber_manual_record,
          color: Colors.redAccent,
          ))
              : const IconButton(
              onPressed: null,
              icon: Icon(Icons.add,color: Colors.black,)
          ),
          Expanded(
            child:    _isRecording?
                 SizedBox(
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
                 ):

            TextField(
             minLines: 1,
             maxLines: 5,
              controller: tosend,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
              child:
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child:_isTextEmpty ? GestureDetector(
                     onLongPress: startRecording,
                     onLongPressUp: stopRecording,
                     child: Icon(
                       Icons.mic,
                      size: _isRecording?38:28,
                     ),
                   ):
                   GestureDetector(
                     onTap: sendMessage,
                     child: const Icon(Icons.send_sharp,
                     size:28,),
                   )
                 ),
            ),
          ),
        ],
      ),
    );
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

    setState(() {
      _isRecording = true;
    });
  }

  Future<void> stopRecording() async {
    final path = await _recorder.stopRecorder();
    await _recorder.closeRecorder();
    setState(() {
      _isRecording = false;
    });

    if (path != null) {
      String audioUrl = await _chatService.uploadVoiceNote(path);
      await _chatService.sendVoiceNote(
        widget.reciverID,
        audioUrl,
        false,
      );
    }
  }


}
