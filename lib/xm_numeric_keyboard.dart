import 'package:flutter/material.dart';

typedef XMKeyboardTapCallback = void Function(String text);

class XMNumericKeyboard extends StatefulWidget {
  const XMNumericKeyboard({
    super.key,
    required this.onKeyboardTap,
    this.textColor = Colors.black,
    this.deleteButtonText = '删除',
    this.confirmButtonText = '确定',
    this.showConfirm = false,
    this.confirmTextStyle,
    this.mainAxisAlignment = MainAxisAlignment.spaceEvenly,
    this.buttonColor = Colors.white,
    this.buttonRadius = 12.0,
    this.buttonPadding = const EdgeInsets.all(8.0),
    this.deleteIcon = const Icon(Icons.backspace, size: 24),
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeOutCubic,
    this.isVisible = true,
  });

  final XMKeyboardTapCallback onKeyboardTap;
  final Color textColor;
  final String deleteButtonText;
  final String confirmButtonText;
  final bool showConfirm;
  final TextStyle? confirmTextStyle;
  final MainAxisAlignment mainAxisAlignment;
  final Color buttonColor;
  final double buttonRadius;
  final EdgeInsetsGeometry buttonPadding;
  final Widget deleteIcon;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool isVisible;

  @override
  State<XMNumericKeyboard> createState() => _XMNumericKeyboardState();
}

class _XMNumericKeyboardState extends State<XMNumericKeyboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );

    if (widget.isVisible) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(covariant XMNumericKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 每个按键的宽度
  double get buttonWidth {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth / 3 - 16;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 200),
          child: Opacity(
            opacity: _animation.value,
            child: child,
          ),
        );
      },
      child: SafeArea(
        top: false,
        child: Container(
          color: Colors.grey[100],
          padding: widget.buttonPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildRow(['1', '2', '3']),
              buildRow(['4', '5', '6']),
              buildRow(['7', '8', '9']),
              buildBottomRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      children: buttons
          .map((buttonText) => buildButton(
                text: buttonText,
                onTap: () => widget.onKeyboardTap(buttonText),
              ))
          .toList(),
    );
  }

  Widget buildBottomRow() {
    final buttons = <Widget>[];

    if (widget.showConfirm) {
      buttons.add(buildConfirmButton());
    } else {
      buttons.add(buildButton(
        text: '0',
        onTap: () => widget.onKeyboardTap('0'),
      ));
    }

    buttons.add(buildButton(
      text: '0',
      onTap: () => widget.onKeyboardTap('0'),
    ));

    buttons.add(buildDeleteButton());

    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      children: buttons,
    );
  }

  Widget buildButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return Container(
      width: buttonWidth,
      height: 50,
      margin: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          foregroundColor: widget.textColor,
          backgroundColor: widget.buttonColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.buttonRadius),
            side: BorderSide(color: Colors.grey[300]!, width: 0.5),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
    );
  }

  Widget buildDeleteButton() {
    return Container(
      width: buttonWidth,
      height: 50,
      margin: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () => widget.onKeyboardTap('delete'),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.grey,
          backgroundColor: widget.buttonColor,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.buttonRadius),
            side: BorderSide(color: Colors.grey[300]!, width: 0.5),
          ),
        ),
        child: widget.deleteIcon,
      ),
    );
  }

  Widget buildConfirmButton() {
    return Container(
      width: buttonWidth,
      height: 50,
      margin: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () => widget.onKeyboardTap(widget.confirmButtonText),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.buttonRadius),
          ),
        ),
        child: Text(
          widget.confirmButtonText,
          style: widget.confirmTextStyle ??
              const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
