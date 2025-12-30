// lib/features/home/professional_profile_page.dart

import 'package:flutter/material.dart';
import '../../core/user_session.dart';
import 'edit_professional_profile_page.dart';
import 'professional_portfolio_section.dart';
import '../messages/messages_inbox_page.dart';

// Premium sayfası burada olmalı:
import '../home/premium_card_page.dart';

class ProfessionalProfilePage extends StatefulWidget {
  const ProfessionalProfilePage({super.key});

  @override
  State<ProfessionalProfilePage> createState() => _ProfessionalProfilePageState();
}

class _ProfessionalProfilePageState extends State<ProfessionalProfilePage> {
  final session = UserSession.instance;

  Color get _primary => const Color(0xFF00B5E2);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final name = session.name?.isNotEmpty == true ? session.name! : 'metin';
    final profession =
    session.profession?.isNotEmpty == true ? session.profession! : 'İç Mimar';
    final city = session.city?.isNotEmpty == true ? session.city! : 'İzmir';
    final district =
    session.district?.isNotEmpty == true ? session.district! : 'Konak';
    final isPremium = session.isPremium;

    return Scaffold(
      body: Container(
        color: const Color(0xFFF2F4F7),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(
                theme: theme,
                name: name,
                profession: profession,
                city: city,
                district: district,
                isPremium: isPremium,
              ),
              const SizedBox(height: 12),

              _buildActionRow(theme),
              const SizedBox(height: 12),

              _buildContactCard(theme),
              const SizedBox(height: 12),

              _buildAboutCard(theme),
              const SizedBox(height: 12),

              _buildCompanySummaryCard(theme),
              const SizedBox(height: 16),

              _buildPortfolioSection(theme),
              const SizedBox(height: 20),

              _buildBottomActions(
                context,
                name: name,
                profession: profession,
                city: city,
                district: district,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HEADER KISMI ---
  Widget _buildHeaderCard({
    required ThemeData theme,
    required String name,
    required String profession,
    required String city,
    required String district,
    required bool isPremium,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: _primary.withOpacity(0.12),
                  child: Text(
                    _getInitials(name),
                    style: TextStyle(
                      color: _primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        profession,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '$city / $district',
                            style: theme.textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: _primary.withOpacity(0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.workspace_premium,
                            size: 16, color: _primary),
                        const SizedBox(width: 4),
                        const Text(
                          'Premium Üye',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 4),
                const Text(
                  '4.8 / 5',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(48)',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey[600]),
                ),
                const Spacer(),
                OutlinedButton.icon(
                  onPressed: () {
                    _showNotImplementedSnackbar(
                        context, 'Takip sistemi v1’de eklenecek.');
                  },
                  icon: const Icon(Icons.person_add_alt_1_outlined, size: 18),
                  label: const Text('Takip et'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- MESAJ / YORUM ---
  Widget _buildActionRow(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _onMessagePressed,
            icon: const Icon(Icons.chat_bubble_outline, size: 18),
            label: const Text('Mesaj'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _onRatePressed,
            icon: const Icon(Icons.star_border, size: 18),
            label: const Text('Puan / Yorum'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _onMessagePressed() {
    final profName = session.name?.isNotEmpty == true ? session.name! : 'Metin';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MessagesInboxPage(
          fromOffer: false,
          jobTitle: null,
          professionalName: profName,
        ),
      ),
    );
  }


  void _onRatePressed() {
    showDialog(
      context: context,
      builder: (context) {
        double currentRating = 5.0;
        return AlertDialog(
          title: const Text('Puan ver / Yorum (Demo)'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Bu alan gerçek puanlama sistemi ile bağlanacak.\n'
                        'Şimdilik demo bir arayüz gösteriyoruz.',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final filled = index < currentRating.round();
                      return IconButton(
                        onPressed: () {
                          setState(() {
                            currentRating = index + 1.0;
                          });
                        },
                        icon: Icon(
                          filled ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                        ),
                      );
                    }),
                  ),
                  Text('Seçilen puan: ${currentRating.toStringAsFixed(1)}'),
                  const SizedBox(height: 8),
                  TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'İstersen kısa bir yorum yaz...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showNotImplementedSnackbar(
                    context, 'Puan / yorum kaydetme henüz aktif değil.');
              },
              child: const Text('Kaydet (demo)'),
            ),
          ],
        );
      },
    );
  }

  // --- İLETİŞİM ---
  Widget _buildContactCard(ThemeData theme) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'İletişim',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _onWhatsAppPressed,
                    icon: const Icon(Icons.chat_outlined),
                    label: const Text('WhatsApp'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _onCallPressed,
                    icon: const Icon(Icons.call_outlined),
                    label: const Text('Ara'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: _onWebsitePressed,
              icon: const Icon(Icons.language_outlined, size: 18),
              label: Text(
                session.websiteUrl?.isNotEmpty == true
                    ? 'Web sitesini aç'
                    : 'Web sitesi ekle',
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                foregroundColor: _primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onWhatsAppPressed() {
    if (session.phone == null || session.phone!.isEmpty) {
      _showNotImplementedSnackbar(
          context, 'Önce profil düzenle kısmından telefon numarası eklemelisin.');
      return;
    }
    _showNotImplementedSnackbar(
        context, 'WhatsApp entegrasyonu v1’de eklenecek.');
  }

  void _onCallPressed() {
    if (session.phone == null || session.phone!.isEmpty) {
      _showNotImplementedSnackbar(
          context, 'Önce profil düzenle kısmından telefon numarası eklemelisin.');
      return;
    }
    _showNotImplementedSnackbar(context, 'Arama entegrasyonu v1’de eklenecek.');
  }

  void _onWebsitePressed() {
    if (session.websiteUrl?.isNotEmpty == true) {
      _showNotImplementedSnackbar(context, 'Web sitesi açma v1’de eklenecek.');
    } else {
      _showNotImplementedSnackbar(
          context, 'Web sitesi eklemek için profili düzenleyebilirsin.');
      _openEditProfile();
    }
  }

  // --- HAKKINDA ---
  Widget _buildAboutCard(ThemeData theme) {
    final about = session.aboutText;
    final hasText = about != null && about.trim().isNotEmpty;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hakkında',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              hasText
                  ? about!
                  : 'Bu profesyonel henüz detaylı bir açıklama eklemedi. '
                  'Profil düzenleme ekranından çalışma tarzını ve sunduğun '
                  'hizmetleri anlatabilirsin.',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }

  // --- ŞİRKET ÖZETİ ---
  Widget _buildCompanySummaryCard(ThemeData theme) {
    final companyName = session.companyName ?? 'Şirket adı belirtilmemiş';
    final experience = session.experienceYears;
    final expText = experience != null ? '$experience yıl' : 'Belirtilmemiş';

    final workAreas = session.workAreas;
    final workAreasText =
    (workAreas != null && workAreas.trim().isNotEmpty) ? workAreas : 'Belirtilmemiş';

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Şirket Özeti',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            _summaryRow(
              icon: Icons.apartment_outlined,
              title: 'Şirket adı',
              value: companyName,
            ),
            const SizedBox(height: 8),
            _summaryRow(
              icon: Icons.timeline_outlined,
              title: 'Tecrübe',
              value: expText,
            ),
            const SizedBox(height: 8),
            _summaryRow(
              icon: Icons.location_city_outlined,
              title: 'Çalışma bölgeleri',
              value: workAreasText,
            ),
            const SizedBox(height: 8),
            _summaryRow(
              icon: Icons.attach_money_outlined,
              title: 'Minimum proje bütçesi',
              value: 'Belirtilmemiş',
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- PORTFÖY ---
  Widget _buildPortfolioSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        ProfessionalPortfolioSection(),
        SizedBox(height: 4),
      ],
    );
  }

  // --- ALT AKSİYONLAR ---
  Widget _buildBottomActions(
      BuildContext context, {
        required String name,
        required String profession,
        required String city,
        required String district,
      }) {
    return Column(
      children: [
        const Divider(height: 24),
        OutlinedButton.icon(
          onPressed: _openEditProfile,
          icon: const Icon(Icons.edit_outlined),
          label: const Text('Profili düzenle'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PremiumCardPage(
                  name: name,
                  profession: profession,
                  city: city,
                  district: district,
                ),
              ),
            );
          },
          icon: const Icon(Icons.credit_card_outlined),
          label: const Text('Kartvizit & Premium paketler'),
          style: TextButton.styleFrom(
            foregroundColor: _primary,
          ),
        ),
      ],
    );
  }

  void _openEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EditProfessionalProfilePage(),
      ),
    );
    setState(() {});
  }

  // --- YARDIMCI ---
  void _showNotImplementedSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'M';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    final first = parts.first.substring(0, 1).toUpperCase();
    final last = parts.last.substring(0, 1).toUpperCase();
    return '$first$last';
  }
}
