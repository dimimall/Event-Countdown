//
//  Event.swift
//  Event Countdown
//
//  Created by Δήμητρα Μαλλιαρου on 23/9/24.
//

import Foundation

import SwiftUI

struct Event: Identifiable, Comparable{
    static func < (lhs: Event, rhs: Event) -> Bool {
        return lhs.date < rhs.date
    }
    
    var id: UUID
    var title: String
    var date: Date
    var color: Color?
    
}
