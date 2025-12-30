// =======================
// FILE: lib/features/home/edit_professional_profile_page.dart
// =======================

import 'package:flutter/material.dart';
import '../../core/user_session.dart';

class EditProfessionalProfilePage extends StatefulWidget {
  const EditProfessionalProfilePage({super.key});

  @override
  State<EditProfessionalProfilePage> createState() => _EditProfessionalProfilePageState();
}

class _EditProfessionalProfilePageState extends State<EditProfessionalProfilePage> {
  final session = UserSession.instance;

  late final TextEditingController _nameController;
  late final TextEditingController _professionController;
  late final TextEditingController _cityController;
  late final TextEditingController _districtController;
  late final TextEditingController _phoneController;
  late final TextEditingController _companyController;
  late final TextEditingController _experienceController;
  late final TextEditingController _workAreasController;
  late final TextEditingController _websiteController;
  late final TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: session.name ?? 'metin');
    _professionController = TextEditingController(text: session.profession ?? '');
    _cityController = TextEditingController(text: session.city ?? '');
    _districtController = TextEditingController(text: session.district ?? '');
    _phoneController = TextEditingController(text: session.phone ?? '');
    _companyController = TextEditingController(text: session.companyName ?? '');
    _experienceController = TextEditingController(text: session.experienceYears?.toString() ?? '');
    _workAreasController = TextEditingController(text: session.workAreas ?? '');
    _websiteController = TextEditingController(text: session.websiteUrl ?? '');
    _aboutController = TextEditingController(text: session.aboutText ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _professionController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _phoneController.dispose();
    _companyController.dispose();
    _experienceController.dispose();
    _workAreasController.dispose();
    _websiteController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profili Düzenle'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('Kaydet', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, size: 20, color: Colors.blueGrey),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Burada yaptığın değişiklikler profil kartında, portföy/vitrin bölümünde ve iletişim butonlarında görünür. '
                            'Backend geldiğinde kalıcı hale getirilecek.',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[800]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text('Temel Bilgiler', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),

            _buildTextField(label: 'Ad Soyad', controller: _nameController),
            _buildTextField(label: 'Meslek / Uzmanlık', controller: _professionController),

            Row(
              children: [
                Expanded(child: _buildTextField(label: 'Şehir', controller: _cityController)),
                const SizedBox(width: 8),
                Expanded(child: _buildTextField(label: 'İlçe', controller: _districtController)),
              ],
            ),

            _buildTextField(
              label: 'Telefon (WhatsApp / Ara için)',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),

            const SizedBox(height: 16),

            Text('Şirket Bilgileri', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),

            _buildTextField(label: 'Şirket / Marka adı', controller: _companyController),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Toplam tecrübe (yıl)',
                    controller: _experienceController,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTextField(
                    label: 'Web sitesi (https://...)',
                    controller: _websiteController,
                    keyboardType: TextInputType.url,
                  ),
                ),
              ],
            ),

            _buildTextField(
              label: 'Çalışma bölgeleri (örn: Dörtyol, Payas, İskenderun)',
              controller: _workAreasController,
            ),

            const SizedBox(height: 16),

            Text('Hakkında', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),

            TextField(
              controller: _aboutController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Kendini, çalışma tarzını ve sunduğun hizmetleri anlat...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: ElevatedButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.check),
                label: const Text('Kaydet ve Geri Dön'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _saveProfile() {
    // Temel bilgiler
    session.name = _nameController.text.trim();
    session.profession = _professionController.text.trim();
    session.city = _cityController.text.trim();
    session.district = _districtController.text.trim();

    // İletişim
    session.phone = _phoneController.text.trim();
    session.websiteUrl = _websiteController.text.trim();

    // Şirket bilgileri
    session.companyName = _companyController.text.trim();
    session.workAreas = _workAreasController.text.trim();

    final expText = _experienceController.text.trim();
    final value = int.tryParse(expText);
    session.experienceYears = (value != null && value >= 0) ? value : null;

    // Hakkında
    session.aboutText = _aboutController.text.trim();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profil bilgilerin güncellendi (lokal oturum).'),
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context);
  }
}