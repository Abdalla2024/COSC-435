//
//  TaskPreviewCard.swift
//  LocationTasks
//
//  Created by Abdalla Abdelmagid on 11/10/24.
//

import SwiftUI

struct TaskPreviewCard: View {
    let task: Task
    let dismissAction: () -> Void
    let deleteAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(task.name)
                    .font(.headline)
                Spacer()
                Button(action: dismissAction) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            
            Text(task.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("Due: \(task.dueDate, formatter: DateFormatter.taskDateFormatter)")
                .font(.caption)
            
            HStack {
                Spacer()
                Button(action: deleteAction) {
                    Text("Delete Task")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding()
    }
}
    