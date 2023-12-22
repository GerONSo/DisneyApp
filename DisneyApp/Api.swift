//
//  Api.swift
//  DisneyApp
//
//  Created by Sergey Goncharov on 22.12.2023.
//

import Foundation
import os

class Api {
    
    func get(url: String = "https://api.disneyapi.dev/character") async -> LocalData? {
        let components = URLComponents(string: url)!
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        do {
            let (resultData, _) = try await URLSession.shared.data(for: request)
            let data = try JSONDecoder().decode(LocalData.self, from: resultData)
            return data
        } catch let error {
            print("\(error.localizedDescription)")
            return nil
        }
    }
}
