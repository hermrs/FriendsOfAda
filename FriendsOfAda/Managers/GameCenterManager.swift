import GameKit

final class GameCenterManager {
    static let shared = GameCenterManager()
    
    // The local player object.
    private let localPlayer = GKLocalPlayer.local
    
    private init() {}
    
    /// Authenticates the local player with Game Center.
    func authenticatePlayer(presentingVC: UIViewController) {
        localPlayer.authenticateHandler = { viewController, error in
            if let vc = viewController {
                // If Game Center needs to show a login view controller, present it.
                presentingVC.present(vc, animated: true, completion: nil)
                return
            }
            if let error = error {
                print("Game Center Error: \(error.localizedDescription)")
                return
            }
            
            // Player is authenticated
            print("Game Center: Player authenticated successfully.")
            print("Player Alias: \(self.localPlayer.alias)")
        }
    }
    
    /// Reports an achievement to Game Center.
    /// - Parameters:
    ///   - identifier: The unique identifier for the achievement (from App Store Connect).
    ///   - percentComplete: The percentage of the achievement that is complete (100.0 for a full unlock).
    func reportAchievement(identifier: String, percentComplete: Double) {
        guard localPlayer.isAuthenticated else {
            print("Cannot report achievement: Player is not authenticated.")
            return
        }
        
        let achievement = GKAchievement(identifier: identifier)
        achievement.percentComplete = percentComplete
        achievement.showsCompletionBanner = true // Show the "Achievement Unlocked" banner
        
        GKAchievement.report([achievement]) { error in
            if let error = error {
                print("Error reporting achievement: \(error.localizedDescription)")
            } else {
                print("Successfully reported achievement: \(identifier)")
            }
        }
    }
} 