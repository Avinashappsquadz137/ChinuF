//
//  MainTourView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 28/06/25.
//

import SwiftUI

struct RequestDetail {
    var title: String
    var image: String
}

struct MainTourView: View {
    let tourtask = [
        RequestDetail(title: "New Tour", image: "star"),
        RequestDetail(title: "Saved Tour Billing Request", image: "doc.text"),
    ]

    var body: some View {
            VStack(alignment: .leading) {
                List(tourtask, id: \.title) { task in
                    NavigationLink {
                        destinationView(for: task)
                    } label: {
                        HStack {
                            Image(systemName: task.image)
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.blue)
                            Text(task.title)
                                .font(.headline)
                                .padding(.leading, 8)
                        }
                        .padding(.vertical, 8)
                    }
                
                .listStyle(PlainListStyle())
            }
            
        }
    }

    // MARK: - Determine destination based on task
    @ViewBuilder
    func destinationView(for task: RequestDetail) -> some View {
        switch task.title {
        case "New Tour":
            NewTourFormView()
        case "Saved Tour Billing Request":
            SavedTourBillingRequestView()
        default:
            Text("Unknown Destination")
        }
    }
}

// MARK: - Different destination views



