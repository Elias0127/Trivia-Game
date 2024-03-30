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
        NavigationView {
            VStack(spacing: 20) {
                // Display the current question
                if let question = gameManager.getCurrentQuestion() {
                    Text(question.question)
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Display the answers as tappable cards
                    VStack(spacing: 10) {
                        ForEach(question.allAnswers, id: \.self) { answer in
                            AnswerButton(answer: answer, selectedAnswer: $selectedAnswer) {
                                self.selectedAnswer = answer
                                self.gameManager.answerQuestion(with: answer)
                            }
                        }
                    }
                    .padding(.horizontal)
                } else {
                    // Game Over State
                    Text("Please choose categories")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                }
            }
            .padding(.top)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    withAnimation {
                        self.showTrivia = false
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.blue)
                        .padding()
                }
            )
            .alert(isPresented: $gameManager.gameEnded) {
                Alert(
                    title: Text("Trivia Complete!"),
                    message: Text("Your score: \(gameManager.score)"),
                    dismissButton: .default(Text("Play Again"), action: {
                        self.selectedAnswer = nil
                        self.showTrivia = false
                        self.gameManager.restartGame()
                    })
                )
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AnswerButton: View {
    let answer: String
    @Binding var selectedAnswer: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(answer)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: selectedAnswer == answer ? 3 : 0)
                    )
            }
        }
        .padding(.horizontal)
    }
}


struct TriviaQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a mock GameManager for the preview
        let gameManager = GameManager()
        // Mock data setup...
        return TriviaQuestionView(gameManager: gameManager, showTrivia: .constant(true))
    }
}

