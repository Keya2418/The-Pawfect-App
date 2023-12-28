//
//  PetDetailView.swift
//  pawfectMatch
//
//  Created by Keya Gholap on 11/27/23.
//

import Foundation
import SwiftUI

//pet detail view

struct PetDetailView: View {
@State private var isAdoptButtonTapped = false
let pet: Pet

var body: some View {
VStack {
Image(pet.imageName)
.resizable()
.scaledToFit()
.frame(width: 200, height: 200)
.clipShape(Circle())
.overlay(Circle().stroke(Color.white, lineWidth: 4))
.shadow(radius: 10)

Text(pet.name)
.font(.title)
.padding(.top, 10)

Text(pet.breed)
.font(.headline)
.padding(.top, 5)

Text(pet.description)
.font(.body)
.padding(.top, 10)
.multilineTextAlignment(.center)
.padding(.horizontal, 20)

// Adopt Me Button
Button(action: {
isAdoptButtonTapped = true
}) {
Text("Adopt Me!")
.font(.headline)
.foregroundColor(.white)
.padding()
.background(Color.cyan)
.cornerRadius(10)
}
.sheet(isPresented: $isAdoptButtonTapped) {
AdoptionFormView(pet: pet)
}
.padding(.top, 20)
}
.navigationTitle(pet.name)
}
}
