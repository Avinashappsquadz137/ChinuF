//
//  SelectCompanyView.swift
//  ChinuFUI
//
//  Created by Sanskar IOS Dev on 01/04/26.
//
import SwiftUI
struct CompanyModel: Codable {
    let status: Bool
    let message: String
    let data: [Company]
}

struct Company: Codable, Identifiable {
    let id = UUID()
    let CompanyId: Int
    let CompanyName: String
}
struct SelectCompanyView: View {
    
    @State private var companyList: [Company] = []
    @State private var selectedCompany: Company? = nil
    @State private var navigateToLogin = false
    
    let rows = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 20) {
                
                Text("Select Company")
                    .font(.title)
                    .fontWeight(.bold)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        
                        Spacer(minLength: 0)
                        
                        ForEach(companyList, id: \.CompanyId) { company in
                            companyCard(company) // ✅ clean call
                        }
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
                CustonButton(title: "Submit", backgroundColor: selectedCompany == nil ? Color.gray : .maroon) {
                    navigateToLogin = true
                }
                .disabled(selectedCompany == nil)
                .padding(.horizontal)
                
                NavigationLink(
                    destination: MainLoginView(company: selectedCompany),
                    isActive: $navigateToLogin
                ) {
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
            .onAppear {
                fetchCompanyList()
            }
        }
    }
    @ViewBuilder
    func companyCard(_ company: Company) -> some View {
        
        VStack(spacing: 10) {
            
            Image(getCompanyImage(name: company.CompanyName ?? ""))
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            
            Text(company.CompanyName ?? "")
                .font(.subheadline)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
        }
        .frame(width: 110, height: 110)
        .padding(8)
        .background(
            selectedCompany?.CompanyId == company.CompanyId
            ? Color.blue.opacity(0.2)
            : Color.gray.opacity(0.1)
        )
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    selectedCompany?.CompanyId == company.CompanyId
                    ? Color.blue : Color.clear,
                    lineWidth: 2
                )
        )
        .onTapGesture {
            withAnimation {
                selectedCompany = company
            }
        }
    }
    func getCompanyImage(name: String) -> String {
        switch name.lowercased() {
        case "chinufilms":
            return "chinuF_logo"
        case "totalmultimedia":
            return "Total_multi"
        default:
            return "person.3.fill"
        }
    }
    
    func fetchCompanyList() {
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getCompany,
            method: .get,
            param: [:],
            model: CompanyModel.self
        ) { result in
            
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.companyList = model.data ?? []
                case .failure:
                    self.companyList = [
                        Company(CompanyId: 1, CompanyName: "ChinuFilms"),
                        Company(CompanyId: 2, CompanyName: "TotalMultiMedia")
                    ]
                }
            }
        }
    }
}
