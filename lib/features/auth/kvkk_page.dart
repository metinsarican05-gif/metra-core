import 'package:flutter/material.dart';

class KvkkPage extends StatelessWidget {
  const KvkkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color background = const Color(0xFF0A1A2F);
    final Color card = const Color(0xFF101E33);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          "KVKK ve Kullanım Koşulları",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: const Text(
                    """
Bu metin, Metra uygulamasının KVKK (Kişisel Verilerin Korunması Kanunu) kapsamında kullanıcı bilgilerini nasıl işlediğini açıklayan örnek bir bilgilendirme metnidir.

Gerçek kullanım metni, hukuk danışmanlarının hazırlayacağı detaylı bir içerikle güncellenecektir.

- Kişisel bilgileriniz, kullanıcı deneyimini iyileştirmek ve hizmet sunmak amacıyla işlenebilir.
- Bilgileriniz üçüncü şahıslarla paylaşılmaz.
- Dilediğiniz zaman hesabınızı silebilir ve veri işleme izninizi geri çekebilirsiniz.
- Metra, kullanıcı güvenliğini ön planda tutar ve verilerin korunması için gerekli tüm teknik ve idari tedbirleri alır.
- Uygulamada paylaştığınız veriler, yalnızca size hizmet sunmak amacıyla kullanılır.

Bu metin bir örnek içeriktir ve geliştirme aşamasında placeholder olarak kullanılmaktadır.
                    """,
                    style: TextStyle(color: Colors.white70, height: 1.4),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Kapat Butonu
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Kapat",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
