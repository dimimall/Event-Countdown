//
//  Event.swift
//  Event Countdown
//
//  Created by Δήμητρα Μαλλιαρου on 23/9/24.
//

import Foundation

import SwiftUI


struct Event: Identifiable, Comparable, Codable{
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.date < rhs.date
    }
    
    var id: UUID
    var title: String
    var date: Date
    var color: String
    
    var textColor: Color {
        get {
            return Color(hex: color) ?? Color.blue
        }
        set {
            color = newValue.toHex() ?? "#FFFFFFFF"
        }
    }
    
}
