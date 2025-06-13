# Ada's Friends (iOS)

## 🐾 Projeye Genel Bakış

**Ada's Friends**, 4-8 yaş arası çocuklara yönelik, onlara hayvan sevgisi ve sorumluluk bilinci aşılamayı hedefleyen, Swift ve SwiftUI ile geliştirilmiş bir iOS mobil oyunudur. Proje, eğlenceli bir evcil hayvan simülasyonunu, çocukların bilişsel ve duygusal gelişimlerine katkı sağlayacak eğitici mini oyunlarla birleştirmektedir.

Ana amaç, çocukların sanal bir evcil hayvan (kedi veya köpek) sahiplenerek onun temel ihtiyaçlarını (beslenme, temizlik, sevgi, oyun vb.) karşılamalarını sağlamak ve bu süreci eğitici oyunlarla zenginleştirmektir.

## ✨ Temel Özellikler

Oyunun şu anki geliştirme aşamasında tamamlanmış olan özellikler:

### 1. Evcil Hayvan Simülasyonu
- **Dinamik İhtiyaçlar:** Evcil hayvanın Açlık, Susuzluk, Hijyen, Sevgi ve Enerji gibi temel ihtiyaçları bulunur.
- **Zamanla Azalma:** Bu ihtiyaçlar, oyun açıkken gerçek zamanlı olarak azalır ve oyuncunun müdahalesini gerektirir.
- **Etkileşim:** Oyuncular "Besle" ve "Su Ver" butonları ile hayvanın ihtiyaçlarını karşılayabilir.

### 2. Mini Oyunlar
- **Matematik Konservesi:** Basit toplama/çıkarma işlemleriyle puan kazanılan, tekrar oynanabilir bir mini oyun.
- **Hafıza Kartları:** Hayvan temalı kartların eşleştirildiği, hafıza becerisini geliştiren bir mini oyun.

### 3. İlerleme ve Ödül Sistemi
- **Mutluluk Puanı (HP):** Başarıyla tamamlanan her görev (beslenme, oyun oynama vb.) oyuncuya "Mutluluk Puanı" kazandırır.
- **Seviye Atlama (Level Up):** Yeterli HP'ye ulaşıldığında evcil hayvan seviye atlar.
- **AdaCoin Ekonomisi:** Kazanılan her HP, aynı zamanda **AdaCoin** adı verilen oyun içi para birimini de kazandırır.

### 4. Kilitlenebilir İçerik ve Pet Shop
- **Seviyeye Bağlı Kilitler:** "Pet Shop", "Park" ve "Veteriner" gibi yeni mekanlar, belirli seviyelere ulaşıldığında açılır.
- **Envanter Sistemi:** Mama ve su artık sınırlıdır ve oyuncunun envanterinde tutulur.
- **Pet Shop:** Oyuncular, kazandıkları AdaCoin'ler ile Pet Shop'tan mama ve su gibi temel ihtiyaç malzemelerini satın alabilirler.

### 5. Test Mekanizmaları
- Geliştirme ve test süreçlerini hızlandırmak için arayüze "+50 HP" ve "Seviye Atla" gibi test butonları eklenmiştir.

## 🛠️ Teknik Yapı

- **Platform:** iOS (iPhone & iPad uyumlu)
- **Geliştirme Ortamı:** Xcode
- **Dil:** Swift
- **UI Framework:** SwiftUI
- **Mimari:** Model-View-ViewModel (MVVM)
  - **Models:** `Pet.swift` gibi temel veri yapılarını içerir.
  - **Views:** `MainGameView`, `PetShopView` gibi SwiftUI arayüz bileşenlerini barındırır.
  - **ViewModels:** `PetViewModel` gibi arayüz ve model arasındaki iş mantığını yöneten sınıfları içerir.
- **Veri Kalıcılığı:** Oyuncunun ilerlemesi, `UserDefaults` ve `Codable` protokolü kullanılarak cihaz hafızasına kaydedilir.

## 🚀 Projeyi Çalıştırma

1.  Proje dosyalarını bilgisayarınıza klonlayın veya indirin.
2.  `FriendsOfAda.xcodeproj` dosyasını Xcode ile açın.
3.  Eğer daha önce yapmadıysanız, oluşturulan yeni dosyaların (`Views`, `ViewModels` vb. içindeki) projenin ana hedefine dahil edildiğinden emin olun:
    - Her bir `.swift` dosyasına tıklayın.
    - Sağdaki **File Inspector** panelinde, **Target Membership** bölümünde **"FriendsOfAda"**'nın yanındaki kutucuğun işaretli olduğunu kontrol edin.
4.  Bir iOS Simülatörü (örn: iPhone 16) veya fiziksel bir cihaz seçin.
5.  Xcode'un sol üst köşesindeki "Run" (Oynat ►) butonuna tıklayarak projeyi derleyin ve çalıştırın.

## 📝 Sonraki Adımlar ve Gelecek Geliştirmeler

- **Görsel ve İşitsel Varlıkların Entegrasyonu:** Sağlanacak olan 2D hayvan varlıkları, animasyonlar, özel arayüz elemanları ve ses efektlerinin projeye eklenmesi.
- **Yeni Mini Oyunlar:** "Labirent" ve "Şekil/Renk Eşleştirme" gibi GDD'de belirtilen diğer mini oyunların geliştirilmesi.
- **Mekanların Geliştirilmesi:** "Park" ve "Veteriner" gibi açılabilir mekanların kendi iç arayüzlerinin ve işlevlerinin kodlanması. 