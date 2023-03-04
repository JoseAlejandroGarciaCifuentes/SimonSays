//
//  ContentView.swift
//  SimonSays
//
//  Created by Alejandro Garcia on 1/3/23.
//

import SwiftUI

struct ContentView: View {
    
    enum ActivatedColor: Int {
        case first
        case second
        case third
        case fourth
    }
    
    private var gameColors = [(id: 0, color: Color.red),
                              (id: 1, color:Color.blue),
                              (id: 2, color: Color.yellow),
                              (id: 3, color: Color.green)]
    
    @State private var score: Int = 0
    @State private var gameRunning: Bool = false
    
    @State private var activatedColor: ActivatedColor? = nil
    @State private var sequenceIndex = 0
    @State private var randomPositionsInOrder: [Int] = []
    @State private var playersInput: [Int] = []
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Score: \(score)")
                .font(.system(size: 20))
                .foregroundColor(.black)
            
            HStack {
                colorView(gameColors[0].color, isActivated: activatedColor == .first) {
                    playersInput.append(gameColors[0].id)
                }
                .tag(gameColors[0].id)
                
                colorView(gameColors[1].color, isActivated: activatedColor == .second) {
                    playersInput.append(gameColors[1].id)
                }
                .tag(gameColors[1].id)
            }
            
            HStack {
                colorView(gameColors[2].color, isActivated: activatedColor == .third) {
                    playersInput.append(gameColors[2].id)
                }
                .tag(gameColors[2].id)
                
                colorView(gameColors[3].color, isActivated: activatedColor == .fourth) {
                    playersInput.append(gameColors[3].id)
                }
                .tag(gameColors[3].id)
            }
            
            startButton
            
        }
        .padding()
        .background(!gameRunning ? Color.white : Color.white.opacity(0.9))
    }
    
    // MARK: - Accessory Views
    
    func colorView(_ color: Color, isActivated: Bool, action: @escaping () -> ()) -> some View {
        Button {
            action()
            checkResults()
        } label: {
            color
                .clipShape(Circle())
                .opacity(isActivated ? 0.3 : 1)
        }
    }
    
    var startButton: some View {
        Button {
            !gameRunning ? startGame() : stopGame()
        } label: {
            Text(!gameRunning ? "Start" : "Stop")
                .foregroundColor(.black)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(colors: [!gameRunning ? Color.cyan : Color.orange, Color.mint], startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(8)
        }
    }
    
    
    // MARK: - Private Methods
    
    private func startGame() {
        gameRunning = true
        playersInput = []
        let randomAmount: Int = Int.random(in: 1..<5)
        
        randomPositionsInOrder = (0...randomAmount).map { _ in gameColors[Int.random(in: 0..<4)].id }
        
        selectNextColor()
    }
    
    private func stopGame() {
        gameRunning = false
        score = 0
        playersInput = []
        randomPositionsInOrder = []
        activatedColor = nil
    }
    
    func selectNextColor() {
        guard sequenceIndex < randomPositionsInOrder.count else {
            sequenceIndex = 0
            return
        }
        
        let newActivatedColor = ActivatedColor(rawValue: randomPositionsInOrder[sequenceIndex])
        sequenceIndex += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            activatedColor = newActivatedColor
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                activatedColor = nil
                guard gameRunning else { return }
                selectNextColor()
            }
        }
    }
    
    func checkResults() {
        guard gameRunning else { return }
        guard playersInput.count <= randomPositionsInOrder.count
        else {
            stopGame()
            return
        }
        if randomPositionsInOrder == playersInput {
            print("nice")
            score += 1
            startGame()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
