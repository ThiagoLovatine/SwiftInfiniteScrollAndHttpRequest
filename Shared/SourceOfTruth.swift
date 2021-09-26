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
        
//        print("getting", index)
//
//        switch index {
//        case 0:
//            animals.append(contentsOf: [
//                Animal(id: 1, emoji: "🐶", name: "Dog"),
//                Animal(id: 2, emoji: "🐱", name: "Cat"),
//                Animal(id: 3, emoji: "🐭", name: "Mouse"),
//                Animal(id: 4, emoji: "🐹", name: "Hamster"),
//                Animal(id: 5, emoji: "🐰", name: "Rabbit"),
//                Animal(id: 6, emoji: "🦊", name: "Fox"),
//                Animal(id: 7, emoji: "🐻", name: "Bear"),
//                Animal(id: 8, emoji: "🐼", name: "Panda"),
//                Animal(id: 9, emoji: "🐻‍❄️", name: "Polar Bear"),
//                Animal(id: 10, emoji: "🐨", name: "Koala"),
//                Animal(id: 11, emoji: "🐯", name: "Tiger"),
//                Animal(id: 12, emoji: "🦁", name: "Lion"),
//                Animal(id: 13, emoji: "🐮", name: "Cow"),
//                Animal(id: 14, emoji: "🐷", name: "Pig"),
//                Animal(id: 15, emoji: "🐸", name: "Frog")
//            ])
//
//        case 1:
//            animals.append(contentsOf: [
//                Animal(id: 16, emoji: "🐵", name: "Monkey"),
//                Animal(id: 17, emoji: "🐔", name: "Chicken"),
//                Animal(id: 18, emoji: "🐧", name: "Penguin"),
//                Animal(id: 19, emoji: "🐦", name: "Bird"),
//                Animal(id: 20, emoji: "🐤", name: "Chick"),
//                Animal(id: 21, emoji: "🦆", name: "Duck"),
//                Animal(id: 22, emoji: "🦅", name: "Eagle"),
//                Animal(id: 23, emoji: "🦉", name: "Owl"),
//                Animal(id: 24, emoji: "🦇", name: "Bat"),
//                Animal(id: 25, emoji: "🐺", name: "Wolf"),
//                Animal(id: 26, emoji: "🐗", name: "Boar"),
//                Animal(id: 27, emoji: "🐴", name: "Horse"),
//                Animal(id: 28, emoji: "🦄", name: "Unicorn"),
//                Animal(id: 29, emoji: "🐝", name: "Bee"),
//                Animal(id: 30, emoji: "🐛", name: "Bug")
//            ])
//
//        default:
//            break
//        }
    }
}
