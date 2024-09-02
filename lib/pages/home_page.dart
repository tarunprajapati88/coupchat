
import 'package:flutter/material.dart';



import '../components/homedrawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.green[50],
      appBar:  AppBar(
        actions: [
          Builder(
              builder: (context) {
                return IconButton(onPressed: (){
                  Scaffold.of(context).openEndDrawer();
                }, icon:const Icon(Icons.settings) );
              }
          )
        ],
        title: const Text('CoupChat',
          style: TextStyle(
              fontFamily: 'PlaywriteCU',
              fontWeight: FontWeight.w700,
              fontSize: 25,
              color: Colors.black
          ),),
        backgroundColor: Colors.green[100],
      ),
      endDrawer:  Drawer(
        backgroundColor: Colors.green[50],
        child: const Homedrawer(),
      ),

    );
  }
}
