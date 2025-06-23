import UIKit

// Geçici olarak basitleştirilmiş HapticManager
// Bu sürüm, CoreHaptics derleme sorununu yalıtmak için yalnızca UIKit kullanır.
class HapticManager {
    static let shared = HapticManager()
    
    private init() { }
    
    // Başarı durumları için standart bir bildirim titreşimi
    func playSuccess() {
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        }
    }

    // Sevme etkileşimi için yumuşak bir dokunma hissi
    func playPetting() {
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.prepare()
            generator.impactOccurred()
        }
    }
} 
