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
import Vision
// MARK: - Camera View
struct CameraView: UIViewRepresentable {
    
    class Coordinator: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
        var parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
        
        func captureOutput(_ output: AVCaptureOutput,
                           didOutput sampleBuffer: CMSampleBuffer,
                           from connection: AVCaptureConnection) {
            
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
            
            parent.detectFace(pixelBuffer: pixelBuffer)
        }
    }

    class CameraPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var previewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }

    let session: AVCaptureSession
    var onFaceDetected: (Bool) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(context.coordinator, queue: DispatchQueue(label: "videoQueue"))
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        
        return view
    }

    func updateUIView(_ uiView: CameraPreviewView, context: Context) {}

    // MARK: - Face Detection
    private func detectFace(pixelBuffer: CVPixelBuffer) {
        let request = VNDetectFaceRectanglesRequest { request, _ in
            DispatchQueue.main.async {
                guard let results = request.results as? [VNFaceObservation],
                      let face = results.first else {
                    self.onFaceDetected(false)
                    return
                }
                let faceRect = face.boundingBox
                let faceCenterX = faceRect.midX
                let faceCenterY = faceRect.midY
                let centerX: CGFloat = 0.5
                let centerY: CGFloat = 0.5
                let tolerance: CGFloat = 0.15

                let isCentered =
                    abs(faceCenterX - centerX) < tolerance &&
                    abs(faceCenterY - centerY) < tolerance

                self.onFaceDetected(isCentered)
            }
        }

        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up)
        try? handler.perform([request])
    }
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
    @State private var showRemarkAlert = false
    @State private var isUploading = false
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var photoCaptureHandler: PhotoCaptureHandler? = nil
    @State private var faceDetected = false
    @State private var progress: CGFloat = 0.0
    @State private var timer: Timer? = nil
    @Environment(\.dismiss) var dismiss
    @StateObject private var homeMasterDetailVM = HomeMasterDetailViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            CameraView(session: session) { detected in
                faceDetected = detected
                handleFaceDetection()
            }
            .cornerRadius(12)
            .onAppear {
                configureCamera()
            }
            .overlay(
                ZStack {
                    Circle()
                        .stroke(faceDetected ? Color.green : Color.red, lineWidth: 3)
                        .frame(width: 300, height: 300)

                    CircularProgressView(progress: progress)
                    if progress >= 1.0 {
                        Text("Punch Done ✅")
                            .foregroundColor(.green)
                            .bold()
                            .padding(.top, 320)
                    } else {
                        Text(faceDetected ? "Hold Still..." : "Align Face")
                            .foregroundColor(.white)
                            .padding(.top, 320)
                    }
                }
            )
         
            
            if let coordinate = locationManager.location {
                Map(coordinateRegion: .constant(MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
                )), annotationItems: [MapMarkerItem(coordinate: coordinate)]) { item in
                    MapMarker(coordinate: item.coordinate, tint: .red)
                }
                .frame(height: 150)
                .cornerRadius(12)
            }

            Text(locationManager.address)
                .font(.subheadline)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            Text(remarks)
                .font(.subheadline)
                .foregroundColor(.blue)
                .padding(.top, 4)
        }
        .padding()
        .alert(isPresented: $showRemarkAlert) {
            Alert(
                title: Text("PUNCH"),
                message: Text("\(remarks)"),
                dismissButton: .default(Text("OK")) {
                    dismiss()
                }
            )
        }
        .onChange(of: showRemarkAlert) { value in
            if value {
                stopAllProcesses()
            }
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
        .onAppear {
            configureCamera()
            homeMasterDetailVM.getMasterDetail()
        }
        .onDisappear {
            stopCamera()
        }
        

    }
    private func stopAllProcesses() {
        resetTimer()
        stopCamera()
        faceDetected = false
    }
    private func handleFaceDetection() {
        if showRemarkAlert { return }
        if faceDetected {
            startTimer()
        } else {
            resetTimer()
        }
    }
    private func startTimer() {
        
        if timer != nil || showRemarkAlert { return }
        progress = 0.0

        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { t in
            progress = min(progress + 0.05, 1.0)

            if progress >= 1.0 {
                t.invalidate()
                timer = nil
                resetTimer()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    capturePhoto()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        stopCamera()
                    }
                    showRemarkAlert = true
                }
            }
        }
    }
    private func stopCamera() {
        if session.isRunning {
            session.stopRunning()
        }
    }
    private func startCamera() {
        if !session.isRunning {
            session.startRunning()
        }
    }
    private func resetTimer() {
        timer?.invalidate()
        timer = nil
        progress = 0.0
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
        guard !isUploading else { return }
        isUploading = true
        let inTime = homeMasterDetailVM.masterDetail?.InTime ?? ""
        let status: String
        if inTime.isEmpty  {
            status = "0"
            remarks = "Auto Punch In"
        } else {
            status = "1"
            remarks = "Auto Punch Out"
        }
        let handler = PhotoCaptureHandler { image in
            DispatchQueue.main.async {
                self.captureImage = image
                self.selfPunchAPI(status: status)
                self.photoCaptureHandler = nil
            }
        }
        self.photoCaptureHandler = handler
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
 
        var imagesData: [String: Data] = [:]
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            isUploading = false
            showRemarkAlert = true
            return
        }
        imagesData["image"] = imageData
        
        let empCode = UserDefaultsManager.getEmpCode()
        let location = locationManager.address
        let time = Int(Date().timeIntervalSince1970)

        let url = "\(Constant.BASEURL)api_panel/selfPunch"

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
struct CircularProgressView: View {
    var progress: CGFloat
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.3), lineWidth: 6)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.green, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: progress)
        }
        .frame(width: 280, height: 280)
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
