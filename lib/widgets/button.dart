import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final Icon icon;
  final void Function() onPress;

  const Button(
      {Key? key,
      required this.title,
      required this.icon,
      required this.onPress})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: IconButton(
        icon: icon,
        tooltip: title,
        onPressed: onPress,
      ),
    );
  }
}
