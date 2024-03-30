//
//  TriviaModels.swift
//  Trivia Game
//
//  Created by Elias Woldie on 3/29/24.
//

import Foundation

struct TriviaResponse: Codable {
    let results: [TriviaQuestion]
}

struct TriviaQuestion: Codable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    
    // Computed property to get all answers
    var allAnswers: [String] {
        var answers = incorrect_answers
        answers.insert(correct_answer, at: Int.random(in: 0...answers.count))
        return answers
    }
}

