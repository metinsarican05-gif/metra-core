import 'package:flutter/material.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final Color background = const Color(0xFF0A1A2F);
  final Color cardColor = const Color(0xFF101E33);
  final Color primary = const Color(0xFF1ED1F5);
  final Color accent = const Color(0xFFEAC55F);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      _finish();
    }
  }

  void _goPrev() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _skip() {
    _finish();
  }

  void _finish() {
    Navigator.pushReplacementNamed(context, '/authChoice');
  }

  Widget _buildPage({
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 40),

          // Üst ikon / illüstrasyon alanı
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(
              icon,
              color: primary,
              size: 80,
            ),
          ),

          const SizedBox(height: 40),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 15,
              height: 1.4,
            ),
          ),

          const Spacer(),

          // Sayfa göstergesi (dots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final bool isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? primary : Colors.white24,
                  borderRadius: BorderRadius.circular(999),
                ),
              );
            }),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: _currentPage > 0
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _goPrev,
        )
            : null,
        actions: [
          TextButton(
            onPressed: _skip,
            child: const Text(
              "Geç",
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (i) {
                setState(() {
                  _currentPage = i;
                });
              },
              children: [
                _buildPage(
                  title: "Metra: Her mesleğin prestij kazandığı yeni vitrin",
                  subtitle:
                  "Usta, danışman, mimar, tasarımcı… Kim olursan ol; işini sergile, değerini büyüt.",
                  icon: Icons.workspace_premium_outlined,
                ),
                _buildPage(
                  title:
                  "Gerçek işini göster — seni tanıtan artık sözlerin değil, çalışmaların.",
                  subtitle:
                  "Öncesi–sonrası işlerin, portföyün, deneyimin… Hepsi profesyonelliğini görünür kılar.",
                  icon: Icons.design_services_outlined,
                ),
                _buildPage(
                  title:
                  "Değerin görünür olduğunda iş, kendi müşterisini bulur.",
                  subtitle:
                  "Metra, emeğini doğru kitleyle buluşturan net ve prestijli bir iş akışı sunar.",
                  icon: Icons.handshake_outlined,
                ),
              ],
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _goNext,
                child: Text(
                  _currentPage == 2 ? "Başla" : "İleri",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
