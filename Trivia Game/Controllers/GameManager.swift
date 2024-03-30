//
//  GameManager.swift
//  Trivia Game
//
//  Created by Elias Woldie on 3/29/24.
//

import Foundation

class GameManager: ObservableObject {
    @Published var questions: [TriviaQuestion] = []
    @Published var currentQuestionIndex = 0
    @Published var score = 0
    @Published var gameEnded = false
    @Published var selectedAnswer: String?

    func loadQuestions(_ questions: [TriviaQuestion]) {
        self.questions = questions
        self.currentQuestionIndex = 0
        self.score = 0
        self.gameEnded = false
    }

    func answerQuestion(with answer: String) {
         let currentQuestion = questions[currentQuestionIndex]
         if answer == currentQuestion.correct_answer {
             score += 1
         }
         
         currentQuestionIndex += 1
         selectedAnswer = nil
         
         if isLastQuestion() {
             gameEnded = true
         }
     }
    func isLastQuestion() -> Bool {
        return currentQuestionIndex >= questions.count
    }

    func getCurrentQuestion() -> TriviaQuestion? {
        if !isLastQuestion() {
            return questions[currentQuestionIndex]
        }
        return nil
    }

    func restartGame() {
        loadQuestions(questions)
    }
}
