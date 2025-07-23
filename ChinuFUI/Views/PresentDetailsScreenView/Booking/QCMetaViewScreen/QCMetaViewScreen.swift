//
//  QCMetaViewScreen.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 19/07/25.
//

import SwiftUI
import AVKit

struct QCMetaViewScreen: View {
    @StateObject private var viewModel = BookingViewModel()
    @State private var selectedKatha: NewBooking?
    @State private var showMetaInput: Bool = false
    @State private var metaText: String = ""
    @State private var showVideoPlayer: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        NavigationView {
            List(viewModel.filteredBookings, id: \.katha_booking_id) { katha in
                VStack(alignment: .leading, spacing: 6) {
                    Text("Date: \(katha.katha_from_Date ?? "") to \(katha.katha_date ?? "")").font(.headline)
                    Text("Name: \(katha.name ?? "-")")
                    Text("Venue: \(katha.venue ?? "-")")
                    Text("Channel: \(katha.channelName ?? "-")")
                    Text("Promo: \(katha.remarks ?? "-")")
                    Text("Time: \(katha.kathaTiming ?? "-")")

                    HStack {
                        Button("\u{1F441} Preview") {
                            selectedKatha = katha
                            showVideoPlayer = true
                        }
                        .buttonStyle(.borderedProminent)

                        Button("\u{1F4DD} Meta ID") {
                            selectedKatha = katha
                            showMetaInput = true
                            metaText = "" // reset
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding(.vertical, 10)
            }
            .navigationTitle("QC Meta List")
        }
        .sheet(isPresented: $showMetaInput) {
            if let selected = selectedKatha {
                MetaInputSheet(katha: selected, metaText: $metaText, onSubmit: {
                    submitMetaId(katha: selected)
                    showMetaInput = false
                }, onCancel: {
                    showMetaInput = false
                })
            }
        }
        .sheet(isPresented: $showVideoPlayer) {
            if let urlStr = selectedKatha?.remarks, let url = URL(string: urlStr) {
                VideoPlayer(player: AVPlayer(url: url))
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Invalid video URL")
                    .padding()
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func submitMetaId(katha: NewBooking) {
        guard let empCode = UserDefaults.standard.string(forKey: "EmpCode") else {
            alertMessage = "Employee code missing"
            showAlert = true
            return
        }

        let body: [String: Any] = [
            "Katha_Id": "\(katha.katha_id ?? 0)",
            "EmpCode": empCode,
            "metaId": metaText
        ]

        guard let url = URL(string: "https://your-api.com/CreateMetaApi"),
              let requestData = try? JSONSerialization.data(withJSONObject: body) else {
            alertMessage = "Failed to create request"
            showAlert = true
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = requestData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    alertMessage = "API error: \(error.localizedDescription)"
                    showAlert = true
                } else {
                    alertMessage = "Meta ID submitted successfully."
                    showAlert = true
                }
            }
        }.resume()
    }
}

struct MetaInputSheet: View {
    let katha: NewBooking
    @Binding var metaText: String
    var onSubmit: () -> Void
    var onCancel: () -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Enter Meta ID for:")
                    .font(.headline)
                Text(katha.name ?? "-")
                    .font(.title3)
                    .fontWeight(.medium)

                TextEditor(text: $metaText)
                    .frame(height: 120)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.secondary.opacity(0.4), lineWidth: 1)
                    )

                Spacer()

                HStack {
                    Button("Cancel", action: onCancel)
                        .foregroundColor(.red)

                    Spacer()

                    Button("Submit", action: onSubmit)
                        .disabled(metaText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Meta ID Input")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
