//
//  TriviaQuestionView.swift
//  Trivia Game
//
//  Created by Elias Woldie on 3/29/24.
//

import SwiftUI

struct TriviaQuestionView: View {
    @ObservedObject var gameManager: GameManager
    @State private var selectedAnswer: String?
    @Binding var showTrivia: Bool

    
    var body: some View {
        VStack {
            if let question = gameManager.getCurrentQuestion() {
                Text(question.question)
                    .font(.title)
                    .padding()

                ForEach(question.allAnswers, id: \.self) { answer in
                    Button(action: {
                        self.selectedAnswer = answer
                        self.gameManager.answerQuestion(with: answer)
                    }) {
                        Text(answer)
                            .padding()
                            .foregroundColor(.white)
                            .background(self.selectedAnswer == answer ? Color.blue : Color.gray)
                            .cornerRadius(10)
                    }
                }
            } else {
                // Display the score or a message if the game has ended
                Text("Game Over! Your score: \(gameManager.score)")
                    .font(.title)
                    .padding()
            }
        }
        .alert(isPresented: $gameManager.gameEnded) {
            Alert(title: Text("Trivia Complete!"), message: Text("Your score: \(gameManager.score)"), dismissButton: .default(Text("Play Again"), action: {
                self.gameManager.restartGame()
            }))
        }
    }
}



struct TriviaQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock GameManager for previews
        let gameManager = GameManager()
        // Load it with at least one TriviaQuestion
        gameManager.loadQuestions([
            TriviaQuestion(category: "General Knowledge",
                           type: "multiple",
                           difficulty: "medium",
                           question: "What is the capital of France?",
                           correct_answer: "Paris",
                           incorrect_answers: ["Madrid", "Berlin", "Rome"])
        ])
        return TriviaQuestionView(gameManager: gameManager, showTrivia: .constant(true))
    }
}

