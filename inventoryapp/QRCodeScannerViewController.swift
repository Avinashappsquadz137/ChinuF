//
//  QRCodeScannerViewController.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 05/08/24.
//
import UIKit
import AVFoundation

class QRCodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var didScanQRCode: ((String) -> Void)?
    private let captureSession = AVCaptureSession()
    private let previewLayer = AVCaptureVideoPreviewLayer()
    private let backButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCaptureSession()
        setupBackButton()
    }

    private func setupCaptureSession() {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }

        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return
        }

        previewLayer.session = captureSession
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.layer.bounds
        view.layer.addSublayer(previewLayer)
        
        // Ensure that the session starts running on a background thread
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning()
        }
    }

    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
    }

    private func found(code: String) {
        // Stop the session to prevent multiple scans
        DispatchQueue.global(qos: .background).async {
            self.captureSession.stopRunning()
        }
        
        // Show alert with options to add more or finish
        presentOptionsAlert(for: code)
    }

    private func presentOptionsAlert(for code: String) {
        let alert = UIAlertController(title: "QR Code Scanned", message: "What would you like to do?", preferredStyle: .alert)
        
        // "Done" action
        let doneAction = UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.didScanQRCode?(code)
            self.navigationController?.popViewController(animated: true)
        }
        
        // "Add More" action
        let addMoreAction = UIAlertAction(title: "Add More", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.didScanQRCode?(code)
            self.captureSession.startRunning() // Start the capture session again
        }
        
        alert.addAction(doneAction)
        alert.addAction(addMoreAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setupBackButton() {
        // Set the image for the back button
        let backImage = UIImage(systemName: "arrow.backward")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)) // Large and bold arrow image
        backButton.setImage(backImage, for: .normal)
        backButton.backgroundColor = .clear
        backButton.setTitle(nil, for: .normal)
        backButton.tintColor = .black // Set the arrow color (e.g., black)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 50), // Slightly larger button
            backButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
