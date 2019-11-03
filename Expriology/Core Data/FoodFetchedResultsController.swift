//
//  FoodFetchedResultsController.swift
//  Expriology
//
//  Created by Harish Yerra on 11/3/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import CoreData
import UIKit

/// An `NSFetchedResultsController` for `Food`.
public class FoodFetchedResultsController: NSFetchedResultsController<Food>, NSFetchedResultsControllerDelegate {
    /// The collection view you are managing.
    private let collectionView: UICollectionView
    
    /// Whether or not the fetched results controller should update the table view.
    public var shouldUpdateCollectionView: Bool = false
    
    public init(managedObjectContext: NSManagedObjectContext, collectionView: UICollectionView) throws {
        self.collectionView = collectionView
        
        let request: NSFetchRequest<Food> = Food.fetchRequest()
        let nextWeekDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date())!
        let dateSortDescriptor = NSSortDescriptor(key: "expirationDate", ascending: true)
        request.sortDescriptors = [dateSortDescriptor]
        request.predicate = NSPredicate(format: "expirationDate <= %@", nextWeekDate as NSDate)
        super.init(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        delegate = self
        
        try performFetch()
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        collectionView.reloadData()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        collectionView.reloadData()
    }
}
