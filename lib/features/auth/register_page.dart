import 'package:flutter/material.dart';
import '../../core/user_session.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Text alanları
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Konum & meslek seçimleri
  String? _selectedCity;
  String? _selectedDistrict;
  String? _selectedProfession;

  // Şehir – İlçe verileri
  final List<String> _cities = const [
    'İstanbul',
    'Ankara',
    'İzmir',
    'Bursa',
    'Antalya',
    'Adana',
    'Konya',
    'Kayseri',
    'Hatay',
    'Gaziantep',
  ];

  final Map<String, List<String>> _districtsByCity = const {
    'İstanbul': [
      'Kadıköy',
      'Üsküdar',
      'Beşiktaş',
      'Bakırköy',
      'Fatih',
      'Şişli',
      'Ataşehir',
    ],
    'Ankara': [
      'Çankaya',
      'Keçiören',
      'Yenimahalle',
      'Mamak',
      'Etimesgut',
    ],
    'İzmir': [
      'Konak',
      'Karşıyaka',
      'Bornova',
      'Buca',
      'Çiğli',
    ],
    'Bursa': [
      'Osmangazi',
      'Yıldırım',
      'Nilüfer',
      'İnegöl',
    ],
    'Antalya': [
      'Kepez',
      'Muratpaşa',
      'Konyaaltı',
      'Alanya',
    ],
    'Adana': [
      'Seyhan',
      'Yüreğir',
      'Çukurova',
      'Ceyhan',
    ],
    'Konya': [
      'Selçuklu',
      'Meram',
      'Karatay',
    ],
    'Kayseri': [
      'Kocasinan',
      'Melikgazi',
      'Talas',
    ],
    'Hatay': [
      'Dörtyol',
      'İskenderun',
      'Antakya',
      'Defne',
      'Samandağ',
    ],
    'Gaziantep': [
      'Şahinbey',
      'Şehitkamil',
      'Nizip',
    ],
  };

  // Meslek listesi
  final List<String> _professions = const [
    // Yapı & Tadilat
    'Usta (Genel)',
    'Marangoz',
    'Elektrikçi',
    'Su Tesisatçısı',
    'Doğalgaz Tesisatçısı',
    'Boyacı',
    'Alçı Ustası',
    'Fayans / Seramik Ustası',
    'PVC Kapı / Pencere Ustası',
    'Demirci',
    'Kaynakçı',
    'İzolasyon Ustası',
    'Çatı Ustası',
    'Parke / Laminant Ustası',
    'Camcı',
    // Profesyonel hizmetler
    'Avukat',
    'Mimar',
    'İç Mimar',
    'İnşaat Mühendisi',
    'Makine Mühendisi',
    'Elektrik Mühendisi',
    'Danışman',
    'Eğitmen / Öğretmen',
    'Koç (İş / Kariyer)',
    // Dijital meslekler
    'Yazılımcı',
    'Mobil Uygulama Geliştirici',
    'Web Geliştirici',
    'Grafik Tasarımcı',
    'UI/UX Tasarımcı',
    'Video Editörü',
    'Sosyal Medya Uzmanı',
    'Dijital Pazarlama Uzmanı',
    'SEO Uzmanı',
    // Sanat & Zanaat
    'Fotoğrafçı',
    'Ressam',
    'Heykeltıraş',
    'Terzi',
    'Kuyumcu',
    'El İşi / El Sanatları',
    // Bakım & Onarım
    'Araç Tamircisi',
    'Oto Elektrik / Elektronik',
    'Klima Servisi',
    'Kombi Servisi',
    'Beyaz Eşya Teknikeri',
    'Bilgisayar Teknik Servis',
    // Sağlık & Yaşam
    'Diyetisyen',
    'Psikolog',
    'Yaşam Koçu',
    'Kişisel Antrenör',
    // Diğer
    'Kuaför / Berber',
    'Güzellik Uzmanı',
    'Organizasyon Sorumlusu',
    'Freelance',
    'Esnaf',
    'Serbest Meslek',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _buildInputDecoration({
    required String label,
    String? hint,
    IconData? icon,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(color: Colors.white70, fontSize: 13),
      hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
      prefixIcon: icon != null
          ? Icon(
        icon,
        color: colorScheme.primary,
      )
          : null,
      filled: true,
      fillColor: Colors.white.withOpacity(0.04),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colorScheme.primary,
          width: 1.4,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1.2,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final background = const Color(0xFF0A1A2F);

    final List<String> currentDistricts =
    _selectedCity != null ? (_districtsByCity[_selectedCity] ?? []) : [];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          "Metra Hesap Oluştur",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kısa bir form, güçlü bir vitrin.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Bilgilerini doldur, mesleğini ve konumunu seç, Metra’da yerini al.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),

                // Ad Soyad
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildInputDecoration(
                    label: "Ad Soyad",
                    hint: "Örn: Ahmet Usta",
                    icon: Icons.person_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Lütfen ad soyad gir.";
                    }
                    if (value.trim().length < 3) {
                      return "Ad soyad en az 3 karakter olmalı.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Telefon
                TextFormField(
                  controller: _phoneController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.phone,
                  decoration: _buildInputDecoration(
                    label: "Telefon",
                    hint: "Örn: 5xx xxx xx xx",
                    icon: Icons.phone_iphone,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Lütfen telefon numarası gir.";
                    }
                    if (value.replaceAll(RegExp(r'\D'), '').length < 10) {
                      return "Lütfen geçerli bir telefon gir.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // E-posta (opsiyonel)
                TextFormField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration(
                    label: "E-posta (opsiyonel)",
                    hint: "Örn: ahmet@ornek.com",
                    icon: Icons.email_outlined,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return null;
                    final emailRegex = RegExp(
                        r'^[\w\.\-]+@([\w\-]+\.)+[a-zA-Z]{2,4}$');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return "Geçerli bir e-posta gir.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Şifre
                TextFormField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: _buildInputDecoration(
                    label: "Şifre",
                    hint: "En az 6 karakter",
                    icon: Icons.lock_outline,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Lütfen şifre belirle.";
                    }
                    if (value.length < 6) {
                      return "Şifre en az 6 karakter olmalı.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                const Text(
                  "Konum Bilgileri",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // İl
                DropdownButtonFormField<String>(
                  value: _selectedCity,
                  dropdownColor: const Color(0xFF101E33),
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildInputDecoration(
                    label: "İl",
                    hint: "İl seç",
                    icon: Icons.location_city_outlined,
                  ),
                  items: _cities
                      .map(
                        (city) => DropdownMenuItem<String>(
                      value: city,
                      child: Text(city),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value;
                      _selectedDistrict = null;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Lütfen il seç.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // İlçe
                DropdownButtonFormField<String>(
                  value: _selectedDistrict,
                  dropdownColor: const Color(0xFF101E33),
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildInputDecoration(
                    label: "İlçe",
                    hint:
                    _selectedCity == null ? "Önce il seç" : "İlçe seç",
                    icon: Icons.map_outlined,
                  ),
                  items: currentDistricts
                      .map(
                        (dist) => DropdownMenuItem<String>(
                      value: dist,
                      child: Text(dist),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDistrict = value;
                    });
                  },
                  validator: (value) {
                    if (_selectedCity == null) {
                      return "Önce il seç.";
                    }
                    if (value == null || value.isEmpty) {
                      return "Lütfen ilçe seç.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                const Text(
                  "Mesleğin",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                // Meslek
                DropdownButtonFormField<String>(
                  value: _selectedProfession,
                  dropdownColor: const Color(0xFF101E33),
                  style: const TextStyle(color: Colors.white),
                  decoration: _buildInputDecoration(
                    label: "Meslek",
                    hint: "Metra’da hangi meslekle yer alacaksın?",
                    icon: Icons.work_outline,
                  ),
                  items: _professions
                      .map(
                        (p) => DropdownMenuItem<String>(
                      value: p,
                      child: Text(p),
                    ),
                  )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedProfession = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Lütfen bir meslek seç.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 28),

                // Kayıt butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // 🔹 KAYIT BAŞARILI: UserSession’a bilgileri yaz
                        final session = UserSession.instance;
                        session.name = _nameController.text.trim();
                        session.phone = _phoneController.text.trim();
                        final emailText = _emailController.text.trim();
                        session.email = emailText.isEmpty ? null : emailText;
                        session.city = _selectedCity;
                        session.district = _selectedDistrict;
                        session.profession = _selectedProfession;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                            Text("Hesap oluşturuldu (demo). Metra’ya hoş geldin."),
                          ),
                        );

                        // Ana sayfaya yönlendirme
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    child: const Text("Hesap Oluştur"),
                  ),
                ),
                const SizedBox(height: 16),

                // Zaten hesabın var mı?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Zaten hesabın var mı? ",
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Giriş Yap",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
