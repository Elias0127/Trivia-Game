//
//  OptionsView.swift
//  Trivia Game
//
//  Created by Elias Woldie on 3/29/24.
//
import SwiftUI

struct OptionsView: View {
    @State private var selectedNumberOfQuestions = "10"
    @State private var selectedCategoryIndex: Int = 0
    @State private var selectedDifficultyIndex: Int = 0
    @State private var selectedType: String = "Any"
    @ObservedObject var gameManager: GameManager
    @Binding var showTrivia: Bool

    // Options for the picker components
    let categories = [
        "Any Category",
        "General Knowledge",
        "Entertainment: Books",
        "Entertainment: Film",
        "Entertainment: Music",
        "Entertainment: Musicals & Theatres",
        "Entertainment: Television",
        "Entertainment: Video Games",
        "Entertainment: Board Games",
        "Science & Nature",
        "Science: Computers",
        "Science: Mathematics",
        "Mythology",
        "Sports",
        "Geography",
        "History",
        "Politics",
        "Art",
        "Celebrities",
        "Animals",
        "Vehicles",
        "Entertainment: Comics",
        "Science: Gadgets",
        "Entertainment: Japanese Anime & Manga",
        "Entertainment: Cartoon & Animations"
    ]

    let difficulties = ["Any Type", "Easy", "Medium", "Hard"]
    let types = ["Any Type", "Multiple Choice", "True / False"]

    var body: some View {
        NavigationView {
            Form {
                Section {
                    // Number of questions picker
                    TextField("Number of Questions", text: $selectedNumberOfQuestions)
                        .keyboardType(.numberPad)

                    // Category picker
                    Picker("Select Category", selection: $selectedCategoryIndex) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Text(categories[index])
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    // Difficulty selector
                    Picker("Difficulty", selection: $selectedDifficultyIndex) {
                        ForEach(0..<difficulties.count, id: \.self) { index in
                            Text(difficulties[index])
                        }
                    }
                    .pickerStyle(MenuPickerStyle())

                    // Question type selector
                    Picker("Select Type", selection: $selectedType) {
                        ForEach(types, id: \.self) { type in
                            Text(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())


                    Button(action: {
                        self.startTrivia()
                    }) {
                        HStack {
                            Spacer()
                            Text("Start Trivia")
                                .bold()
                            Spacer()
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Trivia Options")
    }

    let networkingManager = TriviaNetworkingManager()

    let categoryMapping: [String: Int?] = [
        "Any Category": nil,
        "General Knowledge": 9,
        "Entertainment: Books": 10,
        "Entertainment: Film": 11,
        "Entertainment: Music": 12,
        "Entertainment: Musicals & Theatres": 13,
        "Entertainment: Television": 14,
        "Entertainment: Video Games": 15,
        "Entertainment: Board Games": 16,
        "Science & Nature": 17,
        "Science: Computers": 18,
        "Science: Mathematics": 19,
        "Mythology": 20,
        "Sports": 21,
        "Geography": 22,
        "History": 23,
        "Politics": 24,
        "Art": 25,
        "Celebrities": 26,
        "Animals": 27,
        "Vehicles": 28,
        "Entertainment: Comics": 29,
        "Science: Gadgets": 30,
        "Entertainment: Japanese Anime & Manga": 31,
        "Entertainment: Cartoon & Animations": 32
    ]

    func startTrivia() {

        guard let numberOfQuestions = Int(selectedNumberOfQuestions), numberOfQuestions > 0 else {
            print("Invalid number of questions")
            return
        }

        let categoryID: Int? = categoryMapping[categories[selectedCategoryIndex]] ?? nil

        let difficulty = selectedDifficultyIndex == 0 ? nil : difficulties[selectedDifficultyIndex].lowercased()

        let type: String?
        if types.contains(selectedType) {
            switch selectedType {
            case "Any Type":
                type = nil
            case "Multiple Choice":
                type = "multiple"
            case "True / False":
                type = "boolean"
            default:
                type = nil
            }
        } else {
            print("Invalid question type selected")
            type = nil
        }

        networkingManager.fetchTriviaQuestions(
              amount: numberOfQuestions,
              category: categoryID,
              difficulty: difficulty ?? "any",
              type: type ?? "any"
          ) { result in
              DispatchQueue.main.async {
                  switch result {
                  case .success(let questions):
                      gameManager.loadQuestions(questions)
                      self.showTrivia = true
                  case .failure(let error):
                      print(error.localizedDescription)
                  }
              }
          }
      }


    struct OptionsView_Previews: PreviewProvider {
        static var previews: some View {
            let gameManager = GameManager()
            OptionsView(gameManager: gameManager, showTrivia: .constant(false))
        }
    }
}
