//
//  FoodListViewModel.swift
//  Expriology
//
//  Created by Harish Yerra on 11/3/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import CoreData
import SwiftUI
import Combine

class FoodListViewModel: ObservableObject {
    
    static let shared = FoodListViewModel()
    
    @Published var foods = [Food]()
    
    init() {
        fetchAllFoods()
    }
    
    func fetchAllFoods() {
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        let moc = DataController.shared.persistentContainer.viewContext
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        self.foods = try! moc.fetch(fetchRequest)
    }
    
    func fetchFoods(expiringBefore: Date) {
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        let nextWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
        fetchRequest.predicate = NSPredicate(format: "expirationDate <= %@", nextWeekDate as NSDate)
        let moc = DataController.shared.persistentContainer.viewContext
        self.foods = try! moc.fetch(fetchRequest)
    }
    
    func fetchFood(containing name: String) {
        let fetchRequest: NSFetchRequest<Food> = Food.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name contains[c] %@", name)
        let moc = DataController.shared.persistentContainer.viewContext
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSortDescriptor]
        self.foods = try! moc.fetch(fetchRequest)
    }
    
}

extension Food: Identifiable { }
