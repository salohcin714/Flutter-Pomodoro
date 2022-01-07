import 'package:flutter/material.dart';

class TimeSelect extends StatelessWidget {
  final String selected;
  final void Function(dynamic) onSelect;
  final List<String> list = [];

  TimeSelect({Key? key, required this.selected, required this.onSelect})
      : super(key: key) {
    for (var i = 0; i <= 60; i++) {
      list.add(i.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      style: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
      borderRadius: BorderRadius.circular(5),
      value: selected,
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onSelect,
    );
  }
}
