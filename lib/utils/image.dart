import 'package:flutter/material.dart';

/// Utility class for image assets
class AppImageAssets {
  // Onboarding images
  static const String onboardingImage = 'assets/images/onboarding_image.png';
  static const String onlineIcon = 'assets/images/online.png';
  static const String inviteImage = 'assets/images/invite_image.png';
  static const String noConnectedApps = 'assets/images/no_connected_apps.png';
  static const String inviteFriendImage =
      'assets/images/invite_friend_image.png';
  static const String noChatHistory = 'assets/images/no_chat_history.png';
  static const avatar = 'assets/images/online.png';
  static const avatar1 = 'assets/images/avatar-1.png';
  static const avatar2 = 'assets/images/avatar-2.png';
  static const avatar3 = 'assets/images/avatar-3.png';
  static const avatar4 = 'assets/images/avatar-4.png';
  static const avatar5 = 'assets/images/avatar-5.png';
  static const avatar6 = 'assets/images/avatar-6.png';
  static const avatar7 = 'assets/images/avatar-7.png';
  static const avatar8 = 'assets/images/avatar-8.png';
  static const avatar9 = 'assets/images/avatar-9.png';
  static const loadingCircle = 'assets/images/loading-circle.png';
  static const loadingCircleDark = 'assets/images/loading-circle-dark.png';
  static const activityComingSoon = 'assets/images/activity-coming-soon.png';
  static const emptyInvoice = 'assets/images/empty-invoice.png';

  // Add more image assets here as needed
}

/// Widget for displaying images with consistent styling and error handling
class AppImage extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Color? color;
  final Widget? errorWidget;
  final Widget? loadingWidget;

  const AppImage.asset(
    this.path, {
    super.key,
    this.width,
    this.height,
    this.fit,
    this.color,
    this.errorWidget,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.grey[200],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            );
      },
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return loadingWidget ??
            Container(
              width: width,
              height: height,
              color: Colors.transparent,
              child: const Center(child: CircularProgressIndicator()),
            );
      },
    );
  }
}
