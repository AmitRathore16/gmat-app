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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
          boxShadow: _isFocused ? [
            BoxShadow(
              color: GlobalVariables.primaryColor.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ] : [],
        ),
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
            height: 1.4,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.inter(
              color: GlobalVariables.secondaryTextColor.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: widget.readonly
                ? GlobalVariables.greyBackgroundColor.withOpacity(0.5)
                : _isFocused
                ? GlobalVariables.surfaceColor
                : GlobalVariables.greyBackgroundColor.withOpacity(0.4),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
              padding: const EdgeInsets.only(left: 16, right: 12),
              child: Icon(
                widget.prefixIcon,
                color: _isFocused
                    ? GlobalVariables.primaryColor
                    : GlobalVariables.secondaryTextColor.withOpacity(0.5),
                size: 21,
              ),
            )
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: GlobalVariables.secondaryTextColor.withOpacity(0.6),
                size: 21,
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
                color: GlobalVariables.greyBackgroundColor,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
              borderSide: BorderSide(
                color: GlobalVariables.primaryColor,
                width: 2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
              borderSide: BorderSide(
                color: Colors.transparent,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
              borderSide: BorderSide(
                color: GlobalVariables.dangerColor.withOpacity(0.6),
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
              borderSide: BorderSide(
                color: GlobalVariables.dangerColor,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.prefixIcon != null ? 0 : 18,
              vertical: 16,
            ),
          ),
          validator: widget.validator ??
                  (val) {
                if (val == null || val.isEmpty) {
                  return 'Enter your ${widget.hintText}';
                }
                return null;
              },
          maxLines: widget.maxLines,
        ),
      ),
    );
  }
}