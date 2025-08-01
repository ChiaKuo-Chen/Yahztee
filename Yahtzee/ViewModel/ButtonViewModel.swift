//
//  ButtonViewModel.swift
//  Yahtzee
//
//  Created by 陳嘉國
//

import Foundation
import SwiftUI
import SwiftData

class ButtonViewModel: ObservableObject {

    @Bindable var gameData: GameData
    @Bindable var scoreboard: ScoreBoard
    @Published var rollCount: Int
    
    private let modelContext: ModelContext
    private let penObject: PenObject
    private let router: Router
    private let audioManager: AudioManager

    private let categoryModel = CategoryModel()
    private let scoreModel = ScoreModel()

    var diceArray: [Dice] { gameData.diceArray }
    var canRoll: Bool { rollCount > 0 && diceArray.getDicesHeld().filter({ $0 == true }).count < diceArray.count }
    var canPlay: Bool { penObject.penTarget != nil }
    var totalScore: Int { scoreboard.returnTotalScore() }
    var isGameEnd: Bool { !scoreboard.scoresArray.contains(nil) }

    init(
        gameData: GameData,
        modelContext: ModelContext,
        penObject: PenObject,
        router: Router,
        audioManager: AudioManager = AudioManager()
    ) {
        self.gameData = gameData
        self.scoreboard = gameData.scoreboard[0]
        self.rollCount = gameData.scoreboard[0].rollCount
        self.modelContext = modelContext
        self.penObject = penObject
        self.router = router
        self.audioManager = audioManager
    }

    func rollDice() {
        guard canRoll else { return }

        audioManager.playSound(sound: "diceRoll", type: "mp3")

        for i in 0..<diceArray.count {
            diceArray[i].roll()
        }
        
        rollCount -= 1

        try? modelContext.save()

        for i in 1...6 {
            if diceArray.getDicesNumber().filter({ $0 == i }).count == diceArray.count {
                try? modelContext.save()
                router.path.append(.yahtzee)
            }
        }

        //print("after rolling:", diceArray.getDicesNumber())
    }

    func play() {
        guard let penIndex = penObject.penTarget else {
            print("penObject.penTarget is nil!")
            return
        }
        let newScore = scoreModel.caculateScore(diceArray, category: categoryModel.returnCategory(penIndex))
        scoreboard.updateScoreBoard(newScore: newScore, penIndex: penIndex)
        penObject.leavePaper()

        for i in 0..<diceArray.count {
            diceArray[i].isHeld = false
            diceArray[i].value = 0
        }
        rollCount = 3

        try? modelContext.save()

        if !scoreboard.scoresArray.contains(nil) {
            router.path.append(.end(finalScore: scoreboard.returnTotalScore()))
        }
    }
    
    
}
