import 'package:get_me_a_tutor/import_export.dart';

class CustomDropdown<T> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final String hintText;
  final String Function(T) itemLabel;
  final void Function(T?) onChanged;
  final IconData? prefixIcon;
  final String? Function(T?)? validator;

  const CustomDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.itemLabel,
    required this.onChanged,
    this.prefixIcon,
    this.validator,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
        boxShadow: _isFocused
            ? [
          BoxShadow(
            color: GlobalVariables.primaryColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ]
            : [],
      ),
      child: DropdownButtonFormField<T>(
        value: widget.value,
        onChanged: widget.onChanged,
        validator: widget.validator ??
                (val) {
              if (val == null) {
                return 'Select ${widget.hintText}';
              }
              return null;
            },
        icon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: _isFocused
              ? GlobalVariables.primaryColor
              : GlobalVariables.secondaryTextColor.withOpacity(0.6),
          size: 22,
        ),
        dropdownColor: GlobalVariables.surfaceColor,
        style: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: GlobalVariables.primaryTextColor,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: GoogleFonts.inter(
            color: GlobalVariables.secondaryTextColor.withOpacity(0.6),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          filled: true,
          fillColor: _isFocused
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(GlobalVariables.defaultRadius),
            borderSide: BorderSide.none,
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
            borderSide: BorderSide.none,
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
        items: widget.items
            .map(
              (item) => DropdownMenuItem<T>(
            value: item,
            child: Text(
              widget.itemLabel(item),
              style: GoogleFonts.inter(
                color: GlobalVariables.primaryTextColor,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}