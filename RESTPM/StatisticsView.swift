//
//  StatisticsView.swift
//  RESTPM
//
//  Created by Roman Simenok on 19.11.2022.
//

import SwiftUI
import CoreData

struct StatisticsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var request: Request
    
    var body: some View {
        Text(request.name!)
    }
}
