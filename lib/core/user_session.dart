// lib/core/user_session.dart
import 'premium/premium_config.dart';

/// Uygulama boyunca "demo auth" ve kullanıcı durumunu tutan tekil oturum sınıfı.
/// V1: Local in-memory (kalıcı değil). Backend gelince burası repo/state ile değişebilir.
class UserSession {
  UserSession._internal();

  static final UserSession instance = UserSession._internal();

  /// Onboarding tamamlandı mı? (onboarding_page.dart bunu set ediyor)
  bool onboardingDone = false;

  /// 'professional' | 'customer'
  String role = 'professional';

  /// 'individual' | 'sole' | 'company' (sadece professional için)
  String? professionalType;

  /// Paket seviyesi
  UstaTier tier = UstaTier.standard;

  // ---- Temel kimlik ----
  String? name;
  String? phone;
  String? email;

  // ---- Konum / meslek ----
  String? city;
  String? district;
  String? profession;

  // ---- Profil detayları ----
  String? companyName;
  int? experienceYears;
  String? aboutText;
  String? websiteUrl;
  String? workAreas;

  /// Standart dışındaki her tier premium kabul edilir.
  bool get isPremium => tier != UstaTier.standard;

  /// Demo puan
  double rating = 4.8;
  int ratingCount = 48;

  void reset() {
    onboardingDone = false;

    role = 'professional';
    professionalType = null;
    tier = UstaTier.standard;

    name = null;
    phone = null;
    email = null;

    city = null;
    district = null;
    profession = null;

    companyName = null;
    experienceYears = null;
    aboutText = null;
    websiteUrl = null;
    workAreas = null;

    rating = 4.8;
    ratingCount = 48;
  }

  bool get isProfessional => role == 'professional';
  bool get isCustomer => role == 'customer';

  @override
  String toString() {
    return 'UserSession(onboardingDone: $onboardingDone, role: $role, professionalType: $professionalType, tier: $tier, '
        'name: $name, phone: $phone, email: $email, city: $city, district: $district, '
        'profession: $profession, companyName: $companyName, experienceYears: $experienceYears)';
  }
}
