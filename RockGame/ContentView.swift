//
//  ContentView.swift
//  RockGame
//
//  Created by Diplomado on 02/08/24.
//

import SwiftUI

struct ContentView: View {
    // Opciones del juego
    enum Option: String, CaseIterable {
        case rock = "rock"
        case paper = "paper"
        case scissors = "scissors"
    }
    
    // Estructura para almacenar los resultados de cada partida
    struct GameResult: Identifiable {
        let id = UUID()
        let userChoice: Option
        let computerChoice: Option
        let result: String
    }
    
    @State private var userChoice: Option?
    @State private var computerChoice: Option?
    @State private var result: String = ""
    @State private var gameResults: [GameResult] = []
    @State private var countUser: Int = 0
    @State private var countComputer: Int = 0
    @State private var lead: String = "Draw"
    @State private var count: CGFloat = 0
    
    var body: some View {
        VStack {
            // Botones de seleccion
            HStack {
                ForEach(Option.allCases, id: \.self) { option in
                    Button(action: {
                        self.playGame(userChoice: option)
                        withAnimation(.easeIn) {
                            count += 1
                        }
                    }) {
                        Image("\(option.rawValue)")
                            .resizable()
                            .frame(width: 100, height: 100)
                        //                        Text(option.rawValue)
                        //                            .padding()
                        //                            .background(Color.blue)
                        //                            .foregroundColor(.white)
                        //                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            
            // Texto con las selecciones y el resultado
            VStack {
                if let userChoice = userChoice, let computerChoice = computerChoice {
                    Text("\(userChoice.rawValue) Vs \(computerChoice.rawValue) --> \(result)")
                        .padding()
                        .shake(count: count)
                }
                
                if countUser == 0 && countComputer == 0 || countUser == countComputer {
                    HStack{
                        Text("Winner: ")
                        Spacer()
                        Text("Draw")
                    }
                } else {
                    HStack{
                        Text("Winner: ")
                        Spacer()
                        Text("\(countUser > countComputer ? "User" : "Computer")")
                    }
                }
            }
            .padding()
            
            // Tabla de resultados
            List(gameResults) { game in
                HStack {
                    Text("\(game.userChoice.rawValue) Vs \(game.computerChoice.rawValue) --> \(game.result)")
                }
            }
        }
    }
    
    func playGame(userChoice: Option) {
        self.userChoice = userChoice
        let computerChoice = Option.allCases.randomElement()!
        self.computerChoice = computerChoice
        
        // Para saber el resultado
        if userChoice == computerChoice {
            result = "Draw"
        } else if (userChoice == .rock && computerChoice == .scissors) ||
                    (userChoice == .paper && computerChoice == .rock) ||
                    (userChoice == .scissors && computerChoice == .paper) {
            result = "Win"
            
            // aumentamos el contador de Usuario
            countUser += 1
        } else {
            result = "Lose"
            
            // Aumentamos el contador de la computadora
            countComputer += 1
        }
        
//        switch(userChoice, computerChoice):
//    case (.papel, .pieda):
        
        
        // Para agregar el resultado a la lista
        let gameResult = GameResult(userChoice: userChoice, computerChoice: computerChoice, result: result)
        gameResults.append(gameResult)
    }
}

#Preview {
    ContentView()
}

struct Shake: ViewModifier, Animatable {
    var count: CGFloat = 0
    
    init(count: CGFloat) {
        self.count = count
    }
    
    var animatableData: CGFloat {
        get { count }
        set { count = newValue }
    }
    
    func body(content: Content) -> some View {
        print(count)
        let offset = -sin(count * 2 * .pi) * 20
        return content.offset(x: offset)
    }
}

extension View {
    func shake(count: CGFloat) -> some View {
        modifier(Shake(count: count))
    }
}
