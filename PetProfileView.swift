//
//  PetProfileView.swift
//  pawfectMatch
//
//  Created by Keya Gholap on 11/27/23.
//

import Foundation
import SwiftUI


//pet profile view

struct petProfilesView: View {
@StateObject private var petViewModel = PetViewModel()

var body: some View {
VStack {
if petViewModel.pets.isEmpty {
Text("No pets available")
} else {
List {
ForEach(petViewModel.pets) { pet in
NavigationLink(destination: PetDetailView(pet: pet)) {
PetRowView(pet: pet)
}
}
}
.navigationTitle("Pet Profiles")
}
}
}
}
