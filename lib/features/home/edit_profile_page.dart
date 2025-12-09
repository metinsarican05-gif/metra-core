// lib/features/home/edit_profile_page.dart

import 'package:flutter/material.dart';
import '../../core/user_session.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final UserSession session = UserSession.instance;

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _professionController;
  late final TextEditingController _cityController;
  late final TextEditingController _districtController;
  late final TextEditingController _companyController;
  late final TextEditingController _experienceController;
  late final TextEditingController _aboutController;
  late final TextEditingController _websiteController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: session.name ?? "");
    _phoneController = TextEditingController(text: session.phone ?? "");
    _emailController = TextEditingController(text: session.email ?? "");
    _professionController =
        TextEditingController(text: session.profession ?? "");
    _cityController = TextEditingController(text: session.city ?? "");
    _districtController = TextEditingController(text: session.district ?? "");
    _companyController =
        TextEditingController(text: session.companyName ?? "");
    _experienceController = TextEditingController(
      text: session.experienceYears != null
          ? session.experienceYears.toString()
          : "",
    );
    _aboutController = TextEditingController(text: session.aboutText ?? "");
    _websiteController =
        TextEditingController(text: session.websiteUrl ?? "");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _professionController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _companyController.dispose();
    _experienceController.dispose();
    _aboutController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profili Düzenle"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Temel bilgiler
                _sectionTitle("Temel Bilgiler"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _nameController,
                  label: "Ad Soyad",
                  hint: "Adını ve soyadını yaz",
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Lütfen ad soyad gir.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _phoneController,
                  label: "Telefon",
                  hint: "05xx xxx xx xx",
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Lütfen telefon numarası gir.";
                    }
                    if (value.replaceAll(RegExp(r'\D'), '').length < 10) {
                      return "Telefon numarası eksik görünüyor.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _emailController,
                  label: "E-posta (opsiyonel)",
                  hint: "ornek@mail.com",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // Meslek ve konum
                _sectionTitle("Meslek ve Konum"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _professionController,
                  label: "Meslek",
                  hint: "Marangoz, Mimar, Yazılımcı...",
                  icon: Icons.work_outline,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _cityController,
                        label: "İl",
                        hint: "İstanbul, Hatay...",
                        icon: Icons.location_city_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _districtController,
                        label: "İlçe",
                        hint: "Kadıköy, Dörtyol...",
                        icon: Icons.location_on_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Şirket ve tecrübe
                _sectionTitle("Şirket ve Deneyim"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _companyController,
                  label: "Şirket / Marka Adı (opsiyonel)",
                  hint: "Sarıcan Yapı, Metra Studio...",
                  icon: Icons.business_center_outlined,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _experienceController,
                  label: "Tecrübe Yılı (opsiyonel)",
                  hint: "Örneğin: 10",
                  icon: Icons.timeline_outlined,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                // Hakkında
                _sectionTitle("Hakkında"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _aboutController,
                  label: "Kendini ve işini anlat",
                  hint:
                  "Hangi işlerde uzmansın, nasıl çalışırsın, müşteriye ne vaat ediyorsun...",
                  icon: Icons.info_outline,
                  maxLines: 4,
                ),
                const SizedBox(height: 20),

                // Web sitesi
                _sectionTitle("Web ve Dijital Vitrin"),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _websiteController,
                  label: "Web sitesi (opsiyonel)",
                  hint: "https://...",
                  icon: Icons.language_outlined,
                  keyboardType: TextInputType.url,
                ),
                const SizedBox(height: 28),

                // Butonlar
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Vazgeç"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: Colors.black,
                          textStyle: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        onPressed: _saveProfile,
                        child: const Text("Kaydet"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
    );
  }

  void _saveProfile() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    // Form valid -> oturum bilgilerini güncelle
    session.name = _nameController.text.trim();
    session.phone = _phoneController.text.trim();
    session.email = _emailController.text.trim().isEmpty
        ? null
        : _emailController.text.trim();
    session.profession = _professionController.text.trim().isEmpty
        ? null
        : _professionController.text.trim();
    session.city = _cityController.text.trim().isEmpty
        ? null
        : _cityController.text.trim();
    session.district = _districtController.text.trim().isEmpty
        ? null
        : _districtController.text.trim();

    session.companyName = _companyController.text.trim().isEmpty
        ? null
        : _companyController.text.trim();

    if (_experienceController.text.trim().isNotEmpty) {
      final parsed =
      int.tryParse(_experienceController.text.trim());
      session.experienceYears = parsed;
    } else {
      session.experienceYears = null;
    }

    session.aboutText = _aboutController.text.trim().isEmpty
        ? null
        : _aboutController.text.trim();

    session.websiteUrl = _websiteController.text.trim().isEmpty
        ? null
        : _websiteController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profil bilgilerin güncellendi."),
      ),
    );

    Navigator.of(context).pop();
  }
}
