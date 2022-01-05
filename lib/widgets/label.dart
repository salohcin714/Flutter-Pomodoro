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
              style: const TextStyle(
                fontSize: 40,
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: (((!paused && !playing) || (paused)) ? 60 : 0),
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            children: [
              if (!paused && !playing)
                const Center(
                  child: Text(
                    'Press Play to Start',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              if (paused)
                const Center(
                  child: Text(
                    'Paused',
                    style: TextStyle(
                      fontSize: 20,
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
