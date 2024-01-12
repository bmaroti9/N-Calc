import 'package:flutter/material.dart';

Widget nothingtext(String text, double size, {color = Colors.white, align = TextAlign.start}) {
  return Text(
    text,
    textAlign: align,
    style: TextStyle(
      color: color,
      fontFamily: 'Nothing',
      fontSize: size,
    ),
  );
}

String combText(String text) {
  String hihi = text.replaceAll("×", "*");
  return hihi;
}

bool Numeric(String str) {
  return double.tryParse(str) != null;
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Widget numberButton(String character, Function addChar,
    [Color color = const Color(0xff1A1A1A), Color textColor = Colors.white]) {
  return CoreButton(text: character, color: color, text_color: textColor, onTap: addChar,);
}

class CoreButton extends StatefulWidget {
  final String text;
  final Function onTap;
  final Color color;
  final Color text_color;

  const CoreButton({required this.text, required this.onTap, required this.color, required this.text_color});

  @override
  _CoreButtonState createState() => _CoreButtonState();
}

class _CoreButtonState extends State<CoreButton>
    with SingleTickerProviderStateMixin {
  static const clickAnimationDurationMillis = 50;

  double _scaleTransformValue = 1;

  // needed for the "click" tap effect
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: clickAnimationDurationMillis),
      lowerBound: 0.0,
      upperBound: 0.2,
    )..addListener(() {
      setState(() => _scaleTransformValue = 1 - animationController.value);
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _shrinkButtonSize() {
    animationController.forward();
  }

  void _restoreButtonSize() {
    Future.delayed(
      const Duration(milliseconds: clickAnimationDurationMillis),
          () => animationController.reverse(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.text);
        _shrinkButtonSize();
        _restoreButtonSize();
      },
      onTapDown: (_) => _shrinkButtonSize(),
      onTapCancel: _restoreButtonSize,
      child: Transform.scale(
        scale: _scaleTransformValue,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(100)
          ),
          child: Center(child: nothingtext(widget.text, 30, color: widget.text_color)),
        )
      ),
    );
  }
}