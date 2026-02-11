import 'package:get_me_a_tutor/import_export.dart';

/// Global design tokens and configuration used across the app.
///
/// ❗️Only presentation values should live here – no business logic.
class GlobalVariables {
  /// Core colors
  static const Color backgroundColor = Color(0xFFF7F9FC);
  static const Color surfaceColor = Colors.white;
  static const Color primaryTextColor = Color(0xFF111827);
  static const Color secondaryTextColor = Color(0xFF6B7280);

  /// Accent colors
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color primarySoft = Color(0xFFE0ECFF);
  static const Color successColor = Color(0xFF16A34A);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color dangerColor = Color(0xFFDC2626);

  /// Legacy name kept for existing usage (acts as primaryColor).
  static const Color selectedColor = primaryColor;

  /// Backgrounds
  static const Color greyBackgroundColor = Color(0xFFF3F4F6);
  static const Color selectBackgroundColor = Color(0xFFF6F6EA);

  /// Elevation shadows
  static const List<BoxShadow> softCardShadow = [
    BoxShadow(
      color: Color(0x1418273A),
      blurRadius: 18,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: Color(0x0F111827),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];

  /// Layout
  static const double defaultRadius = 18;
  static const double smallRadius = 12;
  static const double cardPadding = 20;

  /// API / external configuration
  static const String baseUrl2 = 'http://10.0.2.2:5001';
  static const String baseUrl = 'http://localhost:5001';
  static const String baseUrl1 = 'https://getmeatutor-server.onrender.com';
  static const String razorpayKeyId = 'rzp_test_RoFhlvQ5GI48tx';
}
