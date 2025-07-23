//
//  HealthViewScreen.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 28/05/25.
//
import SwiftUI

struct HealthViewScreen: View {
 
    var urlString = "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Policy No:")
                    .fontWeight(.semibold)
                Spacer()
                Text(UserDefaultsManager.getPolicyNumber())
            }

            HStack {
                Text("Amount:")
                    .fontWeight(.semibold)
                Spacer()
                Text(UserDefaultsManager.getPolicyAmount())
            }

            HStack {
                Text("Valid Till:")
                    .fontWeight(.semibold)
                Spacer()
                Text(UserDefaultsManager.getPolicyValidity())
            }

            Button(action: {
                Task {
                    let urlString = urlString
                    if let localURL = await downloadPDF(urlstring: urlString) {
                        print("Downloaded file at: \(localURL)")
                        DispatchQueue.main.async {
                            ToastManager.shared.show(message: "PDF downloaded to Files app")
                        }
                    } else {
                        DispatchQueue.main.async {
                            ToastManager.shared.show(message: "Failed to download PDF")
                        }
                    }
                }
            }) {
                HStack {
                    Image(systemName: "arrow.down.doc")
                    Text("Download PDF")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(radius: 3)
        .padding(.horizontal)
        .overlay(ToastView())
    }

    private func downloadPDF(urlstring: String) async -> URL? {
        guard let url = URL(string: urlstring) else {
            print("Invalid URL string")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Bad response")
                return nil
            }
            
            let documentsUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
            
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("File already exists at path: \(destinationUrl.path)")
                return destinationUrl
            }
            
            try data.write(to: destinationUrl)
            return destinationUrl
        } catch {
            print("Error downloading PDF: \(error.localizedDescription)")
            return nil
        }
    }
}

