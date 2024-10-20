import 'package:flutter/material.dart';

class Searchpage extends StatefulWidget {
    Searchpage({super.key});
  @override
  State<Searchpage> createState() => _SearchpageState();
}
class _SearchpageState extends State<Searchpage> {
  final TextEditingController _controller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchBar(
              hintText: 'Search Users..',
             backgroundColor: const WidgetStatePropertyAll(Colors.white),
              controller:_controller ,

            )
          ],
        ),
      ),
    );
  }
}
