//
//  ButtonView.swift
//  Yahtzee
//

import SwiftUI
import SwiftData

struct ButtonView: View {
    
    // MARK: - PROPERTIES
    @StateObject var viewModel: ButtonViewModel
    
    // MARK: - BODY
    
    var body: some View {
        
        
        HStack {
            // ROLL BUTTON
            Button(action: {
                viewModel.rollDice()
            }, // ACTION
                   label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(Color.yellow)
                        .fontWeight(.bold)
                        .frame(maxHeight: 60)
                        .frame(maxWidth: .infinity)
                        .shadow(color: .black, radius: 0, x: 2, y: 2)
                    
                    HStack {
                        Text("ROLL")
                            .bold()
                            .foregroundStyle(Color.black)
                        
                        ForEach(0 ... 2 , id: \.self) { index in
                            Circle()
                                .scaledToFit()
                                .frame(maxWidth: 25)
                                .foregroundStyle(viewModel.rollCount > index ? Color.green : Color.gray)
                        }
                        
                    } // HSTACK
                } // ZSTACK
            } // LABEL
            ) // ROLL BUTTON
            
            // PLAY BUTTON
            if viewModel.rollCount < 3 {
                Button(action: {
                    viewModel.play()
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundStyle(Color.green)
                            .fontWeight(.bold)
                            .frame(height: 60)
                            .frame(maxWidth: .infinity)
                            .shadow(color: .black, radius: 0, x: 2, y: 2)
                        
                        Text("PLAY")
                            .bold()
                            .foregroundStyle(Color.white)
                            .shadow(color: .black, radius: 0, x: 2, y: 2)
                    }
                }) // PLAY BUTTON
            }
        } // HSTACK
        
    }
    
    
}

#Preview("Preview") {

    let container = try! ModelContainer(for: GameData.self, ScoreBoard.self, Dice.self)
    let context = container.mainContext

    let previewGameData = generateInitialData()
    context.insert(previewGameData)
    try? context.save()

    let penObject = PenObject()
    let router = Router()
    let audioManager = AudioManager()

    let viewModel = ButtonViewModel(
        gameData: previewGameData,
        modelContext: context,
        penObject: penObject,
        router: router,
        audioManager: audioManager
    )

    return ButtonView(viewModel: viewModel)
        .environmentObject(penObject)
        .environmentObject(router)
        .modelContainer(container)
}
