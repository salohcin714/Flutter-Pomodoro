import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:pomodoro_clock/widgets/button.dart';
import 'package:pomodoro_clock/widgets/clock.dart';
import 'package:pomodoro_clock/widgets/label.dart';
import 'package:pomodoro_clock/widgets/time_select.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock/wakelock.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.jetBrainsMonoTextTheme(),
        backgroundColor: Colors.white,
        primaryColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.black),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        textTheme: GoogleFonts.jetBrainsMonoTextTheme(),
        backgroundColor: Colors.blueGrey.shade900,
        primaryColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const PomodoroClock(),
    );
  }
}

class PomodoroClock extends StatefulWidget {
  const PomodoroClock({Key? key}) : super(key: key);

  @override
  State<PomodoroClock> createState() => _PomodoroClockState();
}

class _PomodoroClockState extends State<PomodoroClock> {
  bool _isWorking = true;
  bool _isPaused = false;
  bool _isPlaying = false;
  String _currentTime = "25:00";
  String _workTime = "25:00";
  String _breakTime = "05:00";
  Timer? _timer;
  bool _shouldVibrate = true;
  bool _shouldSound = true;
  bool _canVibrate = false;

  _PomodoroClockState() {
    checkVibrate();
  }

  checkVibrate() async {
    _canVibrate = (await Vibration.hasVibrator())!;
  }

  String getTime(String val) {
    return leftPadding(val) + ':00';
  }

  String leftPadding(String val) {
    if (int.parse(val) < 10) {
      return '0' + val;
    } else {
      return val.toString();
    }
  }

  void setWorkTimer(dynamic val) {
    val = val.toString();
    String newTime = getTime(val);
    setState(() {
      _workTime = newTime;
    });
    if (_timer == null) {
      setState(() {
        _currentTime = newTime;
      });
    }
  }

  void setBreakTimer(dynamic val) {
    val = val.toString();
    String newTime = getTime(val);
    setState(() {
      _breakTime = newTime;
    });
  }

  void play() {
    if (_isPaused || !_isPlaying) {
      setState(() {
        Wakelock.enable();
        _timer?.cancel();
        _timer = Timer.periodic(
            const Duration(
              seconds: 1,
            ),
            countdown,);
        _isPaused = false;
        _isPlaying = true;
      });
    }
  }

  void pause() {
    if (!_isPaused && _isPlaying) {
      setState(() {
        Wakelock.disable();
        _timer?.cancel();
        _timer = null;
        _isPaused = true;
        _isPlaying = false;
      });
    } else if (_isPaused && !_isPlaying) {
      play();
    }
  }

  void reset() {
    pause();
    setState(() {
      _timer?.cancel();
      _currentTime = _workTime;
      _isPlaying = false;
      _isPaused = false;
      _isWorking = true;
      _timer = null;
    });
  }

  void countdown(_) async {
    if (_currentTime == '00:00' && _isPlaying) {
      if (_shouldVibrate && _canVibrate) {
        Vibration.vibrate();
      }
      if (_shouldSound) {
        FlutterBeep.beep();
      }
      toggleStatus();
    } else {
      String sec = _currentTime.substring(3);
      String min = _currentTime.substring(0, 2);
      if (sec == '00') {
        String newMin = leftPadding((int.parse(min) - 1).toString());
        String newTime = newMin + ':59';
        setState(() {
          _currentTime = newTime;
        });
      } else {
        String newSec = leftPadding((int.parse(sec) - 1).toString());
        String newTime = min + ':' + newSec;
        setState(() {
          _currentTime = newTime;
        });
      }
    }
  }

  void toggleStatus() {
    if (_isWorking) {
      setState(() {
        _isWorking = false;
        _currentTime = _breakTime;
      });
    } else {
      setState(() {
        _isWorking = true;
        _currentTime = _workTime;
      });
    }
  }

  void toggleVibration(bool val) {
    setState(() {
      _shouldVibrate = val;
    });
  }

  void toggleSound(bool val) {
    setState(() {
      _shouldSound = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Clock(currentTime: _currentTime),
                Label(
                  working: _isWorking,
                  paused: _isPaused,
                  playing: _isPlaying,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Button(
                      title: 'Play',
                      icon: const Icon(Icons.play_arrow_rounded),
                      onPress: play,
                    ),
                    Button(
                        title: 'Pause',
                        icon: const Icon(Icons.pause_rounded),
                        onPress: pause),
                    Button(
                        title: 'Reset',
                        icon: const Icon(Icons.replay_rounded),
                        onPress: reset)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Work Time (min)',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          TimeSelect(
                              selected: int.parse(_workTime.substring(0, 2))
                                  .toString(),
                              onSelect: setWorkTimer),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            'Break Time (min)',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                          TimeSelect(
                              selected: int.parse(_breakTime.substring(0, 2))
                                  .toString(),
                              onSelect: setBreakTimer),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Switch(
                      value: _shouldVibrate,
                      onChanged: toggleVibration,
                      activeColor: Colors.grey,
                    ),
                    Icon(
                      Icons.vibration_rounded,
                      color: _shouldVibrate ? Theme.of(context).primaryColor : Colors.grey,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Switch(
                      value: _shouldSound,
                      onChanged: toggleSound,
                      activeColor: Colors.grey,
                    ),
                    Icon(
                      _shouldSound
                          ? Icons.volume_up_rounded
                          : Icons.volume_mute_rounded,
                      color: _shouldSound ? Theme.of(context).primaryColor : Colors.grey,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
