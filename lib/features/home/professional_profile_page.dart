// lib/features/home/professional_profile_page.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/user_session.dart';
import 'edit_profile_page.dart';
import 'rate_professional_page.dart';

class ProfessionalProfilePage extends StatefulWidget {
  const ProfessionalProfilePage({super.key});

  @override
  State<ProfessionalProfilePage> createState() =>
      _ProfessionalProfilePageState();
}

class _ProfessionalProfilePageState extends State<ProfessionalProfilePage> {
  final UserSession session = UserSession.instance;

  bool _isFollowing = false;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final String displayName = session.name ?? "Profesyonel";
    final String initials = _getInitials(displayName);
    final String profession = session.profession ?? "Meslek belirtilmemiş";
    final String location = [
      if (session.city != null) session.city,
      if (session.district != null) session.district,
    ].whereType<String>().join(" / ");

    return Scaffold(
      appBar: AppBar(
        title: const Text("METRA - Profesyonel"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              _buildHeaderCard(
                colorScheme: colorScheme,
                textTheme: textTheme,
                initials: initials,
                displayName: displayName,
                profession: profession,
                location: location,
              ),
              const SizedBox(height: 16),
              _buildContactCard(colorScheme),
              const SizedBox(height: 16),
              _buildAboutCard(colorScheme, textTheme),
              const SizedBox(height: 16),
              _buildPortfolioCard(colorScheme, textTheme),
              const SizedBox(height: 24),
              _buildEditProfileButton(colorScheme),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER KARTI
  // ---------------------------------------------------------------------------

  Widget _buildHeaderCard({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required String initials,
    required String displayName,
    required String profession,
    required String location,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: colorScheme.primary.withOpacity(0.15),
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profession,
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                      ),
                      if (location.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                location,
                                style: textTheme.bodySmall?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade600.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            size: 16,
                            color: Colors.amber.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "Premium Üye",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber.shade800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildSmallBadge(
                          icon: Icons.star_rate_rounded,
                          label: "4.8 / 5",
                          color: Colors.orange.shade700,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildFollowButton(),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildFavoriteButton(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // 🔹 PUAN VER BUTONU
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RateProfessionalPage(
                        professionalName: displayName,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.rate_review_outlined),
                label: const Text("Puan Ver / Yorum Yaz"),
                style: OutlinedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAKİP & FAVORİ BUTONLARI
  // ---------------------------------------------------------------------------

  Widget _buildFollowButton() {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {
        setState(() {
          _isFollowing = !_isFollowing;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFollowing
                  ? "Bu profesyoneli takip ediyorsun."
                  : "Takipten çıktın.",
            ),
          ),
        );
      },
      icon: Icon(
        _isFollowing ? Icons.check : Icons.person_add_alt_1_outlined,
      ),
      label: Text(_isFollowing ? "Takip Ediliyor" : "Takip Et"),
    );
  }

  Widget _buildFavoriteButton() {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {
        setState(() {
          _isFavorite = !_isFavorite;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isFavorite
                  ? "Favori ustalarına eklendi."
                  : "Favorilerden çıkarıldı.",
            ),
          ),
        );
      },
      icon: Icon(
        _isFavorite ? Icons.favorite : Icons.favorite_border,
      ),
      label: Text(_isFavorite ? "Favoride" : "Favori Usta"),
    );
  }

  // ---------------------------------------------------------------------------
  // İLETİŞİM KARTI (WHATSAPP, TELEFON, WEB)
  // ---------------------------------------------------------------------------

  Widget _buildContactCard(ColorScheme colorScheme) {
    final String? phone = session.phone;
    final String? website = session.websiteUrl;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "İletişim",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildContactButton(
                    colorScheme: colorScheme,
                    icon: Icons.chat_bubble_outline,
                    label: "WhatsApp",
                    onTap: () => _openWhatsApp(phone),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildContactButton(
                    colorScheme: colorScheme,
                    icon: Icons.phone_in_talk_outlined,
                    label: "Ara",
                    onTap: () => _callPhone(phone),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildContactButton(
              colorScheme: colorScheme,
              icon: Icons.language_outlined,
              label: "Web Sitesi",
              fullWidth: true,
              onTap: () => _openWebsite(website),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactButton({
    required ColorScheme colorScheme,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool fullWidth = false,
  }) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: colorScheme.primary),
        label: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Future<void> _openWhatsApp(String? phone) async {
    if (phone == null || phone.trim().isEmpty) {
      _showSimpleSnack("Telefon numarası kayıtlı değil.");
      return;
    }

    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final withCountryCode =
    digits.startsWith('0') ? '90${digits.substring(1)}' : digits;

    final uri = Uri.parse(
      "https://wa.me/$withCountryCode?text=Merhaba,%20Metra%20üzerinden%20yazıyorum.",
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showSimpleSnack("WhatsApp açılamadı.");
    }
  }

  Future<void> _callPhone(String? phone) async {
    if (phone == null || phone.trim().isEmpty) {
      _showSimpleSnack("Telefon numarası kayıtlı değil.");
      return;
    }

    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse("tel:$digits");

    if (!await launchUrl(uri)) {
      _showSimpleSnack("Arama başlatılamadı.");
    }
  }

  Future<void> _openWebsite(String? website) async {
    if (website == null || website.trim().isEmpty) {
      _showSimpleSnack("Web sitesi ekli değil.");
      return;
    }

    String url = website.trim();
    if (!url.startsWith("http://") && !url.startsWith("https://")) {
      url = "https://$url";
    }

    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showSimpleSnack("Web sitesi açılamadı.");
    }
  }

  void _showSimpleSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // ---------------------------------------------------------------------------
  // HAKKINDA KARTI
  // ---------------------------------------------------------------------------

  Widget _buildAboutCard(ColorScheme colorScheme, TextTheme textTheme) {
    final String company = session.companyName ?? "Şirket adı belirtilmemiş";
    final int? years = session.experienceYears;
    final String about = session.aboutText ??
        "Bu profesyonel henüz detaylı bir açıklama eklemedi.";

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hakkında",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.business_outlined,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    company,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (years != null) ...[
              Row(
                children: [
                  Icon(
                    Icons.timelapse_outlined,
                    size: 18,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "$years+ yıl deneyim",
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            Text(
              about,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PORTFÖY KARTI (GENEL MODEL)
  // ---------------------------------------------------------------------------

  Widget _buildPortfolioCard(ColorScheme colorScheme, TextTheme textTheme) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Portföy ve Vitrin",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tamamladığın projeleri, örnek çalışmalarını ve önce/sonra görsellerini buraya ekleyebilirsin. "
                  "Metra, marangozdan yazılımcıya kadar her meslek için bu alanı ortak vitrin olarak kullanır.",
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(4, (index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey.shade200,
                  ),
                  child: Center(
                    child: Text(
                      "Örnek Çalışma ${index + 1}",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Text(
              "Not: Şu anda demo içeriği gösteriliyor. Gerçek uygulamada bu alan senin yüklediğin proje fotoğraflarıyla dolacak.",
              style: textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PROFİLİ DÜZENLE BUTONU
  // ---------------------------------------------------------------------------

  Widget _buildEditProfileButton(ColorScheme colorScheme) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          side: BorderSide(
            color: colorScheme.primary,
            width: 1.3,
          ),
        ),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const EditProfilePage(),
            ),
          );
          setState(() {}); // Geri dönünce ekrandaki veriyi tazele
        },
        icon: Icon(
          Icons.edit_outlined,
          color: colorScheme.primary,
        ),
        label: Text(
          "Profili Düzenle",
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // YARDIMCI
  // ---------------------------------------------------------------------------

  String _getInitials(String name) {
    final parts = name.trim().split(" ");
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
