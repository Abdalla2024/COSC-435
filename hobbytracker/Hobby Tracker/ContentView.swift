//
//  ContentView.swift
//  Hobby Tracker
//
//  Created by Abdalla Abdelmagid on 9/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showModal = false
    @ObservedObject var viewModel = HobbyViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray5) // Grayish background color to make white elements pop
                    .edgesIgnoringSafeArea(.all)

                ScrollView { // Make the entire view scrollable
                    VStack(spacing: 20) { // Add spacing between elements

                        if viewModel.hobbies.isEmpty { // If there is no hobbies
                            Text("Add a hobby using the + button") // Print this
                                .font(.headline)
                                .foregroundColor(.gray)
                                .padding(.horizontal) // Add horizontal padding
                        } else {
                            ForEach(viewModel.hobbies) { hobby in
                                HStack {
                                    Text(hobby.emoji)
                                        .font(.largeTitle)
                                    Text(hobby.name)
                                        .font(.headline)
                                }
                                .padding() // Add padding to each hobby item
                                .frame(maxWidth: .infinity) // Make the hobby item stretch to full width
                                .background(Color.white)
                                .cornerRadius(8) // Round corners
                                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2) // Add shadow
                            }
                        }
                    }
                    .padding(.horizontal) // Add padding to the whole VStack
                }
            }
            .navigationTitle("Hobby Tracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showModal = true // Show modal when plus button is clicked
                    }) {
                        Image(systemName: "plus") // Plus in top right corner
                            .font(.title) // Make the plus button bigger
                    }
                }
            }
            .sheet(isPresented: $showModal) {
                AddHobbyModalView(viewModel: viewModel)
            }
        }
    }
}

struct AddHobbyModalView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: HobbyViewModel
    @State private var hobby = ""
    @State private var selectedEmoji: String = ""
    @State private var errorMessage: String? = nil
    
    let emojiOptions = ["📚", "🏊‍♀️", "🚴‍♂️", "🍳", "🎮", "📸", "✈️", "🌻", "🎨", "✍️", "🎶", "🎧", "🏋️‍♀️", "🚶‍♂️", "🎤", "🍔", "🚗", "🚢", "🎲", "🎯"]

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.black]),
                        startPoint: .topLeading, // Lighter at the top left
                        endPoint: .bottomTrailing // Darker at the bottom right
                    )
                    .edgesIgnoringSafeArea(.all)

                VStack {

                    TextField("Enter a hobby (3-16 characters)", text: $hobby)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Text("Choose an Emoji")
                        .font(.headline)
                        .padding(.top)

                    // Emoji grid
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
                        ForEach(emojiOptions, id: \.self) { emoji in
                            Button(action: {
                                selectedEmoji = emoji
                            }) {
                                Text(emoji)
                                    .font(.largeTitle)
                                    .padding()
                                    .background(selectedEmoji == emoji ? Color.gray.opacity(0.3) : Color.clear)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()

                    // Error message display
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }

                    Spacer()

                    Button(action: {
                        if validateHobby() {
                            viewModel.addHobby(name: hobby, emoji: selectedEmoji)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Submit")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .font(.system(size: 20))
                    }
                    .padding()
                    .disabled(hobby.isEmpty || selectedEmoji.isEmpty)
                }
                .padding()
                .navigationTitle("Add Hobby")
                .foregroundColor(.white)
                .navigationBarItems(trailing: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.white)
                })
            }
        }
    }

    private func validateHobby() -> Bool {
        if hobby.count < 3 || hobby.count > 16 {
            errorMessage = "Must be between 3 and 16 characters."
            return false
        }
        if viewModel.hobbies.contains(where: { $0.name.lowercased() == hobby.lowercased() }) {
            errorMessage = "This hobby already exists."
            return false
        }
        if selectedEmoji.isEmpty {
            errorMessage = "Please select an emoji."
            return false
        }
        return true
    }
}

struct Hobby: Identifiable {
    let id = UUID()   // Unique identifier for each hobby
    let name: String  // Hobby name
    let emoji: String // Hobby emoji
}

class HobbyViewModel: ObservableObject {
    @Published var hobbies: [Hobby] = [
        Hobby(name: "Reading", emoji: "📚"),
        Hobby(name: "Swimming", emoji: "🏊‍♀️"),
        Hobby(name: "Cycling", emoji: "🚴‍♂️"),
        Hobby(name: "Cooking", emoji: "🍳"),
        Hobby(name: "Gaming", emoji: "🎮"),
        Hobby(name: "Photography", emoji: "📸"),
        Hobby(name: "Traveling", emoji: "✈️"),
        Hobby(name: "Gardening", emoji: "🌻"),
        Hobby(name: "Painting", emoji: "🎨"),
        Hobby(name: "Writing", emoji: "✍️")
    ]
    
    // Add a new hobby
    func addHobby(name: String, emoji: String) {
        let newHobby = Hobby(name: name, emoji: emoji)
        hobbies.append(newHobby)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
