//
//  ContentView.swift
//  PicNix
//
//  Created by Abdalla Abdelmagid on 10/20/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = ViewModel()
    @State private var selectedPost: Model? // State for the selected post

    var body: some View {
        NavigationView {
            VStack {
                Text("PicNix")
                    .font(.largeTitle)
                    .padding()

                if viewModel.isLoading {
                    VStack {
                        ProgressView()
                        Text("Fetching new posts")
                    }
                } else {
                    List(viewModel.posts.filter { $0.caption != "CORRUPT" }) { post in
                        if post.isPrivate {
                            Text("\(post.username) has their posts set to private.")
                                .padding()
                        } else {
                            PostRow(post: post)
                                .onTapGesture {
                                    selectedPost = post // Set the selected post to display in the sheet
                                }
                        }
                    }
                }
            }
            .onAppear {
                viewModel.pullPosts(from: viewModel.url)
            }
            .sheet(item: $selectedPost) { post in
                PostDetailView(post: post)
            }
        }
    }
}

struct PostRow: View {
    var post: Model

    var body: some View {
        VStack(alignment: .leading) {
            Text(post.username)
                .bold()
            Text("Points: \(post.amount)")
            AsyncImage(url: URL(string: post.image)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            Text(post.businessName)
            // Format createdAt date to timeAgo
            Text(timeAgo(from: post.createdAt))
        }
    }

    // Function to calculate the time ago from the createdAt date
    private func timeAgo(from dateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds] // Handle fractional seconds
        guard let date = dateFormatter.date(from: dateString) else { return "Unknown" }

        let interval = Date().timeIntervalSince(date)
        let secondsInMinute: TimeInterval = 60
        let secondsInHour: TimeInterval = 3600
        let secondsInDay: TimeInterval = 86400

        if interval < secondsInMinute {
            return "\(Int(interval)) seconds ago"
        } else if interval < secondsInHour {
            return "\(Int(interval / secondsInMinute)) minutes ago"
        } else if interval < secondsInDay {
            return "\(Int(interval / secondsInHour)) hours ago"
        } else {
            return "\(Int(interval / secondsInDay)) days ago"
        }
    }
}

struct PostDetailView: View {
    var post: Model
    @Environment(\.dismiss) var dismiss // Dismiss the view

    var body: some View {
        NavigationView {
            VStack {
                Text(post.username)
                    .font(.title)
                    .padding(.bottom)

                Text("Points: \(post.amount)")
                    .padding(.bottom)

                AsyncImage(url: URL(string: post.image)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200) // Image height
                } placeholder: {
                    ProgressView()
                }
                .padding(.bottom)

                Text(post.businessName)
                    .font(.headline)
                    .padding(.bottom)

                Text(formatDate(post.createdAt))
                    .padding(.bottom)

                // Unwrapping the caption using if let
                if let caption = post.caption {
                    if caption.isEmpty {
                        Text("No Caption for this post")
                            .foregroundColor(.gray)
                    } else {
                        Text(caption)
                            .padding(.top)
                    }
                } else {
                    Text("No Caption for this post") // If caption is nil
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline) // Display the title inline
            .navigationBarItems(trailing: Button(action: {
                dismiss() // Dismiss the view
            }) {
                Text("X")
                    .font(.title) // Increase the font size
            })
        }
    }

    // Format date
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        if let date = dateFormatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "yyyy-MM-dd"
            return displayFormatter.string(from: date)
        }
        return dateString // Return the original string if conversion fails
    }
}
