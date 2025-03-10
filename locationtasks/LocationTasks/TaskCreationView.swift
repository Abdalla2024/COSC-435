//
//  TaskCreationView.swift
//  LocationTasks
//
//  Created by Abdalla Abdelmagid on 11/5/24.
//

import SwiftUI
import CoreLocation

struct TaskCreationView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var taskManager: TaskManager
    var location: CLLocationCoordinate2D?
    @State private var name = ""
    @State private var description = ""
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $name)
                TextField("Description", text: $description)
                DatePicker("Due Date", selection: $dueDate, in: Date()..., displayedComponents: .date)
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add") {
                    if let location = location {
                        taskManager.addTask(name: name, description: description, dueDate: dueDate, location: location)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty || description.isEmpty || dueDate < Date())
            )
        }
    }
}
