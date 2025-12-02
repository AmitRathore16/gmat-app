import 'package:get_me_a_tutor/import_export.dart';
class GlobalVariables{
  static const backgroundColor = Colors.white;
  static const primaryTextColor = Color(0xFF00A63E);
  static const secondaryTextColor = Color(0xB200A63E);
  //static const String baseUrl = 'http://192.168.2.47:5001';
  static const String baseUrl = 'http://10.0.2.2:5001';
// Colors
  static const Color appGreenLight = Color(0xFF00C950);
  static const Color appGreenDark  = Color(0xFF00A63E);

// Gradient
  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      appGreenLight,
      appGreenDark,
    ],
  );
}