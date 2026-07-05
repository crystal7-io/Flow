import 'dart:async';
import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

enum WaveStage { forward, reverseAndFill, done }

class WaveText extends StatefulWidget {
  const WaveText(this.text, {super.key, this.delay = Duration.zero});

  final String text;
  final Duration delay;

  @override
  State<WaveText> createState() => _WaveTextState();
}

class _WaveTextState extends State<WaveText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final WaveStage _currentStage = WaveStage.forward;
  // bool _isDelaying = true;
  Timer? _delayTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));

    // if (widget.delay == Duration.zero) {
    //   _isDelaying = false;
    //   _controller.forward();
    // } else {
    //   _delayTimer = Timer(widget.delay, () {
    //     if (mounted) {
    //       setState(() => _isDelaying = false);
    //       _controller.forward();
    //     }
    //   });
    // }
  }

  @override
  void dispose() {
    _delayTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double cutoff = 1.6;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return RichText(
          text: TextSpan(
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            children: widget.text.split('').mapIndexed((index, char) {
              final double totalLetters = widget.text.length.toDouble();
              final double phase = (index / totalLetters) * math.pi;

              final double startArc = -cutoff;
              final double endArc = math.pi + cutoff;
              final double animationArc = lerpDouble(startArc, endArc, _controller.value);

              final double distance = (animationArc - phase).abs();

              double waveIntensity = 0.0;
              if (distance < cutoff) {
                waveIntensity = math.cos((distance / cutoff) * (math.pi / 2));
              }

              double intensity = 0.0;

              if (_currentStage == WaveStage.done) {
                intensity = 1.0;
              } else if (_currentStage == WaveStage.reverseAndFill) {
                if (animationArc <= phase) {
                  intensity = math.max(waveIntensity, 1.0);
                } else {
                  intensity = waveIntensity;
                }
              } else {
                intensity = waveIntensity;
              }

              final double currentWeight = lerpDouble(600.0, 1000.0, intensity);

              return TextSpan(
                text: char,
                style: TextStyle(
                  height: 1,

                  fontSize: 56,
                  fontFamily: "Google Sans Flex",
                  fontVariations: [
                    FontVariation.weight(currentWeight),
                    FontVariation('ROND', 100),
                    FontVariation.width(30),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  double lerpDouble(double a, double b, double t) => a + (b - a) * t;
}
