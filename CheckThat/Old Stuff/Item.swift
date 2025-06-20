//
//  Item.swift
//  CheckThat
//
//  Created by Nicolas on 20/06/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
