import 'package:flutter/material.dart';

class DisplayMessage extends StatelessWidget {
  
  final String message;

  const DisplayMessage({
    super.key,
    required this.message
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: SingleChildScrollView(
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.normal,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ), 
        ),
      ),
    );
  }
}