import 'package:get_me_a_tutor/import_export.dart';

class InstituteProfileUpdateScreen extends StatefulWidget {
  const InstituteProfileUpdateScreen({super.key});

  @override
  State<InstituteProfileUpdateScreen> createState() =>
      _InstituteProfileUpdateScreenState();
}

class _InstituteProfileUpdateScreenState
    extends State<InstituteProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  // dropdown
  String? institutionType;
  final institutionTypes = [
    'School',
    'College',
    'Coaching Institute',
    'Training Center',
    'Online Academy',
  ];

  // controllers
  final nameCtrl = TextEditingController();
  final aboutCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();

  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final stateCtrl = TextEditingController();
  final pincodeCtrl = TextEditingController();

  // media
  File? newLogo;
  bool removeLogo = false;

  final List<String> existingGalleryImages = [];
  final List<File> newGalleryImages = [];

  @override
  void initState() {
    super.initState();

    final institute =
    Provider.of<InstituteProvider>(context, listen: false).institution!;

    nameCtrl.text = institute.institutionName;
    institutionType = institute.institutionType;
    aboutCtrl.text = institute.about ?? '';
    phoneCtrl.text = institute.phone ?? '';
    websiteCtrl.text = institute.website ?? '';

    streetCtrl.text = institute.address?.street ?? '';
    cityCtrl.text = institute.address?.city ?? '';
    stateCtrl.text = institute.address?.state ?? '';
    pincodeCtrl.text = institute.address?.pincode ?? '';

    existingGalleryImages.addAll(institute.galleryImages);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    aboutCtrl.dispose();
    phoneCtrl.dispose();
    websiteCtrl.dispose();
    streetCtrl.dispose();
    cityCtrl.dispose();
    stateCtrl.dispose();
    pincodeCtrl.dispose();
    super.dispose();
  }

  // ───────── SUBMIT ─────────
  void submit() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<InstituteProvider>(context, listen: false);

    final body = {
      'institutionName': nameCtrl.text.trim(),
      'institutionType': institutionType,
      'about': aboutCtrl.text.trim(),
      'phone': phoneCtrl.text.trim(),
      'website': websiteCtrl.text.trim(),
      'address': {
        'street': streetCtrl.text.trim(),
        'city': cityCtrl.text.trim(),
        'state': stateCtrl.text.trim(),
        'pincode': pincodeCtrl.text.trim(),
      },
      'galleryImages': existingGalleryImages,
    };

    final success = await provider.updateInstituteProfile(
      context: context,
      body: body,
      logo: newLogo,
      galleryImages: newGalleryImages,
    );

    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final institute =
    Provider.of<InstituteProvider>(context, listen: false).institution!;

    ImageProvider? logoImage() {
      if (newLogo != null) return FileImage(newLogo!);
      if (removeLogo) return null;
      if (institute.logo != null && institute.logo!.isNotEmpty) {
        return NetworkImage(institute.logo!);
      }
      return null;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const PrimaryText(text: 'Edit Profile', size: 22),
        backgroundColor: Colors.white,
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
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ───────── LOGO ─────────
                      Center(
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final files =
                                await pickImages(type: FileType.image);
                                if (files.isNotEmpty) {
                                  setState(() {
                                    newLogo = files.first;
                                    removeLogo = false;
                                  });
                                }
                              },
                              child: Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: GlobalVariables.greyBackgroundColor,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: GlobalVariables.selectedColor
                                        .withOpacity(0.3),
                                    width: 3,
                                  ),
                                  image: logoImage() != null
                                      ? DecorationImage(
                                    image: logoImage()!,
                                    fit: BoxFit.cover,
                                  )
                                      : null,
                                ),
                                child: logoImage() == null
                                    ? Icon(
                                  Icons.business,
                                  size: 40,
                                  color: GlobalVariables.selectedColor,
                                )
                                    : null,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: GlobalVariables.selectedColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            if (logoImage() != null)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      newLogo = null;
                                      removeLogo = true;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _sectionTitle('Basic Information'),
                      const SizedBox(height: 16),
                      _label('Institution Name'),
                      CustomTextField(
                        controller: nameCtrl,
                        hintText: 'Institution Name',
                      ),
                      _gap(),
                      _label('Institution Type'),
                      CustomDropdown<String>(
                        value: institutionType,
                        items: institutionTypes,
                        hintText: 'Institution Type',
                        itemLabel: (e) => e,
                        onChanged: (val) => setState(() => institutionType = val),
                      ),
                      _gap(),
                      _label('About'),
                      CustomTextField(
                        controller: aboutCtrl,
                        hintText: 'About institution',
                        maxLines: 4,
                      ),
                      const SizedBox(height: 32),
                      _sectionTitle('Contact Details'),
                      const SizedBox(height: 16),
                      _label('Phone'),
                      CustomTextField(
                        controller: phoneCtrl,
                        hintText: 'Phone',
                        keyboardType: TextInputType.phone,
                      ),
                      _gap(),
                      _label('Website'),
                      CustomTextField(
                        controller: websiteCtrl,
                        hintText: 'Website',
                      ),
                      const SizedBox(height: 32),
                      _sectionTitle('Address'),
                      const SizedBox(height: 16),
                      _label('Street'),
                      CustomTextField(controller: streetCtrl, hintText: 'Street'),
                      _gap(),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('City'),
                                CustomTextField(controller: cityCtrl, hintText: 'City'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label('State'),
                                CustomTextField(controller: stateCtrl, hintText: 'State'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      _gap(),
                      _label('Pincode'),
                      CustomTextField(
                        controller: pincodeCtrl,
                        hintText: 'Pincode',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 32),
                      _sectionTitle('Gallery'),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          ...existingGalleryImages.map(
                                (img) => Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    img,
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() =>
                                          existingGalleryImages.remove(img));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...newGalleryImages.map(
                                (img) => Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    img,
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(
                                              () => newGalleryImages.remove(img));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        size: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final images = await pickImages(
                                max: 6,
                                type: FileType.image,
                              );
                              if (images.isNotEmpty) {
                                setState(() => newGalleryImages.addAll(images));
                              }
                            },
                            child: Container(
                              height: 90,
                              width: 90,
                              decoration: BoxDecoration(
                                color: GlobalVariables.greyBackgroundColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: GlobalVariables.selectedColor
                                      .withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.add,
                                size: 32,
                                color: GlobalVariables.selectedColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Consumer<InstituteProvider>(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ───────── HELPERS ─────────
  Widget _sectionTitle(String text) => PrimaryText(text: text, size: 18);

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
  );

  Widget _gap() => const SizedBox(height: 16);
}
