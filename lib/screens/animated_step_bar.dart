import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:eye_prescription/utils/constants/colors.dart';

class AnimatedStepBar extends StatefulWidget {
  const AnimatedStepBar({super.key});

  @override
  State<AnimatedStepBar> createState() => _AnimatedStepBarState();
}

class _AnimatedStepBarState extends State<AnimatedStepBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat(); // loop animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return StepProgressIndicator(
          totalSteps: 2,
          currentStep: 1,
          size: 8,
          roundedEdges: const Radius.circular(4),
          unselectedColor: TColors.borderDark,

          // 🎨 Animate the current step color
          customColor: (index) {
            if (index == 0) {
              final t = _controller.value;
              return Color.lerp(
                TColors.primary,
                Color.fromARGB(255, 59, 47, 229),
                (t * 2) % 1,
              )!;
            }
            return TColors.borderDark;
          },
        );
      },
    );
  }
}
