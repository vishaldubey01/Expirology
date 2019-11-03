//
//  ExpiringSoonCollectionViewController.swift
//  Expriology
//
//  Created by Harish Yerra on 11/2/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import UIKit

class ExpiringSoonCollectionViewController: UICollectionViewController {
    static let identifier = "expiringSoonCollectionViewController"
    
    lazy var fetchedResultsController = try? FoodFetchedResultsController(managedObjectContext: DataController.shared.persistentContainer.viewContext, collectionView: collectionView)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.collectionViewLayout = ExpiringSoonCollectionViewFlowLayout()
    }
    
    // MARK: Collection view data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        fetchedResultsController?.sections?[section].numberOfObjects ??  0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpiringSoonCell.reuseIdentifier, for: indexPath) as! ExpiringSoonCell
        cell.backgroundColor = BubbleColor.allCases.randomElement()!.color
        cell.layer.cornerRadius = 8
        guard let food = fetchedResultsController?.object(at: indexPath) else { return cell }
        cell.foodLabel.text = food.name?.capitalized
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        cell.expirationLabel.text = formatter.string(from: food.expirationDate!)
        return cell
    }
    
    // MARK: Collection view delegate

    
}
