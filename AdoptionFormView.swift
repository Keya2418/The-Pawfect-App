//
//  AdoptionFormView.swift
//  pawfectMatch
//
//  Created by Keya Gholap on 11/27/23.
//

import Foundation
import SwiftUI
import UserNotifications

// Adoption form view

struct AdoptionFormView: View {
    let pet: Pet
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var email = ""
    @State private var address = ""
    @State private var reason = ""
    @State private var existingPet = ""
    @State private var isRenting = false

    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Pet Information")) {
                HStack {
                    Text("Pet Name:")
                    Spacer()
                    Text(pet.name)
                }
                HStack {
                    Text("Breed:")
                    Spacer()
                    Text(pet.breed)
                }
            }

            Section(header: Text("Your Information")) {
                TextField("Your Name", text: $name)
                TextField("Your Phone Number", text: $phoneNumber)
                TextField("Your Email", text: $email)
                TextField("Your Address", text: $address)
                TextField("Why do you want this pet?", text: $reason)
                TextField("Existing pets you have", text: $existingPet)
                Toggle("Do you rent a property?", isOn: $isRenting)
            }

            Button(action: {
                scheduleNotification(for: pet)    // trigger notification
                presentationMode.wrappedValue.dismiss()      // Close the AdoptionFormView
            }) {
                Text("Submit Adoption Form")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.cyan)
                    .cornerRadius(10)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .onAppear {
            requestNotificationPermissions()
        }
        
    }

    // Schedule notifications func
    private func scheduleNotification(for pet: Pet) {
        let content = UNMutableNotificationContent()
        content.title = "Adoption Successful"
        content.subtitle = "You've adopted \(pet.name)!"
        content.sound = UNNotificationSound.default

        // Create a trigger to show the notification after a delay (e.g., 5 seconds)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)

        // Create a unique identifier for the notification
        let identifier = "AdoptionNotification_\(UUID().uuidString)"

        // Create the notification request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // Add the request to the notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    

    // UNUserNotificationCenterDelegate method
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show the notification both when the app is in the foreground and background
        //print("Received notification while app is in foreground")
        completionHandler([.banner, .sound, .badge])
    }


    // Additional method to request notification permissions
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permissions granted")
            } else if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            }
        }
    }
}

