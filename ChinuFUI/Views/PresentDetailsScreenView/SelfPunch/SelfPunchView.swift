//
//  SelfPunchView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 07/07/25.
//
import SwiftUI
import AVFoundation
import CoreLocation
import MapKit
import Alamofire
// MARK: - Camera View
struct CameraView: UIViewRepresentable {
    class CameraPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var previewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }

    let session: AVCaptureSession

    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: CameraPreviewView, context: Context) {}
}

// MARK: - Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    @Published var address: String = "Fetching address..."
    
    private var lastGeocodedLocation: CLLocation?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        // Only update if location changed significantly (>50m)
        if let lastLocation = lastGeocodedLocation,
           newLocation.distance(from: lastLocation) < 50 {
            return
        }

        lastGeocodedLocation = newLocation
        self.location = newLocation.coordinate

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(newLocation) { placemarks, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    self.address = "Unable to fetch address"
                }
                return
            }

            if let placemark = placemarks?.first {
                let name = placemark.name ?? ""
                let locality = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                let country = placemark.country ?? ""
                DispatchQueue.main.async {
                    self.address = "\(name), \(locality), \(state), \(country)"
                }
            }
        }
    }
}

// MARK: - Self Punch View
struct SelfPunchView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var session = AVCaptureSession()
    @State private var output = AVCapturePhotoOutput()
    @State private var remarks = "Remarks: Your last Punch was Out Punch"
    @State private var captureImage: UIImage? = nil
    @State private var pendingStatus: String? = nil
    @State private var showRemarkAlert = false
    @State private var isUploading = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var photoCaptureHandler: PhotoCaptureHandler? = nil

    var body: some View {
        VStack(spacing: 12) {
            CameraView(session: session)
                .frame(height: 250)
                .cornerRadius(12)
                .onAppear {
                    configureCamera()
                }

            if let coordinate = locationManager.location {
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )), annotationItems: [MapMarkerItem(coordinate: coordinate)]) { item in
                    MapMarker(coordinate: item.coordinate, tint: .red)
                }
               
                .cornerRadius(12)
            }

            Text(locationManager.address)
                .font(.subheadline)
                .padding(.horizontal)
                .multilineTextAlignment(.center)

            Spacer()

            HStack(spacing: 10) {
                Button(action: {
                    remarks = "Remarks: Your last Punch was In Punch"
                    pendingStatus = "0"
                    capturePhoto()
                }) {
                    Label("PUNCH IN", systemImage: "arrow.right.circle.fill")
                        .padding(10)
                        .background(isUploading ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isUploading)

                Button(action: {
                    remarks = "Remarks: Your last Punch was Out Punch"
                    pendingStatus = "1"
                    capturePhoto()
                }) {
                    Label("PUNCH OUT", systemImage: "arrow.uturn.left.circle.fill")
                        .padding(10)
                        .background(isUploading ? Color.gray : Color.maroon)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(isUploading)
            }


            Text(remarks)
                .font(.footnote)
                .foregroundColor(.blue)
                .padding(.top, 4)
        }
        .padding()
        .alert(isPresented: $showRemarkAlert) {
            Alert(title: Text("PUNCH"),
                  message: Text("\(remarks)"),
                  dismissButton: .default(Text("OK")))
        }
        .overlay(ToastView())
        .overlay(
            Group {
                if showToast {
                    Text(toastMessage)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .transition(.move(edge: .top))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    showToast = false
                                }
                            }
                        }
                }
            },
            alignment: .top
        )

    }

    // MARK: - Configure Camera
    private func configureCamera() {
        session.beginConfiguration()

        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
           let input = try? AVCaptureDeviceInput(device: device),
           session.canAddInput(input) {
            session.addInput(input)
        }

        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()
        session.startRunning()
    }

    // MARK: - Capture and Handle Image
    private func capturePhoto() {
        isUploading = true

        let handler = PhotoCaptureHandler { image in
            DispatchQueue.main.async {
                self.captureImage = image
                if let status = self.pendingStatus {
                    self.selfPunchAPI(status: status)
                    self.pendingStatus = nil
                }
                self.photoCaptureHandler = nil // clear strong reference
            }
        }

        self.photoCaptureHandler = handler // retain strongly
        let settings = AVCapturePhotoSettings()
        output.capturePhoto(with: settings, delegate: handler)
    }


    // MARK: - API Call
    private func selfPunchAPI(status: String) {
        guard let image = captureImage,
              let coordinate = locationManager.location else {
            isUploading = false
            showRemarkAlert = true
            return
        }

        // Resize + convert image
        guard let resizedImage = image.resizeToWidth(250),
              let imageData = resizedImage.pngData() else {
            isUploading = false
            showRemarkAlert = true
            return
        }

        let empCode = UserDefaultsManager.getEmpCode()
        let location = locationManager.address
        let time = Int(Date().timeIntervalSince1970)

        let url = "\(Constant.BASEURL)/api_panel/selfPunch"

        isUploading = true

        AF.upload(multipartFormData: { multipart in
            multipart.append(Data(empCode.utf8), withName: "EmpCode")
            multipart.append(Data(status.utf8), withName: "status")
            multipart.append(Data(location.utf8), withName: "location")
            multipart.append(Data("\(time)".utf8), withName: "time")
            
            let filename = "\(Int64(Date().timeIntervalSince1970 * 1000)).png"
            multipart.append(imageData, withName: "file", fileName: filename, mimeType: "image/png")
        }, to: url)
        .responseJSON { response in
            self.isUploading = false

            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any] {
                    let success = json["status"] as? Bool ?? false
                    let message = json["message"] as? String ?? "Unknown response"
                    
                    self.toastMessage = message
                    self.showToast = true
                    self.showRemarkAlert = true
                    if !success {
                        print("API Error:", message)
                    }
                } else {
                    print("Response not in expected JSON format:", value)
                    self.toastMessage = "Unexpected response"
                    self.showToast = true
                }

            case .failure:
                let filename = "\(Int64(Date().timeIntervalSince1970 * 1000)).png"
                AF.upload(multipartFormData: { multipart in
                    multipart.append(Data(empCode.utf8), withName: "EmpCode")
                    multipart.append(Data(status.utf8), withName: "status")
                    multipart.append(Data(location.utf8), withName: "location")
                    multipart.append(Data("\(time)".utf8), withName: "time")
                    multipart.append(imageData, withName: "file", fileName: filename, mimeType: "image/png")
                }, to: url)
                .responseString { fallbackResponse in
                    print("Raw server response:")
                    print(fallbackResponse.value ?? "No response string")
                    self.toastMessage = "Upload failed (invalid JSON): please try again"
                    self.showToast = true
                }
            }
        }

    }


}

// MARK: - Custom Delegate with Callback
class PhotoCaptureHandler: NSObject, AVCapturePhotoCaptureDelegate {
    let completion: (UIImage?) -> Void

    init(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
    }

    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            completion(nil)
            return
        }
        completion(image)
    }
}

// MARK: - Map Marker
struct MapMarkerItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
struct GetSuccessMessagePUN: Decodable {
    let status: Bool
    let message: String?
    let error: [String: String]? // ✅ Now it matches the dictionary format
}
