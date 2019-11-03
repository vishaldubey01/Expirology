//
//  TabscannerParameters.swift
//  Expriology
//
//  Created by Harish Yerra on 11/3/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import Foundation

protocol TabscannerParameters: Parameters { }

struct TabscannerProcessParameters: TabscannerParameters {
    var file: Data
    var documentType: DocumentType
    //var testMode: Bool
    
    enum DocumentType: String, Codable {
        case jpg = "JPG"
        case png = "PNG"
        case pdf = "PDF"
    }
}

struct TabscannerResultsParameters: TabscannerParameters {
    var token: String
}
