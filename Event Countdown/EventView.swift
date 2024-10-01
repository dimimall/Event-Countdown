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
    @State private var isPresented = false
    
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
                        Button(action: {
                            isPresented = true
                        }){
                            Image(systemName: "plus")
                                .imageScale(.large)
                                .tint(.black)
                        }.navigationDestination(isPresented: $isPresented, destination: {
                            EventForm(event: .constant(Event(id: UUID(), title: "", date: Date(), color: Color.blue.toHex()!)), mode: .add, onSave: addEvent)
                        })
                    }
                }
            }
            else {
                Text("Empty List")
                    .navigationTitle("Events")
                    .font(.headline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isPresented = true
                            }){
                                Image(systemName: "plus")
                                    .imageScale(.large)
                                    .tint(.black)
                            }.navigationDestination(isPresented: $isPresented, destination: {
                                EventForm(event: .constant(Event(id: UUID(), title: "", date: Date(), color: Color.blue.toHex()!)), mode: .add, onSave: addEvent)
                            })
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
        
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: "eventsArray")
        }
    }
    
    private func addEvent(event: Event) {
        if let existingEventsIndex = events.firstIndex(where: {$0.id == event.id}) {
            events.remove(at: existingEventsIndex)
            events.insert(event, at: existingEventsIndex)
        }
        else {
            
            events.append(event)
        }
        
        if let encoded = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(encoded, forKey: "eventsArray")
        }
    }
    
    private func loadEvents() -> [Event]{
        if let data = UserDefaults.standard.data(forKey: "eventsArray"),
           let events = try? JSONDecoder().decode([Event].self, from: data) {
            return events
        }
        return []
    }
    
}

#Preview {
    EventView()
}
