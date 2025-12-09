📘 METRA – ÇEKİRDEK MİMARİ DOKÜMANTASYONU (v1)
Uygulama Mimari Rehberi & Kod Standartları – 09.12.2025
🧭 İÇİNDEKİLER

Proje Mimari Haritası

Tema Sistemi

User Session Yapısı

Premium Tier Sistemi

Usta Kartı Sistemi

Usta Bulma (Explore Page)

Profesyonel Ana İskeleti (MasterHome)

Müşteri Landing Sayfası

Akış Sistemi (FeedPage)

Navigasyon & Routing

Geliştirme Kuralları

Sonuç ve Yol Haritası

📦 PROJE MİMARİ HARİTASI
lib/
 ├── core/
 │     ├── theme/              → Tema & Material 3
 │     ├── premium/            → Paket sistemleri
 │     └── user_session.dart   → Kullanıcı oturumu
 │
 ├── features/
 │     ├── home/               → Ana iskelet, akış, ilanlar, profil, paylaşım
 │     │     ├── master_home_page.dart
 │     │     ├── feed_page.dart
 │     │     ├── jobs_page.dart
 │     │     ├── professional_profile_page.dart
 │     │     ├── create_job_page.dart
 │     │     ├── create_post_page.dart
 │     │     └── home_page.dart
 │     │
 │     ├── explore/
 │           ├── usta_card.dart
 │           └── explore_page.dart
 │
 └── main.dart                 → Giriş noktası / route yönetimi

🎨 TEMA SİSTEMİ

Konum:

lib/core/theme/app_theme.dart


Material 3 tabanlıdır.

Uygulamanın tüm görsel kimliğini tek merkezden kontrol eder.

Renk, kart, buton, input, bottom nav bar burada tanımlıdır.

Kural:

❗ Hiçbir ekranda sabit renk kullanılmaz.
Her zaman:

Theme.of(context)

👤 USER SESSION YAPISI

Konum:

lib/core/user_session.dart


Rol ve kullanıcı bilgisi burada tutulur:

name, phone, email

city, district

profession

role → professional | customer

isPremium

companyName

experienceYears

aboutText

websiteUrl

logoUrl

Kullanım:
UserSession.instance.name = "Metin";

⭐ PREMIUM TIER SİSTEMİ

Konum:

lib/core/premium/premium_config.dart


4 paket:

standard, pro, vitrin, sponsor


Renkler ve rozet davranışları:

UstaTierConfig.of(context, tier)


ile alınır.

🧱 USTA KARTI SİSTEMİ

Konum:

lib/features/explore/usta_card.dart


Kartta bulunan detaylar:

İsim

Firma adı

Puan

Mesafe

Fiyat / Açıklama

Öncesi-sonrası

Alt butonlar

Seç

Mesaj

Ara

Web sitesi

Ve premium görünüm otomatik uygulanır.

🔍 USTA BULMA (Explore Page)

Konum:

lib/features/explore/presentation/explore_page.dart

İçerik:

Arama kutusu

Filtreler:

Yakınımda

En yüksek puan

Premium

Fiyat uygun

Filtre motoru → applyFilters()

Filtrelenen liste UstaCard bileşenlerini üretir.

🏠 PROFESYONEL ANA İSKELETİ (MASTERHOME)

Konum:

lib/features/home/master_home_page.dart

Alt sekmeler:

FeedPage (Akış)

JobsPage (İlanlar)

Mesajlar (taslak)

ProfessionalProfilePage (Profil)

FAB:

İlan / ihale aç → CreateJobPage

Gönderi paylaş → CreatePostPage

AppBar:

Sağ üstte arama → ExplorePage

🏡 MÜŞTERİ LANDİNG SAYFASI

Konum:

lib/features/home/home_page.dart


Gösterilen kartlar:

İlanlar

Profesyoneller

Akış

Bu ekran ileride müşteriler için ana merkez olacak.

📸 AKIŞ SİSTEMİ (FEEDPAGE)

Konum:

lib/features/home/feed_page.dart

Model: Post

userName

profession

location

isPremium

description

mediaType

imageUrl

Kart Yapısı:

Avatar + isim + meslek

Premium rozeti

16:9 görsel

MediaType etiketi

Açıklama

Bu alan ileride:

Video oynatma

Before/after slider

Çoklu fotoğraf

özellikleriyle genişletilecek.

🧭 NAVİGASYON & ROUTING

Konum:

main.dart


Başlangıç akışı:

kSkipOnboarding ? '/AuthChoice' : '/onboarding'


Route listesi:

/onboarding

/AuthChoice

/register

/login

/kvkk

/home

/explore

🔧 GELİŞTİRME KURALLARI
✔ 1) Tema → tek merkezden yönetilir
✔ 2) Usta görünümü → UstaTierConfig ile belirlenir
✔ 3) Kullanıcı bilgisi → UserSession
✔ 4) Ekranlar → feature bazlı klasörlerde tutulur
✔ 5) Magic number yasak
✔ 6) Core mimariye dokunmadan genişletme yapılır
✔ 7) Navigasyon pushNamed ile yapılır
✔ 8) Demo data ileride service/repository katmanına taşınır
✔ 9) Profil, ilan, akış gibi modüller bağımsızdır
🧩 SONUÇ VE YOL HARİTASI

Bu doküman, METRA’nın çekirdek anayasa dosyasıdır.
Bundan sonra:

Yeni ekran eklenecek → Bu belgedeki kurallara göre yapılacak

Yeni özellik gelecek → Core bozulmadan modüler eklenir

UI güncellenecek → app_theme.dart üzerinden yapılır

Premium davranışları → UstaTierConfig üzerinden yönetilir

📌 Bir sonraki aşama önerilerim:

Profil Düzenleme Ekranı (ProfessionalProfileEdit)

Mesajlaşma Sistemi (Chat)

İlan Detay + Teklif Sistemi

Müşteri tarafı akış ve ilan verme

Gerçek veri için Repository yapısı
