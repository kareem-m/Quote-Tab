import 'dart:async';
import 'package:flutter/material.dart';

class CircularCountdownTimer extends StatefulWidget {
  final Duration duration;
  final Color color;

  const CircularCountdownTimer({
    super.key,
    required this.duration,
    this.color = Colors.white,
  });

  @override
  State<CircularCountdownTimer> createState() => _CircularCountdownTimerState();
}

class _CircularCountdownTimerState extends State<CircularCountdownTimer>
    with SingleTickerProviderStateMixin {
      
  late AnimationController _controller;
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration.inSeconds;

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..forward();

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _remainingSeconds = widget.duration.inSeconds;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
          timer.cancel();
          return;
        }
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _controller.reset();
          _controller.forward();
          _remainingSeconds = widget.duration.inSeconds -1;
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        width: 20,
        height: 20,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CircularProgressIndicator(
              value: _controller.value, 
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(widget.color),
            );
          },
        ),
      ),
    );
  }
}