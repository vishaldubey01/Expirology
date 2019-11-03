//
//  ManualEntryView.swift
//  Expriology
//
//  Created by Harish Yerra on 11/3/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import SwiftUI

struct ManualEntryView: View {
    
    @State var searchText = ""
    @State var showCancelButton: Bool = false
    
    @State var searchResults: [ExpirologyExpiration] = []
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, completion: {
                self.retrieveSearchResults()
            })
            List(searchResults) { result in
                Button (action: {
                  let food = Food(context: DataController.shared.persistentContainer.viewContext)
                  food.name = result.name
                  food.expirationDate = Calendar.current.date(byAdding: .day, value: result.daysTillExpiration, to: Date())
                  DataController.shared.saveContext()
                    FoodListViewModel.shared.fetchAllFoods()
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                  //How the cell should look
                  ManualEntryListRow(food: result)
                }
            }
            .listStyle(GroupedListStyle())
            .resignKeyboardOnDragGesture()
            .onAppear(perform: retrieveSearchResults)
        }
    }
    
    func retrieveSearchResults() {
        let parameters = ExpirologyExpirationParameters(searchTerm: searchText)
        ExpirologyAPIClient.shared.fetchExpiration(using: parameters) { result in
            switch result {
            case .success(let searchResults):
                self .searchResults = searchResults
            case .failure:
                break
            }
        }
    }
}

struct ManualEntryView_Previews: PreviewProvider {
    static var previews: some View {
        ManualEntryView()
    }
}
