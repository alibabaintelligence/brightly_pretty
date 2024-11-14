import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedbackPopup extends StatelessWidget {
  final String message;
  final IconData iconData;
  final Color backgroundColor;

  const FeedbackPopup({
    super.key,
    required this.message,
    required this.iconData,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          // BoxShadow(
          //   color: Colors.black.withOpacity(0.3),
          //   blurRadius: 5,
          //   offset: const Offset(0, 3),
          // ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            iconData,
            size: 26,
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

void showFeedbackPopup(BuildContext context, String message, IconData iconData,
    Color bgColor, String soundAsset) {
  final overlay = Overlay.of(context);

  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: FeedbackPopup(
              message: message,
              iconData: iconData,
              backgroundColor: bgColor,
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}
