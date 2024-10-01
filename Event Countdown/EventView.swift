//
//  EventView.swift
//  Event Countdown
//
//  Created by Δήμητρα Μαλλιαρου on 24/9/24.
//

import SwiftUI
import UIKit

struct EventView: View {
    
    @State var eventSelect: Event?
    @State private var showDetails = false
    @State private var events: [Event] = []
    
    var body: some View {
        NavigationStack {
            if events.count > 0 {
                List{
                    ForEach(loadEvents().sorted()) { event in
                        NavigationLink(destination: EventForm(event: .constant(event), mode: .edit(event), onSave: addEvent)){
                            EventRow(event: event)
                        }
                    }
                    .onDelete(perform: deleteEvent)
                }
                .navigationTitle("Events")
                .font(.headline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: EventForm(event: .constant(Event(id: UUID(), title: "", date: Date(), color: Color.black)), mode: .add, onSave:addEvent)){
                            Image(systemName: "plus")
                                .imageScale(.large)
                                .tint(.black)
                        }
                    }
                }
            }
            else {
                Text("Empty List")
                    .navigationTitle("Events")
                    .font(.headline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: EventForm(event: .constant(Event(id: UUID(), title: "", date: Date(), color: Color.black)), mode: .add, onSave:addEvent)){
                                Image(systemName: "plus")
                                    .imageScale(.large)
                                    .tint(.black)
                        }
                    }
                }
            }
        }
        .onAppear {
            events = loadEvents()
        }
    }
    
    private func deleteEvent(at offsets: IndexSet) {
        print("remove index \(offsets)")
        events.remove(atOffsets: offsets)
        
        UserDefaults.standard.set(eventArrayToData(eventArray: events), forKey: "eventsArray")
    }
    
    private func addEvent(event: Event) {
        if let existingEventsIndex = events.firstIndex(where: {$0.id == event.id}) {
            events.remove(at: existingEventsIndex)
            events.insert(event, at: existingEventsIndex)
        }
        else {
            events.append(event)
        }
        
        UserDefaults.standard.set(eventArrayToData(eventArray: events), forKey: "eventsArray")
    }
    
    private func loadEvents() -> [Event]{
        if let savedEventsData =
            UserDefaults.standard.data(forKey: "eventsArray") {
            
            if let loadedEvents = dataToEventArray(data: savedEventsData) {
                return loadedEvents as! [Event]
            }
        }
        return []
    }
    
    func eventArrayToData(eventArray: [Any]) -> Data? {
      return try? JSONSerialization.data(withJSONObject: eventArray, options: [])
    }
    
    func dataToEventArray(data: Data) -> [Any]? {
        return (try? JSONSerialization.jsonObject(with: data, options: [])) as? [Event]
    }
}

#Preview {
    EventView()
}
