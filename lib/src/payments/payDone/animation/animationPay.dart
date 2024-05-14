import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StepperIndicatorUser extends StatefulWidget {
  final bool isActivePath;
  final bool isLast;
  StepperIndicatorUser({
    Key? key,
    required this.isActivePath,
    required this.isLast,
  }) : super(key: key);

  @override
  State<StepperIndicatorUser> createState() => _StepperIndicatorUserState();
}

class _StepperIndicatorUserState extends State<StepperIndicatorUser> {
  bool isOpacity = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isOpacity = !isOpacity;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // circle
        AnimatedOpacity(
          duration:
              Duration(milliseconds: 1500), // Adjust opacity animation duration
          opacity: isOpacity ? 1.0 : 0.0,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isActivePath
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
            ),
          ),
        ),
        // path

        Visibility(
          visible: !widget.isLast,
          child: AnimatedOpacity(
            duration: Duration(
                milliseconds: 1500), // Adjust opacity animation duration
            opacity: isOpacity ? 1.0 : 0.0,
            child: Container(
              width: 10,
              height: widget.isActivePath ? 100 : 20,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: widget.isActivePath ? 0.0 : 1.0,
                  end: widget.isActivePath ? 1.0 : 0.0,
                ),
                duration:
                    Duration(milliseconds: 4000), // Adjust animation duration
                builder: (context, value, child) {
                  return CustomPaint(
                    painter: PathPainter(
                      progress: value,
                      isActive: widget.isActivePath,
                      context: context,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class PathPainter extends CustomPainter {
  final double progress;
  final bool isActive;
  final BuildContext context;

  PathPainter({
    required this.isActive,
    required this.context,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final double segmentHeight =
        size.height / 10; // Divide path into 10 segments
    final Color startColor = Colors.grey;
    final Color endColor = Theme.of(context).colorScheme.primary;

    for (int i = 0; i < 10; i++) {
      if (isActive) {
        final double colorProgress = progress;
        final Color currentColor = Color.lerp(startColor, endColor, i / 10)!;
        final Color finalColor =
            Color.lerp(currentColor, endColor, colorProgress)!;

        paint.color = finalColor;
      } else {
        paint.color = Colors.grey.withOpacity(1.0 - progress);
      }

      final Offset startPoint = Offset(size.width / 2, i * segmentHeight);
      final Offset endPoint = Offset(size.width / 2, (i + 1) * segmentHeight);
      canvas.drawLine(startPoint, endPoint, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
