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
    @State var titleColor = Color(.red)
    
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
            .navigationTitle((event?.title.count)! <= 0 ? "Add Event" : "Edit \(event?.title ?? "")")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            let newEvent = Event(id: UUID(), title: eventTitle, date: eventDate, color: titleColor)
                            
                            onSave(newEvent)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .onAppear {
                    if case let .edit(event) = mode {
                        eventTitle = event.title
                        eventDate = event.date
                        titleColor = event.color!
                    }
                }
            }
        }
    
    private func loadEvents() -> [Event]{
        if let savedEventsData =
            UserDefaults.standard.data(forKey: "eventsArray") {
            if let loadedEvents = dataToEventArray(data: savedEventsData) {
                return loadedEvents
            }
        }
        return []
    }
    
    func dataToEventArray(data: Data) -> [Event]? {
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [Event]
    }
}

#Preview {
    NavigationView {
        Section {
            EventForm(event: .constant(Event(id: UUID(), title: "Sample Event", date: Date(), color: Color.red)), mode: .add, onSave: {_ in})
        }
    }
}
