//
//  DocumentPickerHelperView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 31/05/25.
//
import UniformTypeIdentifiers
import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var selectedFile: URL?

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        init(_ parent: DocumentPicker) { self.parent = parent }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.selectedFile = urls.first
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {}
    }

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let types = [UTType.content, UTType.item]
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: types)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}

