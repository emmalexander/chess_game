import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Utility class for SVG assets
class AppSvg {
  /// Base path for SVG assets
  static const String _basePath = 'assets/svg/';

  /// Get an SVG asset as a SvgPicture widget
  /// Falls back to a Material Icon if the SVG asset is not found
  static Widget asset(
    String name, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
    Color? color,
    IconData fallbackIcon = Icons.image,
  }) {
    try {
      return SvgPicture.asset(
        '$_basePath$name',
        width: width,
        height: height,
        fit: fit,
        alignment: alignment,
        colorFilter:
            color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
      );
    } catch (e) {
      // Return a fallback icon if SVG asset is not found
      return Icon(fallbackIcon, size: width ?? 24, color: color);
    }
  }

  /// Map SVG names to fallback Material icons
  // static IconData getFallbackIcon(String svgName) {
  //   final Map<String, IconData> fallbackIcons = {
  //     'slack.svg': Icons.chat_bubble,
  //     'clickup.svg': Icons.check_circle_outline,
  //     'hubspot.svg': Icons.hub,
  //     'gmail.svg': Icons.mail,
  //     'sheets.svg': Icons.table_chart,
  //     'calendar.svg': Icons.calendar_month,
  //     'trello.svg': Icons.view_kanban,
  //     'twitter.svg': Icons.chat,
  //     'zendesk.svg': Icons.headset_mic,
  //     'dropbox.svg': Icons.cloud,
  //     'instagram.svg': Icons.camera_alt,
  //     'shopify.svg': Icons.shopping_bag,
  //     'square.svg': Icons.crop_square,
  //     'flash.svg': Icons.bolt,
  //     'clock.svg': Icons.access_time,
  //     'check_circle.svg': Icons.check_circle,
  //     'error_triangle.svg': Icons.error,
  //     'onedrive.svg': Icons.cloud_circle,
  //     'drive.svg': Icons.cloud_queue,
  //   };

  //   return fallbackIcons[svgName] ?? Icons.image;
  // }
}

