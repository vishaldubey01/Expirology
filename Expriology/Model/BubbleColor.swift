//
//  BubbleColor.swift
//  Expriology
//
//  Created by Harish Yerra on 11/2/19.
//  Copyright © 2019 Harish Yerra. All rights reserved.
//

import Foundation
import UIKit

enum BubbleColor: CaseIterable {
    case orange
    case blue
    case red
    case purple
    case yellow
    case green
    
    var color: UIColor {
        switch self {
        case .orange: return #colorLiteral(red: 0.9019555449, green: 0.4952987432, blue: 0.1308369637, alpha: 1)
        case .blue: return #colorLiteral(red: 0.1993687749, green: 0.579469502, blue: 0.8371573091, alpha: 1)
        case .red: return #colorLiteral(red: 0.9074795842, green: 0.2969527543, blue: 0.2355833948, alpha: 1)
        case .purple: return #colorLiteral(red: 0.4550578594, green: 0.3679866195, blue: 0.7710855603, alpha: 1)
        case .yellow: return #colorLiteral(red: 0.9995599389, green: 0.6582826972, blue: 0.001935746637, alpha: 1)
        case .green: return #colorLiteral(red: 0.1376300454, green: 0.6085221767, blue: 0.3350310326, alpha: 1)
        }
    }
}
