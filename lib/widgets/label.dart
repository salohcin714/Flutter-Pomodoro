import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  const Label(
      {Key? key,
      required this.working,
      required this.paused,
      required this.playing})
      : super(key: key);

  final bool working;
  final bool paused;
  final bool playing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: (playing || paused) ? 100 : 0,
          padding: const EdgeInsets.symmetric(
            vertical: 25,
          ),
          child: Center(
            child: Text(
              working ? 'Work Time' : 'Break Time',
              style: TextStyle(
                fontSize: 40,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: (((!paused && !playing) || (paused)) ? 60 : 46),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            children: [
              if (!paused && !playing)
                Center(
                  child: Text(
                    'Press Play to Start',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,

                    ),
                  ),
                ),
              if (paused)
                Center(
                  child: Text(
                    'Paused',
                    style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }
}
