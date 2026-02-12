import 'package:get_me_a_tutor/import_export.dart';

class ParentProfileUpdateScreen extends StatefulWidget {
  static const String routeName = '/parentProfileUpdate';
  const ParentProfileUpdateScreen({super.key});

  @override
  State<ParentProfileUpdateScreen> createState() =>
      _ParentProfileUpdateScreenState();
}

class _ParentProfileUpdateScreenState extends State<ParentProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cityCtrl = TextEditingController();

  final streetCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    final parent = Provider.of<ParentProfileProvider>(
      context,
      listen: false,
    ).parent!;

    nameCtrl.text = parent.name;
    phoneCtrl.text = parent.phone ?? '';
    cityCtrl.text = parent.city ?? '';

    streetCtrl.text = parent.address?.street ?? '';
    stateCtrl.text = parent.address?.state ?? '';
    pincodeCtrl.text = parent.address?.pincode ?? '';
  }

  void submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider =
    Provider.of<ParentProfileProvider>(context, listen: false);

    final success = await provider.updateParentProfile(
      context: context,
      body: {
        'name': nameCtrl.text.trim(),
        'phone': phoneCtrl.text.trim(),
        'city': cityCtrl.text.trim(),
        'address': {
          'street': streetCtrl.text.trim(),
          'city': cityCtrl.text.trim(),
          'state': stateCtrl.text.trim(),
          'pincode': pincodeCtrl.text.trim(),
        },
      },
    );

    if (success) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: GlobalVariables.primaryTextColor,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 36, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ───────── AVATAR ─────────
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: GlobalVariables.selectedColor.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: GlobalVariables.selectedColor.withOpacity(0.15),
                      child: Icon(
                        Icons.person,
                        size: 42,
                        color: GlobalVariables.selectedColor,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                _sectionHeader('Personal Information'),
                const SizedBox(height: 16),

                _label('Full Name'),
                CustomTextField(
                  controller: nameCtrl,
                  hintText: 'Enter your name',
                  prefixIcon: Icons.person,
                ),

                _gap(),
                _label('Phone Number'),
                CustomTextField(
                  controller: phoneCtrl,
                  hintText: 'Enter phone number',
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_rounded,
                ),

                _gap(),
                _label('City'),
                CustomTextField(
                  controller: cityCtrl,
                  hintText: 'City',
                  prefixIcon: Icons.location_city_rounded,
                ),

                const SizedBox(height: 32),

                _sectionHeader('Address Details'),
                const SizedBox(height: 16),

                _label('Street Address'),
                CustomTextField(
                  controller: streetCtrl,
                  hintText: 'Street address',
                  prefixIcon: Icons.location_on,
                ),

                _gap(),
                _label('State'),
                CustomTextField(
                  controller: stateCtrl,
                  hintText: 'State',
                  prefixIcon: Icons.map,
                ),

                _gap(),
                _label('Pincode'),
                CustomTextField(
                  controller: pincodeCtrl,
                  hintText: 'Pincode',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.pin_drop,
                ),

                const SizedBox(height: 32),

                Consumer<ParentProfileProvider>(
                  builder: (context, provider, _) {
                    if (provider.isLoading) {
                      return const Center(child: Loader());
                    }
                    return CustomButton(
                      text: 'Save Changes',
                      onTap: submit,
                    );
                  },
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ───────── HELPERS ─────────
  Widget _sectionHeader(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            GlobalVariables.selectedColor.withOpacity(0.1),
            GlobalVariables.selectedColor.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: GlobalVariables.selectedColor,
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade700,
      ),
    ),
  );

  Widget _gap() => const SizedBox(height: 20);
}