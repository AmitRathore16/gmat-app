import 'package:get_me_a_tutor/import_export.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final bool readonly;
  final IconData? prefixIcon;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.prefixIcon,
    this.readonly = false,
    this.isPassword = false,
    this.validator,
    this.keyboardType,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() => _isFocused = hasFocus);
      },
      child: TextFormField(
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          readOnly: widget.readonly,
          obscureText: widget.isPassword && _obscureText,
          cursorColor: GlobalVariables.primaryColor,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: GlobalVariables.primaryTextColor,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.inter(
              color: Colors.grey.shade500,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor:
                widget.readonly ? Colors.grey.shade100 : GlobalVariables.surfaceColor,
            prefixIcon: widget.prefixIcon != null
                ? Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Icon(
                widget.prefixIcon,
                color: _isFocused
                    ? GlobalVariables.primaryColor
                    : Colors.grey.shade500,
                size: 22,
              ),
            )
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: Colors.grey.shade600,
                size: 22,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
              borderSide: BorderSide(
                color: GlobalVariables.primaryColor,
                width: 1.8,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
              borderSide: BorderSide(
                color: Colors.grey.shade300,
                width: 1.2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
              borderSide: BorderSide(
                color: GlobalVariables.dangerColor,
                width: 1.4,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
              borderSide: BorderSide(
                color: GlobalVariables.dangerColor,
                width: 1.8,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.prefixIcon != null ? 0 : 16,
              vertical: 16,
            ),
          ),
          validator: widget.validator ?? (val) {
            if (val == null || val.isEmpty) {
              return 'Enter your ${widget.hintText}';
            }
            return null;
          },
          maxLines: widget.maxLines,
        ),
    );
  }
}