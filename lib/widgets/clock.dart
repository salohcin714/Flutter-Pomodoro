import 'package:flutter/material.dart';

class Clock extends StatelessWidget {
  final String currentTime;

  const Clock({Key? key, required this.currentTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          currentTime,
          style: const TextStyle(fontSize: 50),
        ),
      ),
    );
  }
}
