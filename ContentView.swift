//Keya Gholap
//The Pawfect Application!

import SwiftUI
import MapKit
import CoreLocation
import CoreData
import UserNotifications

struct ContentView: View {
    @State private var showNotificationAlert = false
    @State private var isAnimated = false
    
    var body: some View {
        
        NavigationView{
            
            ZStack {
               
                Image("paw3")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showNotificationAlert = true
                        }) {
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(.black)
                                .padding()
                        }
                        
                    }//hstack
                    
                    Text("THE PAWFECT APP")
                        .font(.system(size: 35, weight: .semibold))
                        .foregroundColor(.black)
                        .padding()
                        .opacity(isAnimated ? 1 : 0)
                        .onAppear {
                            withAnimation(.bouncy(duration: 3.0)) {
                                self.isAnimated = true
                            }
                        }

                    Spacer().frame(height:400)
                    
                    //get started button
                    NavigationLink(destination: GetStartedView()) {
                        Text("Find Shelters Nearby")
                            .font(.title)
                            .fontWeight(.regular)
                            .padding()
                            .foregroundColor(.black)
                            .cornerRadius(25)
                    }
                    Spacer().frame(height:20)
                    
                    //pet profiles button
                    NavigationLink(destination: petProfilesView()) {
                        Text("Pet Profiles")
                            .font(.title)
                            .fontWeight(.regular)
                            .padding()
                            .foregroundColor(.black)
                            //.background(Color.black)
                            .cornerRadius(25)
                        
                    }
                    Spacer().frame(height:20)
                    
                    //pet care instructions
                    NavigationLink(destination: PetCareView()) {
                        Text("Pet Care")
                            .font(.title)
                            .fontWeight(.regular)
                            .padding()
                            .foregroundColor(.black)
                            //.background(Color.black)
                            .cornerRadius(25)
                        
                    }
                    
                    //upcoming events button
                    NavigationLink(destination: UpcomingEventsView()) {
                        Text("Add Upcoming Events")
                            .font(.title)
                            .fontWeight(.regular)
                            .padding()
                            .foregroundColor(.black)
                            //.background(Color.black)
                            .cornerRadius(25)
                        
                    }
                    
                    //Spacer().frame(height:20)
                }//vstack
            }//zstack
            .alert(isPresented: $showNotificationAlert) {
                           Alert(
                               title: Text("Enable Notifications"),
                               message: Text("Would you like to receive notifications from Pawfect Match?"),
                               primaryButton: .default(Text("Yes")){
                                   requestNotificationPermission()
                               },
                               secondaryButton: .cancel(Text("No"))
                           )
                       }//alert
        }//navigation view
        
    }//some view
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, error in
            if success {
                print("Notification permission granted")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }//func
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

 

                                // pet view model

class PetViewModel: ObservableObject {
    @Published var pets: [Pet] = []

    init() {
        fetchPets()
    }

    func fetchPets() {
        pets = [
            Pet(name: "Buddy", breed: "Golden Retriever", description: "Friendly and playful.", imageName: "golden"),
            Pet(name: "Max", breed: "Dalmation", description: "Loyal and intelligent.", imageName: "dalmation"),
            Pet(name: "Hachi", breed: "Doberman", description: "Energetic and tall.", imageName: "hachi"),
            Pet(name: "Lucy", breed: "Mixed", description: "Curious and friendly.", imageName: "1"),
            Pet(name: "Charlie", breed: "Unknown", description: "Energetic and outgoing.", imageName: "2"),
            Pet(name: "Daisy", breed: "Mixed cat", description: "Playful and affectionate.", imageName: "3"),
            Pet(name: "Cooper", breed: "Mixed", description: "Clever and curious.", imageName: "4"),
            Pet(name: "Luna", breed: "Mixed", description: "Independent and mischievous.", imageName: "5"),
            Pet(name: "Rocky", breed: "Mixed", description: "Charming and loving.", imageName: "6"),
            Pet(name: "Zoe", breed: "Mixed", description: "Sweet and gentle.", imageName: "7"),
            Pet(name: "Milo", breed: "Mixed", description: "Adaptable and playful.", imageName: "8"),
            Pet(name: "Coco", breed: "Mixed", description: "Bold and loyal.", imageName: "9"),
            Pet(name: "Buzo", breed: "Mixed", description: "Smart and lazy.", imageName: "10")
        ]
    }
}
  
                                      //pet row view

struct PetRowView: View {
    let pet: Pet

    var body: some View {
        HStack {
            // Display pet image
            Image(pet.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())

            // Display pet information
            VStack(alignment: .leading) {
                Text(pet.name)
                    .font(.headline)
                Text(pet.breed)
                    .font(.subheadline)
            }
        }
    }
}
 
                                                //event row view
                    
struct EventRowView: View {
    let event: Event

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(event.title)
                    .font(.headline)
                Text("Starts on: \(event.startDate)")
                    .font(.subheadline)
            }
            Spacer()
        }
        .padding()
    }
}
   

                                                //structs
    
struct Event: Identifiable {
    var id: UUID
    var title: String
    var startDate: Date
    var endDate: Date
}

struct TipsListView: View {
    let tips: [String]
    let title: String

    var body: some View {
        NavigationView {
            List(tips, id: \.self) { tip in
                Text("• \(tip)")
            }
            .navigationTitle(title)
        }
    }
}

struct DogFactResponse: Codable {
    let data: [DogFactData]
}

struct DogFactData: Codable {
    let id: String
    let type: String
    let attributes: DogFact
}

struct DogFact: Codable {
    let body: String
}

struct Location: Identifiable {
let id = UUID()
let name: String
let coordinate: CLLocationCoordinate2D
}

struct Pet: Identifiable {
var id = UUID()
var name: String
var breed: String
var description: String
var imageName: String
}
