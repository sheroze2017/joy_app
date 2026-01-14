import 'package:flutter/material.dart';

class AnimatedSnackbar {
  static void showSnackbar({
    required BuildContext context,
    required String message,
    required IconData icon,
    Color backgroundColor = Colors.grey,
    Color textColor = Colors.white,
    double fontSize = 14.0,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context)!;
    late OverlayEntry overlayEntry;
    
    overlayEntry = OverlayEntry(
      builder: (context) => _AnimatedSnackbar(
        message: message,
        icon: icon,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize,
        duration: duration,
        onAnimationComplete: () {
          // Remove overlay entry after animation completes
          overlayEntry.remove();
        },
      ),
    );

    overlay.insert(overlayEntry);
  }
}

class _AnimatedSnackbar extends StatefulWidget {
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final Duration duration;
  final VoidCallback onAnimationComplete;

  const _AnimatedSnackbar({
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.fontSize,
    required this.duration,
    required this.onAnimationComplete,
  });

  @override
  __AnimatedSnackbarState createState() => __AnimatedSnackbarState();
}

class __AnimatedSnackbarState extends State<_AnimatedSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();

    // Animate out after the duration
    Future.delayed(widget.duration, () {
      if (!mounted) {
        widget.onAnimationComplete();
        return;
      }
      
      try {
        // Check if controller is still valid and not disposed
        if (_animationController.status != AnimationStatus.dismissed && 
            _animationController.status != AnimationStatus.reverse) {
          _animationController.reverse().then((_) {
            // Animation complete, remove overlay entry
            if (mounted) {
              widget.onAnimationComplete();
            }
          }).catchError((error) {
            // If reverse fails, still remove the overlay entry
            if (mounted) {
              widget.onAnimationComplete();
            }
          });
        } else {
          // Controller already reversed or disposed, just remove overlay entry
          widget.onAnimationComplete();
        }
      } catch (e) {
        // If any error occurs, still try to remove overlay entry
        widget.onAnimationComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(_animationController),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(widget.icon, color: widget.textColor),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        widget.message,
                        maxLines: 2,
                        style: TextStyle(
                            color: widget.textColor, fontSize: widget.fontSize),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
