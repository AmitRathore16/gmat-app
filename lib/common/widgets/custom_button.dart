import 'package:get_me_a_tutor/import_export.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isFilled;
  const CustomButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.isFilled,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = (146 / 393) * screenWidth;
    final buttonHeight = 54.0;
    
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isFilled ? GlobalVariables.greenGradient : null,
          borderRadius: BorderRadius.circular(30),
        ),
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.transparent,
            side: const BorderSide(
              color: GlobalVariables.appGreenDark,
              width: 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
          ),
        child: SecondaryText(
          text: text,
          size: 20,
          color: isFilled ? Colors.white : GlobalVariables.appGreenDark,
        ),
      ),
      ),
    );
  }
}