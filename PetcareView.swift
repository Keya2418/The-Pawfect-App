//
//  PetcareView.swift
//  pawfectMatch
//
//  Created by Keya Gholap on 11/27/23.
//

import Foundation
import SwiftUI


        
//pet care view with api call

struct PetCareView: View {
@State private var dogFact: DogFact?
@State private var groomingTips: [String] = []
@State private var trainingTips: [String] = []
@State private var nutritionTips: [String] = []
@State private var isShowingGroomingTips = false
@State private var isShowingTrainingTips = false
@State private var isShowingNutritionTips = false

var body: some View {
ScrollView {
VStack(alignment: .leading, spacing: 20) {

// Display Dog Fact
if let fact = dogFact {
Text("Did You Know?")
.font(.headline)
Text(fact.body)
.padding()
} else {
ProgressView("Fetching Dog Fact...")
.onAppear {
fetchDogFact()
}
}

// Grooming Tips Button
Button(action: {
isShowingGroomingTips = true
}) {
Text("Grooming Tips")
.font(.headline)
.foregroundColor(.blue)
.padding()
.cornerRadius(10)
}
.sheet(isPresented: $isShowingGroomingTips) {
TipsListView(tips: groomingTips, title: "Grooming Tips")
}

// Training Tips Button
Button(action: {
isShowingTrainingTips = true
}) {
Text("Training Tips")
.font(.headline)
.foregroundColor(.blue)
.padding()
.cornerRadius(10)
}
.sheet(isPresented: $isShowingTrainingTips) {
TipsListView(tips: trainingTips, title: "Training Tips")
}
//nutrition tips button
Button(action: {
isShowingNutritionTips = true
}) {
Text("Nutrition Tips")
.font(.headline)
.foregroundColor(.blue)
.padding()
.cornerRadius(10)
}
.sheet(isPresented: $isShowingNutritionTips) {
TipsListView(tips: nutritionTips, title: "Nutrition Tips")
}
}//vstack
.padding()
}//scroll view
.navigationTitle("Pet Care")
.onAppear {
fetchGroomingTips()
fetchTrainingTips()
fetchNutritionTips()
}
}//some view

        //api call
private func fetchDogFact() {
guard let url = URL(string: "https://dogapi.dog/api/v2/facts") else {
print("Invalid URL")
return
}

URLSession.shared.dataTask(with: url) { data, response, error in
if let error = error {
print("Error: \(error.localizedDescription)")
return
}

if let data = data {
do {
let decoder = JSONDecoder()
let factResponse = try decoder.decode(DogFactResponse.self, from: data)
let firstFact = factResponse.data.first?.attributes

DispatchQueue.main.async {
dogFact = firstFact
}
} catch {
print("Error decoding JSON: \(error)")
if let stringData = String(data: data, encoding: .utf8) {
print("Response String: \(stringData)")
}
}
}
}.resume()
}//func

private func fetchGroomingTips() {
groomingTips = [
"Brush your dog's coat regularly to prevent matting.",
"Keep your dog's ears clean and check for signs of infection.",
"Trim your dog's nails to maintain healthy paws.",
"Bathe your dog when necessary, using a dog-friendly shampoo.",
"Regularly check and clean your dog's teeth to prevent dental issues.",
"Inspect your dog's skin for any lumps, bumps, or unusual changes.",
"Use a flea and tick prevention method recommended by your vet.",
"Pay attention to your dog's eyes and clean discharge with a damp cloth.",
"Choose grooming tools suitable for your dog's coat type."
]
}

private func fetchTrainingTips() {
trainingTips = [
"Use positive reinforcement during training sessions.",
"Be consistent with commands and rewards.",
"Start with basic commands like sit, stay, and come.",
"Keep training sessions short and fun to maintain your dog's interest.",
"Socialize your dog with various people, environments, and other dogs.",
"Train your dog to walk on a leash without pulling.",
"Teach your dog to wait patiently and not snatch treats or toys.",
"Practice recall exercises in a secure and controlled environment.",
"Enroll in obedience classes for structured training with a professional."
]
}

private func fetchNutritionTips() {
nutritionTips = [
"Provide a balanced and nutritious diet tailored to your dog's breed, size, and age.",
"Consult with your veterinarian to determine the best diet for your dog's specific needs.",
"Ensure access to fresh and clean water at all times.",
"Avoid feeding your dog human food, especially those that are toxic to dogs.",
"Monitor your dog's weight and adjust the diet accordingly to prevent obesity.",
"Consider high-quality dog treats for training rewards.",
"Gradually transition between different dog foods to avoid digestive upset.",
"Be aware of food allergies and intolerances that may affect your dog.",
"Limit table scraps and focus on providing a complete and balanced dog food.",
"Monitor portion sizes to prevent overfeeding."
]
}
}

