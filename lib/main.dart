import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

// ----------------------
//   ONBOARDING (SENDE AUTH İÇİNDE!)
// ----------------------
import 'features/auth/onboarding/onboarding_page.dart';

// ----------------------
//       AUTH
// ----------------------
import 'features/auth/auth_choice_page.dart';
import 'features/auth/login_page.dart';
import 'features/auth/register_page.dart';
import 'features/auth/kvkk_page.dart';

// ----------------------
//        HOME
// ----------------------
import 'features/home/master_home_page.dart';

// ----------------------
//      EXPLORE TEST
// ----------------------
import 'features/explore/presentation/explore_page.dart';

void main() {
  runApp(MetraApp());
}

class MetraApp extends StatelessWidget {
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
        '/onboarding': (context) => OnboardingPage(),

        // Auth
        '/authChoice': (context) => AuthChoicePage(),
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        '/kvkk': (context) => KvkkPage(),

        // Home
        '/home': (context) => MasterHomePage(),

        // Explore Test
        '/explore': (context) => ExplorePage(),
      },
    );
  }
}
