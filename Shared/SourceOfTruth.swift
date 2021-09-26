//
//  SourceOfTruth.swift
//  InfiniteScroll
//
//  Created by Thiago on 26/09/21.
//

import SwiftUI

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct PokemonListResponse: Codable {
    let count: Int?
    let netx: String?
    let previous: String?
    let results: Array<Pokemon>?
}

class SourceOfTruth: ObservableObject {
    
    let apiUrl = "https://pokeapi.co/api/v2/pokemon?offset="
    
    var isLoading: Bool = false
    
    @Published var pokemons = [Pokemon]()
    
    func load(offset: Int = 0, limit: Int = 10) {
        if isLoading {
            return
        }
        
        self.isLoading = true
        
        let fullApiUrl = self.apiUrl + String(offset)
        print(fullApiUrl)
        
        let requestTask = URLSession.shared.dataTask(with: URL(string: fullApiUrl)!, completionHandler: { data, response, error in
            
            self.isLoading = false
            guard let data = data, error == nil else {
                print("Api error")
                return
            }
            
          
            var result: PokemonListResponse?
            
            do{
                result = try JSONDecoder().decode(PokemonListResponse.self, from: data)
                
            }
            catch {
                print("Responde decode error \(error.localizedDescription)")
            }
            
            guard let json = result else {
                return
            }
            
            let pokemonList : Array<Pokemon> = json.results!
            
            
            DispatchQueue.main.async {
                self.pokemons.append(contentsOf: pokemonList)
            }
        })
        
        requestTask.resume()
    }
}
