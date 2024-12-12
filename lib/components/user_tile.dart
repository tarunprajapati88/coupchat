import 'package:coupchat/components/prfofile_photo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Usertile extends StatelessWidget {
  final Map<String, dynamic> latestMsg;
  final String text;
  final Widget? image;
  final Icon verfied;
  final void Function()? onTap;

  const Usertile({
    super.key,
    required this.text,
    required this.onTap,
    required this.image,
    required this.verfied,
    required this.latestMsg,
  });

  @override
  Widget build(BuildContext context) {
    final tilelen = MediaQuery.of(context).size.height;
    final FirebaseAuth _auth = FirebaseAuth.instance;

    if(latestMsg['seen']!="null"){
      DateTime dateTime =latestMsg['timestamp'].toDate();
      String formattedTime = DateFormat('hh:mm a').format(dateTime);

      bool isCurrentUser = _auth.currentUser?.uid != latestMsg['reciversID'];
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
        child: Container(
          height: tilelen / 11,
          decoration: BoxDecoration(
          color: !isCurrentUser && latestMsg['seen'] == !true? Colors.green[50]:Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 2, 5, 2),
                child: PrfofilePhoto(
                  image: image,
                  height: tilelen / 14,
                  weight: tilelen / 14,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                text,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),verfied,
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),

                    isCurrentUser?
                    Row(
                      children: [
                        Icon(size: 18,
                          Icons.done_all_rounded,
                          color: latestMsg['seen'] == true
                              ? Colors.blueAccent
                              : Colors.grey,
                        ),
                        const SizedBox(width: 5),
                           if(latestMsg['type']=='text') Expanded(
                          child: Text(
                            latestMsg['message'] ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                        if(latestMsg['type']=='voicenote') const Row(
                          children: [
                            Icon(Icons.mic_none_sharp,color: Colors.grey,),
                            Text('Voicenote'),
                          ],
                        ),
                        if(latestMsg['type']=='image')  const Row(
                          children: [
                            Icon(Icons.image,color: Colors.grey,),
                            Text('Image'),
                          ],
                        ),
                      ],
                    ) :
                        latestMsg['seen'] == true?
                        latestMsg['type']=='text'?
                        Expanded(
                        child:  Text(
                          latestMsg['message'] ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(color: Colors.black54),
                        ),
                        )  :
                        latestMsg['type']=='voicenote'?
                          const Row(
                           children: [
                        Icon(Icons.mic_none_sharp,color: Colors.grey,),
                       Text('Voicenote'),
                       ],
                        ):
                        const Row(
                               children: [
                                Icon(Icons.image,color: Colors.grey,),
                         Text('Image'),
                              ],
                            )

                        :
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.fiber_new_rounded,color: Colors.blue,
                        ),
                        const SizedBox(width: 5),
                          if(latestMsg['type']=='text')
                        Expanded(
                          child: Text(
                            latestMsg['message'] ?? "",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ),
                        if(latestMsg['type']=='voicenote') const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.mic_none_sharp,color: Colors.grey,),
                            Text('Voicenote'),
                          ],
                        ),
                        if(latestMsg['type']=='image')  const Row(
                          children: [
                            Icon(Icons.image,color: Colors.grey),
                            Text('Image'),
                          ],
                        ),

                      ],
                    )
                  ],
                ),
              ),

              Text(formattedTime,style: const TextStyle(color: Colors.grey,fontSize: 10)),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );}
    else{
    return  GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 1, 5, 1),
        child: Container(
          height: tilelen / 11,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 2, 5, 2),
                child: PrfofilePhoto(
                  image: image,
                  height: tilelen / 14,
                  weight: tilelen / 14,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    text,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),verfied,
                                ],
                              ),
                              Text('Say Hii to your new fiend!!!',style: TextStyle(color: Colors.blueAccent),)
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                    const SizedBox(height: 2),

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
    }
  }
}
