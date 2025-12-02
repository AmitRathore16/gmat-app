import 'package:get_me_a_tutor/import_export.dart';

class CustomDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String hintText;
  final Function(String?) onChanged;

  const CustomDropdown({
    super.key,
    this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: GlobalVariables.primaryTextColor),
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
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (val) {
        if (val == null || val.isEmpty) {
          return 'Select your $hintText';
        }
        return null;
      },
    );
  }
}

