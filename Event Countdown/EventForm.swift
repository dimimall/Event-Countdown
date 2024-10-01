//
//  EventForm.swift
//  Event Countdown
//
//  Created by Δήμητρα Μαλλιαρου on 23/9/24.
//

import SwiftUI

enum FormMode {
    case add
    case edit(Event)
}

struct EventForm: View {
    
    @Binding var event: Event?
    @State var eventTitle: String = ""
    @State var eventDate = Date()
    @State var titleColor = Color.blue
    
    var mode: FormMode
    var onSave: (Event) -> Void
    
    @Environment(\.presentationMode)
    var presentationMode
    
    var body: some View {
        NavigationView {
            Section {
                Form {
                    TextField("Event Title", text: $eventTitle).foregroundColor(titleColor)
                    
                    DatePicker("Event Date", selection: $eventDate, displayedComponents: [.date, .hourAndMinute])
                    
                    ColorPicker("Select Event Title Color", selection: $titleColor)
                }
            }
            
            .onAppear {
                if case let .edit(event) = mode {
                    eventTitle = event.title
                    eventDate = event.date
                    titleColor = event.textColor
                }
            }
        }
        .navigationTitle((event?.title.count)! <= 0 ? "Add Event" : "Edit \(event?.title ?? "")")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        let newEvent = Event(id: UUID(), title: eventTitle, date: eventDate, color: titleColor.toHex()!)
                        
                        onSave(newEvent)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
}

#Preview {
    NavigationView {
        Section {
            EventForm(event: .constant(Event(id: UUID(), title: "Sample Event", date: Date(), color: Color.red.toHex()!)), mode: .add, onSave: {_ in})
        }
    }
}
