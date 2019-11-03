//
//  ExpiringSoonViewController.swift
//  Expriology
//
//  Created by Harish Yerra on 11/2/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import SwiftUI

struct ExpiringSoonViewController: UIViewControllerRepresentable {
    func makeCoordinator() -> ExpiringSoonViewController.Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ExpiringSoonViewController>) -> ExpiringSoonCollectionViewController {
        let storyboard = UIStoryboard(name: "ExpiringSoon", bundle: nil)
        let expiringSoonVC = storyboard.instantiateViewController(identifier: ExpiringSoonCollectionViewController.identifier) as! ExpiringSoonCollectionViewController
        return expiringSoonVC
    }
    
    func updateUIViewController(_ uiViewController: ExpiringSoonCollectionViewController, context: UIViewControllerRepresentableContext<ExpiringSoonViewController>) {
        
    }
    
    class Coordinator: NSObject {
        var parent: ExpiringSoonViewController

        init(_ expiringSoonViewController: ExpiringSoonViewController) {
            self.parent = expiringSoonViewController
        }
    }
}

struct ExpiringSoonViewController_Previews: PreviewProvider {
    static var previews: some View {
        ExpiringSoonViewController()
    }
}
