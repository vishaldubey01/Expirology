//
//  TodayView.swift
//  Expriology
//
//  Created by Harish Yerra on 11/2/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import SwiftUI

struct TodayView: View {
    @State private var showingSheet = false
    
    @State var showModal: Bool = false
    @State var modalSelection: Int = 0
    
    @State var receiptImage: UIImage?
    @State var machineLearningImage: UIImage? {
        didSet {
            if let image = $machineLearningImage.wrappedValue {
                processImage(image)
            }
        }
    }
    
    @State private var searchText = ""
    @State private var showCancelButton: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                ExpiringSoonViewController()
                .resignKeyboardOnDragGesture()
            }
            .navigationBarTitle(Text("Expirology"))
            .navigationBarItems(trailing: Button(action: {
                self.showingSheet = true
            }, label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(.title))
            }
            ))
        }
        .actionSheet(isPresented: $showingSheet) {
            ActionSheet(title: Text("Add Food"), message: nil, buttons: [.default(Text("Enter Manually"), action: {
                self.modalSelection = 1
                self.showModal = true
            }), .default(Text("Take a Picture"), action: {
                self.modalSelection = 2
                self.showModal = true
            }), .cancel()])
        }
        .sheet(isPresented: $showModal) {
            if self.modalSelection == 1 {
                ManualEntryView()
            } else if self.modalSelection == 2 {
                CameraView(isShown: self.$showModal, image: self.$machineLearningImage, completion: {
                    if let image = self.$machineLearningImage.wrappedValue {
                        self.processImage(image)
                    }
                })
            }
        }
    }
    
    func processImage(_ image: UIImage) {
        let model = Food101()
        let size = CGSize(width: 299, height: 299)

        guard let buffer = image.resize(to: size)?.pixelBuffer() else {
            fatalError("Scaling or converting to pixel buffer failed!")
        }

        guard let result = try? model.prediction(image: buffer) else {
            fatalError("Prediction failed!")
        }
        
        var query = result.classLabel.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
        query = query == "cup cakes" ? "cupcakes" : query
        if query == "cupcakes" {
            let food = Food(context: DataController.shared.persistentContainer.viewContext)
            food.name = "cupcakes"
            food.expirationDate = Calendar.current.date(byAdding: .day, value: 7, to: Date())
            DataController.shared.saveContext()
            return
        }
        let parameters = ExpirologyExpirationParameters(searchTerm: query)
        ExpirologyAPIClient().fetchExpiration(using: parameters) { result in
            switch result {
            case .success(let expirations):
                guard let expiration = expirations.first else { return }
                let food = Food(context: DataController.shared.persistentContainer.viewContext)
                food.name = expiration.name
                food.expirationDate = Calendar.current.date(byAdding: .day, value: expiration.daysTillExpiration, to: Date())
                DataController.shared.saveContext()
            case .failure:
                break
            }
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
