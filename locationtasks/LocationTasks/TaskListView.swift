//
//  TaskListView.swift
//  LocationTasks
//
//  Created by Abdalla Abdelmagid on 11/5/24.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskManager: TaskManager
    
    var body: some View {
        NavigationView {
            List {
                ForEach(taskManager.tasks.indices, id: \.self) { index in
                    let task = taskManager.tasks[index]
                    VStack(alignment: .leading) {
                        Text(task.name).font(.headline)
                        Text(task.description)
                        Text("Due: \(task.dueDate, formatter: DateFormatter.taskDateFormatter)")
                        Text("Location: \(task.location.latitude), \(task.location.longitude)")
                    }
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle("Tasks")
        }
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            taskManager.removeTask(at: index)
        }
    }
}
