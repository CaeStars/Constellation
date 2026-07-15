import 'package:flutter/material.dart';
import '../widgets/header.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: /* Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/constellation-bg.webp"),
            fit: BoxFit.cover,
          ),
        ),
        child: */ Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/constellation-bg.webp"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.only(
                    top: 72,
                    right: 16,
                    left: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      Text("""asdashkdjashd..."""),
                      SizedBox(height: 1000),
                      Text("lmfao"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Positioned(top: 16, left: 16, right: 16, child: Header()),
        ],
      ),
    );
  }
}
