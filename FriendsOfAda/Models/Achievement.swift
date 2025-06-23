import Foundation

enum Achievement: String, CaseIterable, Codable {
    case firstFeed = "first_feed"
    case longWalk = "long_walk"
    case mathGenius = "math_genius"
    case petLover = "pet_lover"
    case shoppingSpree = "shopping_spree"
    
    var title: String {
        switch self {
        case .firstFeed:
            return "First Meal"
        case .longWalk:
            return "Pro Walker"
        case .mathGenius:
            return "Math Genius"
        case .petLover:
            return "Pet Lover"
        case .shoppingSpree:
            return "Big Spender"
        }
    }
    
    var description: String {
        switch self {
        case .firstFeed:
            return "You fed your pet for the first time."
        case .longWalk:
            return "You walked over 1km in a single walk."
        case .mathGenius:
            return "You scored over 50 points in the Math Game."
        case .petLover:
            return "You've petted your animal 25 times."
        case .shoppingSpree:
            return "You've spent over 500 AdaCoins in the Pet Shop."
        }
    }
    
    var iconName: String {
        switch self {
        case .firstFeed:
            return "fork.knife.circle.fill"
        case .longWalk:
            return "figure.walk.circle.fill"
        case .mathGenius:
            return "brain.head.profile.fill"
        case .petLover:
            return "heart.circle.fill"
        case .shoppingSpree:
            return "cart.circle.fill"
        }
    }
} 