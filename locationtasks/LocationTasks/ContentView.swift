//
//  ContentView.swift
//  LocationTasks
//
//  Created by Abdalla Abdelmagid on 11/5/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var taskManager = TaskManager()
    @State private var showTaskList = false
    @State private var showTaskCreation = false
    @State private var selectedTask: Task?
    @State private var newTaskLocation: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $locationManager.region,
                    showsUserLocation: true,
                    annotationItems: taskManager.tasks) { task in
                    MapAnnotation(coordinate: task.location) {
                        VStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                                .font(.title)
                            Text(task.name)
                                .font(.caption)
                                .background(Color.white.opacity(0.8))
                                .cornerRadius(4)
                        }
                        .onTapGesture {
                            selectedTask = task
                        }
                    }
                }
                .onTapGesture {
                    selectedTask = nil
                }
                .gesture(
                    LongPressGesture(minimumDuration: 0.5)
                        .sequenced(before: DragGesture(minimumDistance: 0))
                        .onEnded { value in
                            switch value {
                            case .first(_):
                                // Long press detected
                                let generator = UIImpactFeedbackGenerator(style: .medium)
                                generator.impactOccurred()
                            case .second(_, let drag):
                                if let dragValue = drag {
                                    // Get location after long press
                                    if let coordinate = locationManager.convertToCoordinate(dragValue.location) {
                                        newTaskLocation = coordinate
                                        showTaskCreation = true
                                    }
                                }
                            }
                        }
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    if let task = selectedTask {
                        TaskPreviewCard(task: task) {
                            withAnimation(.spring()) {
                                selectedTask = nil
                            }
                        } deleteAction: {
                            if let index = taskManager.tasks.firstIndex(where: { $0.id == task.id }) {
                                withAnimation(.spring()) {
                                    taskManager.removeTask(at: index)
                                    selectedTask = nil
                                }
                            }
                        }
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            .navigationBarTitle("LocationTasks")
            .navigationBarItems(
                leading: Button(action: {
                    withAnimation {
                        locationManager.centerOnUser()
                    }
                }) {
                    Image(systemName: "location.circle.fill")
                },
                trailing: Button("View Tasks") {
                    showTaskList = true
                }
            )
            .sheet(isPresented: $showTaskCreation) {
                TaskCreationView(taskManager: taskManager, location: newTaskLocation)
            }
            .sheet(isPresented: $showTaskList) {
                TaskListView(taskManager: taskManager)
            }
        }
    }
}
