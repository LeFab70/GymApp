//
//  ChartViewRanking.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-18.
//

import SwiftUI
import Charts
struct ChartViewRanking: View {
    @State private var db=DataBaseService.shared
    var body: some View {
       VStack{
           Chart{
              // RuleMark(y:.value("Points",800))
                  // .lineStyle(StrokeStyle(lineWidth: 1, dash: [2]))
                   //.foregroundStyle(Color.mint)
               
               ForEach(Array(db.ranking.enumerated()),id: \.offset){index,entry in
                   BarMark(
                    x:.value(index.description,entry.points),
                    y:.value("Users",entry.user)
                   )
                   .foregroundStyle(Color.red.gradient)
               }
           }
           .frame(height: 180)
        }
       .padding()
    }
}

#Preview {
    ChartViewRanking()
}
