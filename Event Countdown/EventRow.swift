//
//  EventRow.swift
//  Event Countdown
//
//  Created by Δήμητρα Μαλλιαρου on 23/9/24.
//

import SwiftUI

struct EventRow: View {
    var event: Event
    @State private var timeRemaining: String = ""
    
    var body: some View {
        HStack {
            Text(event.title)
                .foregroundColor(event.textColor)
                .font(.headline)
            
            Spacer()
            
            Text(timeRemaining)
                .font(.subheadline)
                .onAppear(perform: {
                    startTimer()
                })
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 0, repeats: true) {_ in 
                updateCountdown()
            }
    }
    
    private func updateCountdown() {
        let formater = RelativeDateTimeFormatter()
        let now = Date()
        timeRemaining = formater.localizedString(for: event.date, relativeTo: now)
    }
}

//#Preview {
//    EventRow(event: Event(id: UUID(), title: "Party Event", date: Date(), color: Color.red))
//}
