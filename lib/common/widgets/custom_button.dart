import 'package:get_me_a_tutor/import_export.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isDestructive;
  final bool isSmall;

  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.isDestructive = false,
    this.isSmall = false,
  });

  Color get _resolvedBackground {
    if (isOutlined) return Colors.transparent;
    if (isDestructive) return GlobalVariables.dangerColor;
    return backgroundColor ?? GlobalVariables.primaryColor;
  }

  Color get _resolvedTextColor {
    if (isOutlined) {
      if (isDestructive) return GlobalVariables.dangerColor;
      return textColor ?? GlobalVariables.primaryColor;
    }
    return textColor ?? Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 393;
    final buttonHeight = (isSmall ? 44 : 56) * scaleFactor.clamp(0.9, 1.1);

    return SizedBox(
      width: double.infinity,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _resolvedBackground,
          foregroundColor: _resolvedTextColor,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
            side: isOutlined
                ? BorderSide(
                    color: isDestructive
                        ? GlobalVariables.dangerColor.withOpacity(0.7)
                        : (backgroundColor ?? GlobalVariables.primaryColor)
                            .withOpacity(0.9),
                    width: 1.6,
                  )
                : BorderSide.none,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: DefaultTextStyle(
          style: GoogleFonts.inter(
            fontSize: (isSmall ? 14 : 16) * scaleFactor.clamp(0.9, 1.1),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
            color: _resolvedTextColor,
          ),
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}