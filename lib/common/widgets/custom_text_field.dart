import 'package:get_me_a_tutor/import_export.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final IconData? prefixIcon;
  final bool isPassword;
  final String? Function(String?)? validator;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.prefixIcon,
    this.isPassword = false,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword && _obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: GlobalVariables.primaryTextColor),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: GlobalVariables.primaryTextColor)
            : null,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: GlobalVariables.primaryTextColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.69),
          borderSide: BorderSide(color: GlobalVariables.appGreenLight, width: 0.77),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.69),
          borderSide: BorderSide(
            color: GlobalVariables.appGreenLight,
            width: 1.2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.69),
          borderSide: BorderSide(
            color: GlobalVariables.appGreenLight,
            width: 1.2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator:widget.validator ?? (val) {
        if (val == null || val.isEmpty) {
          return 'Enter your ${widget.hintText}';
        }
        return null;
      },
      maxLines: widget.maxLines,
    );
  }
}
