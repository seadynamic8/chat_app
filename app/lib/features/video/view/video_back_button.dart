import 'package:flutter/material.dart';

class VideoBackButton extends StatelessWidget {
  const VideoBackButton({
    super.key,
    required this.width,
    required this.onPressEndCall,
  });

  final double width;
  final VoidCallback onPressEndCall;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: IconButton(
        onPressed: onPressEndCall,
        color: Colors.white.withAlpha(200),
        icon: const Icon(
          Icons.arrow_back,
          shadows: [
            Shadow(color: Colors.black, blurRadius: 10),
          ],
        ),
      ),
    );
  }
}
