//
//  SecondPanelView.swift
//  Yahtzee
//

import SwiftUI
import SwiftData

struct SecondPanelView: View {
    
    // MARK: - PROPERTIES
    @Query var gamedata: [GameData]
    let categorymodel = CategoryModel()
    let scoremodel = ScoreModel()
    
    let category: String
    let dicesArray: [Dice]
    
    private let unselectPanelColor = "#d8ffb2"
    
    // MARK: - BODY
    
    var body: some View {
        
        let score = scoremodel.caculateScore(dicesArray, index: categorymodel.returnIndex(category))
        let index = categorymodel.returnIndex(category)
        let scoreAlreadyWritten = ( gamedata[0].scoresArray[ categorymodel.returnIndex(category) ] != nil )

        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white)
            .fill( scoreAlreadyWritten ? Color.white : ( index == gamedata[0].penTarget ? Color.green : Color(UIColor(hex: unselectPanelColor)) ) )
            .scaledToFit()
            .shadow(radius: 0, y: 6)
            .overlay{
                if scoreAlreadyWritten {
                    Text("\(gamedata[0].scoresArray[index]!)")
                        .font(gamedata[0].scoresArray[index]!<=99 ? .title : .subheadline)
                        .fontWeight(.black)
                        .foregroundStyle(.black)
                } else {
                    Text("\(score)")
                        .font(score<=99 ? .title : .subheadline)
                        .fontWeight(.black)
                        .foregroundStyle( index == gamedata[0].penTarget ? .black : .gray)
                }
            }
            .onTapGesture {
                if !(scoreAlreadyWritten) {
                    
                    if index != gamedata[0].penTarget {
                        gamedata[0].penTarget = index
                    } else {
                        gamedata[0].penTarget = nil
                    }
                }
            }
        
    }
}

#Preview {
    
    struct Preview: View {
        @State var diceArray = Array(repeating: Dice(value: 3), count: 5)
        
        var body: some View {
            SecondPanelView(category: "threes", dicesArray: diceArray)
                .modelContainer(for: GameData.self)
        }
    }
    return Preview()
    
}
