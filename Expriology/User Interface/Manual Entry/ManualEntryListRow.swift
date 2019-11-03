//
//  ManualEntryListRow.swift
//  Expriology
//
//  Created by Harish Yerra on 11/3/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import SwiftUI

struct ManualEntryListRow: View {
    var food: ExpirologyExpiration
    var expirationDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        let date = Calendar.current.date(byAdding: .day, value: food.daysTillExpiration, to: Date())!
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(food.name.capitalized).font(.headline)
            Text(expirationDate).font(.footnote)
        }
    }
}

struct ManualEntryListRow_Previews: PreviewProvider {
    static var previews: some View {
        ManualEntryListRow(food: ExpirologyExpiration(daysTillExpiration: 4, name: "Apple"))
    }
}
