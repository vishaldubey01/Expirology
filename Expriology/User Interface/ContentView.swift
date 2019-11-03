//
//  ContentView.swift
//  Expriology
//
//  Created by Harish Yerra on 11/2/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var selection = 1
    
    var body: some View {
        TabView(selection: $selection) {
            TodayView().tabItem {
                VStack {
                    Image(systemName: "rectangle.grid.2x2.fill").font(.system(.title))
                    Text("Today")
                }
            }.tag(1)
            FoodView().tabItem {
                VStack {
                    Image("dish").font(.system(.title))
                    Text("Food")
                }
            }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
