//
//  ExpirologyResult.swift
//  Expriology
//
//  Created by Harish Yerra on 11/3/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import Foundation

protocol ExpirologyResponse: Decodable { }

struct ExpirologyExpiration: ExpirologyResponse {
    var daysTillExpiration: Int
    var name: String
    
    var id: String { return name }
        
    private enum CodingKeys: String, CodingKey {
        case daysTillExpiration = "date"
        case name
    }
}

extension ExpirologyExpiration: Identifiable { }
