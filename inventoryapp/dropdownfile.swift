//
//  dropdownfile.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 05/08/24.
//
import UIKit
import DropDown

class DropdownTextField: UITextField {

    var dropDown: DropDown!
    var dropdownData: [String] = [] {
        didSet {
            dropDown.dataSource = dropdownData
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDropdown()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDropdown()
    }

    private func setupDropdown() {
        dropDown = DropDown()
        dropDown.anchorView = self
        dropDown.bottomOffset = CGPoint(x: 0, y: self.bounds.height) // Position dropdown below text field
        dropDown.direction = .bottom // Ensure dropdown opens downward
        dropDown.selectionAction = { [weak self] (index, item) in
            self?.text = item
            self?.resignFirstResponder()
        }

        // Show dropdown on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDropdown))
        self.addGestureRecognizer(tapGesture)

        // Disable text field editing
        self.isUserInteractionEnabled = true
    }

    @objc private func showDropdown() {
        dropDown.show()
    }

    // Prevent the text field from being editable
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }

    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }

    override func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool {
        return false
    }
}
