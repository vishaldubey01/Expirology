//
//  ObservableString.swift
//  Expriology
//
//  Created by Harish Yerra on 11/3/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import Foundation

class ObservableString: ObservableObject {
    @Published var string: String
    
    init(string: String) {
        self.string = string
    }
}
