//
//  AddEventView.swift
//  pawfectMatch
//
//  Created by Keya Gholap on 11/27/23.
//

import Foundation
import SwiftUI

                                                            // Add event view

struct AddEventSheetView: View {
    @Binding var startDate: Date
    @Binding var endDate: Date
    @State private var eventTitle = ""
    @State private var shouldRemind = false
    @State private var events: [Event] = []
    @State private var isAddEventSheetPresented = false

    var body: some View {
        NavigationView {
            Form {
                Text("Add Event Details")
                    .font(.title)
                    .padding()

                TextField("Event Title", text: $eventTitle)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                    .padding()

                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                    .padding()

                Toggle("Remind Me", isOn: $shouldRemind)
                    .padding()

                Section(header: Text("Reminder")) {
                    Toggle("Remind on the day of the event", isOn: $shouldRemind)
                        .onChange(of: shouldRemind) { newValue in
                            // Schedule or cancel notifications based on the toggle state
                            if newValue {
                                // Ensure that newEvent is available in this scope
                                if let newEvent = events.last {
                                    scheduleReminderNotification(event: newEvent)
                                }
                            } else {
                                // Ensure that newEvent is available in this scope
                                if let newEvent = events.last {
                                    cancelReminderNotification(event: newEvent)
                                }
                            }
                        }
                }

                Button("Done", action: {
                                  if !eventTitle.isEmpty {
                                      // Add the event
                                      let newEvent = Event(id: UUID(), title: eventTitle, startDate: startDate, endDate: endDate)
                                      events.append(newEvent)

                                      // Schedule notification for the moment of event creation
                                      scheduleImmediateNotification(event: newEvent)

                                      // Schedule notification for the day of the event if shouldRemind is true
                                      if shouldRemind {
                                          scheduleReminderNotification(event: newEvent)
                                      }

                                      // Dismiss the sheet view
                                      isAddEventSheetPresented = false
                                  }
                              })
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                .padding()
            }
        }
    }

    private func scheduleImmediateNotification(event: Event) {
        let content = UNMutableNotificationContent()
        content.title = "Event Added"
        content.subtitle = event.title
        content.body = "Your event \(event.title) has been added!"
        content.sound = UNNotificationSound.default

        // Create a trigger for immediate notification
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)

        // Create a unique identifier for the immediate notification
        let identifier = "ImmediateNotification_\(event.id.uuidString)"

        // Create the notification request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling immediate notification: \(error.localizedDescription)")
            } else {
                print("Immediate notification scheduled successfully for \(event.title)")
            }
        }
    }

    private func scheduleReminderNotification(event: Event) {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Event"
        content.subtitle = event.title
        content.body = "Don't forget about your event on \(event.startDate)"
        content.sound = UNNotificationSound.default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: event.startDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: "ReminderNotification_\(event.id.uuidString)", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling reminder notification: \(error.localizedDescription)")
            } else {
                print("Reminder notification scheduled successfully for \(event.title)")
            }
        }
    }

    private func cancelReminderNotification(event: Event) {
        // Cancel the reminder notification for the specific event
        let identifier = "ReminderNotification_\(event.id.uuidString)"
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Reminder notification canceled for \(event.title)")
    }
}



                                                    // Upcoming events view

struct UpcomingEventsView: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var events: [Event] = []
    @State private var isShowingAddEventSheet = false

    var body: some View {
        VStack {
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                .padding()

            DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                .padding()

            Button("Add Event", action: {
                isShowingAddEventSheet.toggle()
            })
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            .sheet(isPresented: $isShowingAddEventSheet, onDismiss: addEvent) {
                AddEventSheetView(startDate: $startDate, endDate: $endDate)
            }

            List {
                ForEach(events) { event in
                    EventRowView(event: event)
                        .contextMenu {
                            Button(action: {
                                deleteEvent(event: event)
                            }) {
                                Text("Delete")
                                Image(systemName: "trash")
                            }
                        }
                }
            }
        }
        .onAppear {
            // Fetch events from your data source
            //fetchEvents()
        }
    }

    private func addEvent() {
        let newEvent = Event(id: UUID(), title: "Your Event Title", startDate: startDate, endDate: endDate)
        events.append(newEvent)

        // Schedule notification for the new event
        scheduleNotification(for: newEvent)

        // Reset date pickers
        startDate = Date()
        endDate = Date()

        // Dismiss the sheet view
        isShowingAddEventSheet = false
    }

    private func deleteEvent(event: Event) {
        // Remove the event from the events array
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events.remove(at: index)
        }

        // Remove the notification for the deleted event
        cancelNotification(for: event)
    }

    private func scheduleNotification(for event: Event) {
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Event"
        content.subtitle = event.title
        content.body = "Starts on \(event.startDate)"
        content.sound = UNNotificationSound.default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: event.startDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: event.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for \(event.title)")
            }
        }
    }

    private func cancelNotification(for event: Event) {
        // Cancel the notification for the specific event
        let identifier = event.id.uuidString
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Notification canceled for \(event.title)")
    }
}

