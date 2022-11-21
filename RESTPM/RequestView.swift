//
//  RequestView.swift
//  RESTPM
//
//  Created by Roman Simenok on 19.11.2022.
//

import SwiftUI
import CoreData

struct RequestView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Request.name, ascending: true)],
        animation: .default
    )
    private var requests: FetchedResults<Request>
    @State private var presentAddAlert = false
    @State private var presentEditAlert = false
    @State private var presentDeleteAlert = false
    @State private var name = ""
    @State private var type = ""
    @State private var address = ""
    
    var body: some View {
        Group {
            if requests.isEmpty {
                VStack {
                    HStack {
                        Text("No Servers Added")
                    }
                }
            } else {
                List(requests) { request in
                    NavigationLink(
                        destination: {
                            StatisticsView(request: request)
                                .environment(\.managedObjectContext, viewContext)
                            
                        },
                        label: {
                            Text(request.name!)
                        }
                    )
                    .swipeActions {
                        Button("Delete") {
                            presentDeleteAlert = true
                        }
                        .tint(.red)
                        
                        Button("Edit") {
                            
                        }
                        .tint(.gray)
                    }
                    .alert("Delete request?", isPresented: $presentDeleteAlert, actions: {
                        Button("Delete", role: .destructive, action: {
                            viewContext.delete(request)
                            saveContext()
                        })
                        Button("Cancel", role: .cancel, action: {})
                    }, message: {
                        Text("Are you sure you whant to delete \"\(request.name ?? "this")\"?")
                    })
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Monitors")
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button("Add") {
                    presentAddAlert = true
                }
                .alert("Request", isPresented: $presentAddAlert, actions: {
                    TextField("My Home Server", text: $name)
                    TextField("Type, GET, POST etc.", text: $type)
                        .textInputAutocapitalization(.characters)
                    TextField("http://example.com", text: $address)
                        .keyboardType(.URL)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    
                    Button("Add", action: {
                        let request = Request(context: viewContext)
                        request.name = name
                        request.urlString = address
                        request.type = type
                        saveContext()
                        cleanupAlertVariables()
                    })
                    Button("Cancel", role: .cancel, action: {
                        cleanupAlertVariables()
                    })
                }, message: {
                    Text("Please enter request type and address")
                })
            }
        }
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("[DB] Error saving context")
        }
    }
    
    private func cleanupAlertVariables() {
        name = ""
        address = ""
        type = ""
    }
}

struct RequestView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RequestView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
