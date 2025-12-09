// lib/core/user_session.dart

/// Uygulama içindeki geçici (lokal) oturum bilgisi.
/// Şimdilik backend yok, bu yüzden kullanıcıyla ilgili
/// temel bilgileri burada tutuyoruz.
class UserSession {
  UserSession._internal();

  static final UserSession instance = UserSession._internal();

  /// Temel bilgiler
  String? name;
  String? phone;
  String? email;
  String? city;
  String? district;
  String? profession;

  /// Rol bilgisi (Model 1)
  /// 'professional'  -> usta / profesyonel
  /// 'customer'      -> hizmet arayan
  String role = 'professional';

  /// Premium üyelik bilgisi (şimdilik demo amaçlı)
  bool isPremium = true;

  /// Gelişmiş profil alanları
  String? companyName;     // Şirket / marka adı
  int? experienceYears;    // Toplam tecrübe yılı
  String? aboutText;       // Hakkında açıklaması
  String? websiteUrl;      // Web sitesi adresi (https://...)
  String? logoUrl;         // Şirket logosu (ileride network image için)

  /// Tüm oturum bilgisini sıfırlar
  void clear() {
    name = null;
    phone = null;
    email = null;
    city = null;
    district = null;
    profession = null;

    role = 'customer';
    isPremium = false;

    companyName = null;
    experienceYears = null;
    aboutText = null;
    websiteUrl = null;
    logoUrl = null;
  }
}
