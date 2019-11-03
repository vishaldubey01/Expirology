//
//  TabscannerResult.swift
//  Expriology
//
//  Created by Harish Yerra on 11/3/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import Foundation

protocol TabscannerResponse: Decodable { }

struct TabscannerProcess: TabscannerResponse {
    var token: String
    var message: String
}
