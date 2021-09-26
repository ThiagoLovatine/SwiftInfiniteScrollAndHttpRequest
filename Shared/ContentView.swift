//
//  ContentView.swift
//  Shared
//
//  Created by Thiago on 26/09/21.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var sot = SourceOfTruth()
    
    @State var offset = 0
    
    init(){
        sot.load(offset: self.offset)
    }
    
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVStack{
                    ForEach(sot.pokemons.indices, id: \.self) { pokemonIndex in
                        let pokemon = sot.pokemons[pokemonIndex]
                        
                        Text("\(pokemon.name)")
                            .padding(.vertical, 30)
                            .onAppear{
                                if pokemonIndex == sot.pokemons.count - 5 {
                                    self.offset = sot.pokemons.count + self.offset
                                    sot.load(offset: self.offset)
                                }
                            }
                    }.navigationTitle("Pokemons")
                }
                
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
