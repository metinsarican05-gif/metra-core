// ===============================
// lib/main.dart
// ===============================
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/user_session.dart';

// ONBOARDING
import 'features/auth/onboarding/onboarding_page.dart';

// AUTH
import 'features/auth/auth_choice_page.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/auth/kvkk_page.dart';

// HOME
import 'features/home/master_home_page.dart';
import 'features/home/customer_home_page.dart';

// EXPLORE
import 'features/explore/presentation/explore_page.dart';

// USTA PROFILE
import 'features/profile/usta_profile_page.dart';

void main() {
  runApp(const MetraApp());
}

class MetraApp extends StatelessWidget {
  const MetraApp({super.key});

  static const bool kSkipOnboarding = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'METRA',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: kSkipOnboarding ? '/authChoice' : '/onboarding',
      routes: {
        // Onboarding
        '/onboarding': (context) => const OnboardingPage(),

        // Auth
        '/authChoice': (context) => const AuthChoicePage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/kvkk': (context) => const KvkkPage(),

        // Home (rol bazlı yönlendirme)
        '/home': (context) => const _HomeGate(),

        // Explore
        '/explore': (context) => const ExplorePage(),

        // Usta Profile (ExplorePage buraya pushNamed ile gidiyor)
        '/ustaProfile': (context) => const UstaProfilePage(),
      },
    );
  }
}

/// Rol seçimine göre doğru ana sayfa
class _HomeGate extends StatelessWidget {
  const _HomeGate();

  @override
  Widget build(BuildContext context) {
    final session = UserSession.instance;
    if (session.isCustomer) return const CustomerHomePage();
    return const MasterHomePage();
  }
}
