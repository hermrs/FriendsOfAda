import Foundation
import Combine

class MathMinigameViewModel: ObservableObject {
    
    @Published var question: String = ""
    @Published var answerChoices: [Int] = []
    
    private var correctAnswer: Int = 0
    var onGameEnd: ((_ wasCorrect: Bool) -> Void)?
    
    init() {
        generateNewQuestion()
    }
    
    func generateNewQuestion() {
        let a = Int.random(in: 1...10)
        let b = Int.random(in: 1...10)
        
        // Ensure result is not negative for subtraction
        let (num1, num2) = a > b ? (a, b) : (b, a)
        
        if Bool.random() { // 50% chance for addition or subtraction
            // Addition
            correctAnswer = num1 + num2
            question = "\(num1) + \(num2) = ?"
        } else {
            // Subtraction
            correctAnswer = num1 - num2
            question = "\(num1) - \(num2) = ?"
        }
        
        generateAnswerChoices()
    }
    
    private func generateAnswerChoices() {
        var choices = Set<Int>()
        choices.insert(correctAnswer)
        
        // Generate 2 other unique wrong answers
        while choices.count < 3 {
            let wrongAnswer = Int.random(in: max(0, correctAnswer - 5)...(correctAnswer + 5))
            if wrongAnswer != correctAnswer {
                choices.insert(wrongAnswer)
            }
        }
        
        answerChoices = Array(choices).shuffled()
    }
    
    func checkAnswer(_ selectedAnswer: Int) {
        let wasCorrect = selectedAnswer == correctAnswer
        // We call the completion handler to notify the parent view
        onGameEnd?(wasCorrect)
    }
} 