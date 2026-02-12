import 'package:get_me_a_tutor/import_export.dart';

/// Global design tokens and configuration used across the app.
///
/// ❗️Only presentation values should live here – no business logic.
class GlobalVariables {
  /// Core colors - Modern Light Theme
  static const Color backgroundColor = Color(0xFFFAFBFC);
  static const Color surfaceColor = Colors.white;
  static const Color primaryTextColor = Color(0xFF0F172A);
  static const Color secondaryTextColor = Color(0xFF64748B);

  /// Accent colors - Vibrant yet professional
  static const Color primaryColor = Color(0xFF3B82F6); // Bright Blue
  static const Color primarySoft = Color(0xFFDEEAFE);
  static const Color successColor = Color(0xFF10B981);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color dangerColor = Color(0xFFEF4444);

  /// Legacy name kept for existing usage (acts as primaryColor).
  static const Color selectedColor = primaryColor;

  /// Backgrounds - Translucent and layered
  static const Color greyBackgroundColor = Color(0xFFF1F5F9);
  static const Color selectBackgroundColor = Color(0xFFF8FAFC);
  static const Color cardBackgroundColor = Colors.white;

  /// Translucent overlays
  static Color translucentWhite = Colors.white.withOpacity(0.85);
  static Color translucentPrimary = primaryColor.withOpacity(0.08);
  static Color translucentGrey = const Color(0xFF64748B).withOpacity(0.06);

  /// Elevation shadows - Soft and modern
  static const List<BoxShadow> softCardShadow = [
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 20,
      offset: Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: Color(0x04000000),
      blurRadius: 8,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: Color(0x06000000),
      blurRadius: 12,
      offset: Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 24,
      offset: Offset(0, 8),
      spreadRadius: -2,
    ),
  ];

  /// Layout
  static const double defaultRadius = 16;
  static const double smallRadius = 12;
  static const double largeRadius = 20;
  static const double cardPadding = 20;
  static const double screenPadding = 16;

  /// API / external configuration
  static const String baseUrl2 = 'http://10.0.2.2:5001';
  static const String baseUrl1 = 'http://localhost:5001';
  static const String baseUrl = 'https://getmeatutor-server.onrender.com';
  static const String razorpayKeyId = 'rzp_test_RoFhlvQ5GI48tx';
}