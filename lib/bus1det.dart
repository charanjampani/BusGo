import 'package:flutter/material.dart';


class bus1det extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.indigo[600],
        ),
        body: Padding
        (
            padding: const EdgeInsets.all(45.0),
            child: SingleChildScrollView
            (
              child: Column
              (
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                [
                  Container(
                  width: 300,
                  height: 300,
                  child: Image.asset('lib/assets/bus1.jpeg'),
                  ),
                  const SizedBox(height: 15),
                  const Text ("Bus CB 7C"),
                  const SizedBox(height: 15),
                  const Text ("K R Market to Autonagar"),
                  const SizedBox(height: 15),

                ],
              ),
            ),
        ),
    );
  }
}