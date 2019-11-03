//
//  FoodItemRow.swift
//  Expriology
//
//  Created by Harish Yerra on 11/2/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import SwiftUI

struct FoodItemRow: View {
    var food: Food
    var expirationDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: food.expirationDate!)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(food.name!.capitalized).font(.headline)
            Text(expirationDate).font(.footnote)
        }
    }
}

//struct FoodItemRow_Previews: PreviewProvider {
//    static var previews: some View {
//        FoodItemRow()
//    }
//}
