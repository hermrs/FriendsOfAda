# Ada's Friends (iOS)

## 1. Projeye Genel Bakış

**Ada's Friends**, 4-8 yaş arası çocuklara yönelik, onlara hayvan sevgisi ve sorumluluk bilinci aşılamayı hedefleyen eğitici bir evcil hayvan bakım oyunudur. Oyuncular, Ada karakteri aracılığıyla bir kedi veya köpek sahiplenir ve onun temel ihtiyaçlarını (beslenme, temizlik, sevgi vb.) karşılayarak "Mutluluk Puanı" ve "AdaCoin" kazanır. Bu süreç, temel bilişsel becerileri geliştiren mini oyunlarla desteklenmektedir.

Bu proje, Xcode ortamında, Swift ve SwiftUI kullanılarak native bir iOS uygulaması olarak geliştirilmektedir.

## 2. Projenin Mevcut Durumu

Projenin temel oynanış mekanikleri ve arayüz iskeleti tamamlanmıştır. Uygulama şu anda çalışır durumdadır ve aşağıdaki özelliklerin tümü entegre edilmiştir. Proje, görsel ve işitsel varlıkların (karakter animasyonları, özel ikonlar, ses efektleri vb.) eklenmesi için hazır durumdadır.

## 3. Geliştirilen Özellikler

- **Evcil Hayvan Simülasyonu:**
  - Evcil hayvanın Açlık, Susuzluk, Hijyen, Sevgi ve Enerji gibi dinamik ihtiyaçları bulunmaktadır.
  - Bu ihtiyaçlar zamanla otomatik olarak azalır.
  - İhtiyaçlar, ana ekranda ilerleme çubukları ile görsel olarak takip edilebilir.

- **İlerleme ve Seviye Sistemi:**
  - Oyuncular, hayvanlarına baktıkça ve mini oyunları tamamladıkça "Mutluluk Puanı" (HP) kazanır.
  - Yeterli puana ulaşıldığında evcil hayvan seviye atlar.
  - Seviye atlamak, yeni mekanların (Pet Shop vb.) kilidini açar.

- **Oyun İçi Ekonomi (AdaCoin):**
  - Oyuncular, kazandıkları mutluluk puanı kadar "AdaCoin" elde eder.
  - Mama ve su gibi temel ihtiyaç maddeleri artık sınırlı sayıdadır ve envanterde tutulur.
  - Oyuncular, kazandıkları coin'leri Pet Shop'ta harcayarak envanterlerini yenileyebilirler.

- **Mini Oyunlar:**
  - **Matematik Konservesi:** Oyuncunun basit matematik sorularını çözerek puan kazandığı, tekrar oynanabilir bir mini oyun.
  - **Hafıza Kartları:** Oyuncunun hayvan temalı kartları eşleştirerek ödül kazandığı bir mini oyun.

- **Kilitlenebilir İçerik:**
  - **Pet Shop**, **Park** ve **Veteriner** gibi mekanlar oyun başlangıcında kilitlidir.
  - Bu mekanların kilidi, belirli seviyelere ulaşıldığında otomatik olarak açılır.

- **Veri Kalıcılığı:**
  - Oyuncunun tüm ilerlemesi (`Pet` modeli dahilinde seviye, puanlar, coin'ler, envanter ve ihtiyaç durumları) `UserDefaults` kullanılarak cihaz hafızasına kaydedilir. Uygulama kapatılıp açıldığında kaldığı yerden devam eder.

- **Test Mekanizmaları:**
  - Arayüze, ilerleme sistemini kolayca test etmek için anında puan ekleyen ve seviye atlatan test butonları eklenmiştir.

## 4. Proje Nasıl Çalıştırılır?

1.  Bu projeyi klonlayın veya indirin.
2.  `FriendsOfAda.xcodeproj` dosyasını Xcode ile açın.
3.  Bir iOS simülatörü (örn: iPhone 15 Pro) veya bağlı bir fiziksel cihaz seçin.
4.  Derlemek ve çalıştırmak için "Run" (Oynat) butonuna tıklayın veya `Cmd + R` klavye kısayolunu kullanın.

**Not:** Eğer dosyalar projede görünmüyor veya "cannot find in scope" hatası alınıyorsa, yeni eklenen dosyaların "Target Membership" ayarının işaretli olduğundan emin olun.

## 5. Proje Yapısı

Proje, kodun organize ve yönetilebilir olmasını sağlamak için aşağıdaki klasör yapısını kullanır:

-   `Models/`: Temel veri yapılarını içerir (`Pet.swift`).
-   `ViewModels/`: İş mantığını ve arayüz durumunu yöneten sınıfları içerir (`PetViewModel`, `MathMinigameViewModel` vb.).
-   `Views/`: SwiftUI arayüz bileşenlerini içerir.
    -   `MiniGames/`: Mini oyunların arayüzlerini barındırır.
    -   `PetShopView.swift`: Pet Shop arayüzü.
    -   `MainGameView.swift`: Ana oyun ekranı.
-   `Controllers/`: UIKit yaşam döngüsü yöneticilerini içerir (şu an için büyük ölçüde `AppDelegate` tarafından yönetiliyor).
-   `Scenes/`: SpriteKit ile ilgili dosyaları barındırır (projenin ilk şablonundan kalanlar).
-   `Assets.xcassets/`: Uygulama ikonu, renkler ve resimler gibi görsel varlıkları içerir.

## 6. Sonraki Adımlar

-   **Görsel Varlıkların Entegrasyonu:** Tasarım ekibinden gelecek olan 2D karakter, animasyon, ikon ve arayüz elemanlarının projeye eklenmesi.
-   **Ses Entegrasyonu:** Ses efektlerinin ve arka plan müziklerinin ilgili kullanıcı etkileşimlerine bağlanması.
-   **Yeni İçerik Geliştirme:**
    -   Pet Shop, Park ve Veteriner gibi kilidi açılan mekanların tam işlevselliğinin geliştirilmesi.
    -   GDD'de belirtilen diğer mini oyunların ("Labirent", "Şekil Eşleştirme" vb.) geliştirilmesi. 