//
//  AttendanceGridView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 29/04/25.
//

import SwiftUI

struct AttendanceRow: Identifiable {
    var id = UUID()
    let month: String
    let full: String
    let half: String
    let tour: String
    let wfh: String
}

struct AttendanceGridView: View {
    @StateObject private var viewModel = AttendanceViewModel()
    let detail: Events
    var employId: String = ""
    var body: some View {

        ScrollView(.horizontal) {
                VStack(spacing: 1) {
                    Text("LEAVE TREND")
                        .font(.headline)
                    HStack(spacing: 1) {
                        Text("Month")
                            .frame(width: 60, height: 40)
                            .background(Color.gray.opacity(0.3))
                            .border(Color.black)

                        ForEach(viewModel.attendances.dropFirst(), id: \.id) { item in
                            Text(item.month)
                                .frame(width: 60, height: 40)
                                .background(Color.gray.opacity(0.3))
                                .border(Color.black)
                        }
                    }

                    // Row: Full
                    HStack(spacing: 1) {
                        Text("Full")
                            .frame(width: 60, height: 40)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black)

                        ForEach(viewModel.attendances.dropFirst(), id: \.id) { item in
                            Text(item.full)
                                .frame(width: 60, height: 40)
                                .border(Color.black)
                        }
                    }

                    // Row: Half
                    HStack(spacing: 1) {
                        Text("Half")
                            .frame(width: 60, height: 40)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black)

                        ForEach(viewModel.attendances.dropFirst(), id: \.id) { item in
                            Text(item.half)
                                .frame(width: 60, height: 40)
                                .border(Color.black)
                        }
                    }

                    // Row: Tour
                    HStack(spacing: 1) {
                        Text("Tour")
                            .frame(width: 60, height: 40)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black)

                        ForEach(viewModel.attendances.dropFirst(), id: \.id) { item in
                            Text(item.tour)
                                .frame(width: 60, height: 40)
                                .border(Color.black)
                        }
                    }

                    // Row: WFH
                    HStack(spacing: 1) {
                        Text("WFH")
                            .frame(width: 60, height: 40)
                            .background(Color.gray.opacity(0.2))
                            .border(Color.black)

                        ForEach(viewModel.attendances.dropFirst(), id: \.id) { item in
                            Text(item.wfh)
                                .frame(width: 60, height: 40)
                                .border(Color.black)
                        }
                    }
                }
                .padding()
            }
        
        .onAppear {
            viewModel.fetchDetail(empCode: "\(detail.emp_Code ?? "\(employId)")")
        }
    }
}



class AttendanceViewModel: ObservableObject {
    @Published var attendances: [AttendanceRow] = []

    func fetchDetail(empCode: String) {
        var dict = [String: Any]()
        dict["EmpCode"] = empCode

        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.detailOfEmp,
            method: .post,
            param: dict,
            model: AttandanceDetail.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    var rows: [AttendanceRow] = []

                    // Header
                    rows.append(AttendanceRow(month: "Month", full: "Full", half: "Half", tour: "Tour", wfh: "WFH"))

                    if let data = model.data {
                        for item in data {
                            let month = item.month?.components(separatedBy: " ").first ?? ""
                            let full = "\(item.f ?? 0)"
                            let half = "\(item.h ?? 0)"
                           
                            let tour = "0"
                            let wfh = "0"

                            rows.append(AttendanceRow(month: month, full: full, half: half, tour: tour, wfh: wfh))
                        }
                    }

                    self.attendances = rows
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}
