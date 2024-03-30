//
//  TriviaNetworkingManager.swift
//  Trivia Game
//
//  Created by Elias Woldie on 3/29/24.
//

import Foundation

class TriviaNetworkingManager {
    // Function to fetch trivia questions
    func fetchTriviaQuestions(amount: Int, category: Int?, difficulty: String, type: String, completion: @escaping (Result<[TriviaQuestion], Error>) -> Void) {
        // Construct the URL with query parameters
        var components = URLComponents(string: "https://opentdb.com/api.php")
        var queryItems = [URLQueryItem(name: "amount", value: "\(amount)"),
                          URLQueryItem(name: "type", value: type)]
        
        if let category = category {
            queryItems.append(URLQueryItem(name: "category", value: "\(category)"))
        }
        
        if difficulty != "any" {
            queryItems.append(URLQueryItem(name: "difficulty", value: difficulty))
        }
        
        components?.queryItems = queryItems
        
        guard let url = components?.url else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        // Create the URL request
        let request = URLRequest(url: url)
        
        // Make the API call
        URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Parse the data
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                // Decode the JSON into our Swift structs
                let decoder = JSONDecoder()
                let triviaResponse = try decoder.decode(TriviaResponse.self, from: data)
                completion(.success(triviaResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
