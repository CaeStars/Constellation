import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color.fromARGB(100, 0, 0, 0),
          border: BoxBorder.all(color: Colors.white, width: 2),
        ),
        child: Row(
          children: [IconButton(onPressed: () {}, icon: Icon(Icons.menu))],
        ),
      ),
    );
  }
}