/// SVG asset paths for easy reference
class AppSvgAssets {
  // SVG file paths
  static const String logo = 'logo.svg';
  static const String icon = 'icon8.svg';
  static const String onboardingIcon = 'onboarding_icon.svg';
  static const String onboardingImage = 'onboarding_image.svg';
  static const String googleIcon = 'google_icon.svg';
  static const String appleIcon = 'apple_icon.svg';
  static const String emailIcon = 'email_icon.svg';
  static const String chatIcon = 'chat.svg';
  static const String chatColorIcon = 'chat_color.svg';
  static const String bellIcon = 'bell.svg';
  static const String bellColorIcon = 'bell_color.svg';
  static const String bellEmptyIcon = 'bell_empty.svg';
  static const String gridIcon = 'grid.svg';
  static const String gridColorIcon = 'grid_color.svg';
  static const String menuIcon = 'menu.svg';
  static const String chatPlusIcon = 'chat_plus.svg';
  static const String slackIcon = 'slack.svg';
  static const String jiraIcon = 'jira.svg';
  static const String gmailIcon = 'gmail.svg';
  static const String driveIcon = 'drive.svg';
  static const String chatTextIcon = 'chat_text.svg';
  static const String searchIcon = 'search.svg';
  static const String categoryColorIcon = 'category_color.svg';
  static const String categoryIcon = 'category.svg';
  static const String flashIcon = 'flash.svg';
  static const String flashColorIcon = 'flash_color.svg';
  static const String clockIcon = 'clock.svg';
  static const String clockColorIcon = 'clock_color.svg';
  static const String checkCircleIcon = 'check_circle.svg';
  static const String checkCircleColorIcon = 'check_circle_color.svg';
  static const String listIcon = 'list.svg';
  static const String listColorIcon = 'list_color.svg';
  static const String errorTriangleIcon = 'error_triangle.svg';
  static const String errorTriangleColorIcon = 'error_triangle_color.svg';
  static const String gCalendarIcon = 'gcalendar.svg';
  static const String clickUpIcon = 'clickup.svg';
  static const String hubspotIcon = 'hubspot.svg';
  static const String googleSheetsIcon = 'google_sheets.svg';
  static const String chevronRight = 'chevron_right.svg';
  static const String databaseSetting = 'database_setting.svg';
  static const String notificationBell = 'notification_bell.svg';
  static const String paintBrush = 'paint_brush.svg';
  static const String secure = 'secure.svg';
  static const String star = 'star.svg';
  static const String user = 'user.svg';
  static const String chevronArrowLeft = 'chevron_arrow_left.svg';
  static const String arrowLeft = 'arrow_left.svg';
  static const String close = 'close.svg';
  static const String pencil = 'pencil.svg';
  static const String subscriptionPlan = 'subscription_icon.svg';
  static const String redClose = 'red_close.svg';
  static const String document = 'document.svg';
  static const String help = 'help.svg';
  static const String internet = 'internet.svg';
  static const String logout = 'logout.svg';
  static const String questionMarkSquare = 'question_mark_square.svg';
  static const String appsCategories = 'apps_categories.svg';
  static const String appsCategoriesFilled = 'apps_categories_filled.svg';
  static const String powerOutlet = 'power_outlet.svg';
  static const String powerOutletFilled = 'power_outlet_filled.svg';
  static const String onlineIcon = 'check_circle.svg';
  static const String dropBox = 'drop_box.svg';
  static const String github = 'github.svg';
  static const String googleDocs = 'google_docs_icon.svg';
  static const String googleSlides = 'google_slides_icon.svg';
  static const String mailChimp = 'mailchimp.svg';
  static const String monday = 'monday_icon.svg';
  static const String notion = 'notion.svg';
  static const String outlook = 'outlook.svg';
  static const String reddit = 'reddit_icon.svg';
  static const String stripe = 'stripe.svg';
  static const String surveyMonkey = 'survey_monkey.svg';
  static const String youtube = 'youtube.svg';
  static const String zendesk = 'zendesk.svg';
  static const String counterIcon = 'counter.svg';
  static const String deleteIcon = 'delete.svg';
  static const String editIcon = 'edit.svg';
  static const String newChat = 'new_chat.svg';
  static const String frame = 'frame.svg';
  static const String userIcon = 'user_icon.svg';
  static const String businessIcon = 'company_icon.svg';
  static const String apify = 'apify-icon.svg';
  static const String arxiv = 'arxiv-icon.svg';
  static const String calcom = 'calcom-logo.svg';
  static const String calendly = 'calendly-icon.svg';
  static const String confluence = 'confluence-icon.svg';
  static const String discord = 'discord-icon.svg';
  static const String duckDuckGo = 'duckduckgo-icon.svg';
  static const String firecrawl = 'firecrawl-icon.svg';
  static const String googleForm = 'google-form-icon.svg';
  static const String linear = 'linear-logo-colored.svg';
  static const String pubmed = 'pubmed-icon.svg';
  static const String serpapi = 'serpapi.svg';
  static const String todoist = 'todoist-logo.svg';
  static const String twilio = 'twilio-icon.svg';
  static const String wikipedia = 'wikipedia-icon.svg';
  static const String zoom = 'zoom-icon.svg';
  static const String x = 'x-logo.svg';
  static const String yFinance = 'yahoo-finance-logo-colored.svg';
  static const String history = 'counter_clockwise.svg';
  static const String check = 'check.svg';
  static const String check1 = 'check-1.svg';
  static const String backofficeIcon = 'backoffice-icon-new.svg';
  static const String loadingCircle = 'loading-circle.svg';
  static const String removeCircle = 'remove-circle.svg';
  static const String infoCircle = 'info-circle.svg';
  static const String errorBadge = 'error-badge.svg';
  static const String refreshIcon = 'refresh-icon.svg';
  static const String giftOutlined = 'gift.svg';
  static const String giftFilled = 'gift-filled.svg';
  static const String sendFilled = 'send.svg';
  static const String sendOutlined = 'send-outlined.svg';
  static const String trash = 'trash.svg';
  static const String infoFilled = 'info-filled.svg';

  // Activity service icons
  static const String trelloIcon = 'trello.svg';
  static const String clickupIcon = 'clickup.svg';
}

/// Example usage:
/// ```dart
/// AppSvg.asset(AppSvgAssets.logo, width: 24, height: 24, color: Colors.blue)
/// ```
