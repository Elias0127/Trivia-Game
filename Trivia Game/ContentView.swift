//
//  ContentView.swift
//  Trivia Game
//
//  Created by Elias Woldie on 3/29/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var gameManager = GameManager() // The game manager instance
    @State private var showTrivia = false // Flag to determine whether to show the trivia questions

    var body: some View {
        NavigationView {
            if !showTrivia {
                OptionsView(gameManager: gameManager, showTrivia: $showTrivia)
            } else {
                // Make sure that `TriviaQuestionView` is updated to accept `gameManager` and `$showTrivia`
                TriviaQuestionView(gameManager: gameManager, showTrivia: $showTrivia)
            }
        }
    }
}

// Since you already have a preview setup, you can leave it as is or update it to preview the actual content.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

