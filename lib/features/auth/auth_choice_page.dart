// ===============================
// lib/features/auth/auth_choice_page.dart
// ===============================
import 'package:flutter/material.dart';
import '../../core/user_session.dart';

class AuthChoicePage extends StatefulWidget {
  const AuthChoicePage({super.key});

  @override
  State<AuthChoicePage> createState() => _AuthChoicePageState();
}

class _AuthChoicePageState extends State<AuthChoicePage> {
  bool _acceptTerms = false;
  bool _acceptKvkk = false;

  final Color _background = const Color(0xFF0A1A2F);
  final Color _cardColor = const Color(0xFF101E33);
  final Color _primary = const Color(0xFF1ED1F5);

  bool get _canProceed => _acceptTerms && _acceptKvkk;

  void _showCheckWarning() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Devam etmek için KVKK ve Kullanım Koşulları’nı onaylamalısın."),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _selectProfessionalTypeAndGoRegister() async {
    final theme = Theme.of(context);

    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Profesyonel hesabını seç',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Text(
                  'Bu seçim “firma keşfeti” ve adil sıralama mimarisinin temelidir.',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                _TypeTile(
                  icon: Icons.person_outline,
                  title: 'Bireysel çalışıyorum',
                  subtitle: 'Tek başıma hizmet veriyorum.',
                  onTap: () => Navigator.pop(ctx, 'individual'),
                ),
                const SizedBox(height: 10),

                _TypeTile(
                  icon: Icons.badge_outlined,
                  title: 'Şahıs şirketim var',
                  subtitle: 'Küçük işletme / fatura kesebilirim.',
                  onTap: () => Navigator.pop(ctx, 'sole'),
                ),
                const SizedBox(height: 10),

                _TypeTile(
                  icon: Icons.apartment_outlined,
                  title: 'Firmayım (LTD/A.Ş.)',
                  subtitle: 'Ekip + proje; birden çok hizmet olabilir.',
                  onTap: () => Navigator.pop(ctx, 'company'),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected == null) return;

    final s = UserSession.instance;
    s.role = 'professional';
    s.professionalType = selected;

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/register');
  }

  void _selectCustomerAndGoRegister() {
    final s = UserSession.instance;
    s.role = 'customer';
    s.professionalType = null;

    Navigator.pushReplacementNamed(context, '/register');
  }

  void _onSelectRole(String role) {
    if (!_canProceed) {
      _showCheckWarning();
      return;
    }

    if (role == 'professional') {
      _selectProfessionalTypeAndGoRegister();
    } else {
      _selectCustomerAndGoRegister();
    }
  }

  Widget _buildRoleCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: _primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: _primary, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.white54,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: _background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/onboarding');
          },
        ),
        title: const Text(
          "Metra’ya Hoş Geldin",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Metra’da nasıl yer almak istiyorsun?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Önce rolünü seç, sonra hesabını oluşturup vitrine çıkalım.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 24),

            _buildRoleCard(
              icon: Icons.handyman_outlined,
              title: "Hizmet Veriyorum (Profesyonelim)",
              subtitle: "Usta, mimar, danışman, tasarımcı… İşlerini sergile, yeni müşteriler kazan.",
              onTap: () => _onSelectRole("professional"),
            ),
            const SizedBox(height: 16),

            _buildRoleCard(
              icon: Icons.search_outlined,
              title: "Hizmet Arıyorum (Müşteriyim)",
              subtitle: "İhtiyacın olan işi tarif et, teklifleri topla, doğru kişiyle eşleş.",
              onTap: () => _onSelectRole("customer"),
            ),
            const SizedBox(height: 24),

            Container(
              decoration: BoxDecoration(
                color: _cardColor.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.white70,
                  checkboxTheme: CheckboxThemeData(
                    side: const BorderSide(color: Colors.white70, width: 1.6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
                child: Column(
                  children: [
                    CheckboxListTile(
                      value: _acceptTerms,
                      onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                      activeColor: _primary,
                      checkColor: Colors.black,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        "Kullanım Koşulları’nı kabul ediyorum.",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    CheckboxListTile(
                      value: _acceptKvkk,
                      onChanged: (val) => setState(() => _acceptKvkk = val ?? false),
                      activeColor: _primary,
                      checkColor: Colors.black,
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        "KVKK Metni’ni okudum, kabul ediyorum.",
                        style: TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/kvkk'),
                        child: const Text(
                          "KVKK ve Kullanım Koşulları’nı Gör",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.lock_outline, size: 16, color: Colors.white54),
                SizedBox(width: 6),
                Text(
                  "Bilgilerin yalnızca Metra iş akışı için kullanılır.",
                  style: TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _TypeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _TypeTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700])),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
