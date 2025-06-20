//
//  Additemvc.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 05/08/24.
//
import UIKit

class Additemvc: UIViewController {

    @IBOutlet weak var itemtable: UITableView!
    @IBOutlet weak var countlbl: UILabel!
    @IBOutlet weak var addmisscealaneousview: UIView!
    @IBOutlet weak var additemfield: DropdownTextField!
    @IBOutlet weak var addquantityview: UITextField!

    var miscellaneousItems: [MiscellaneousItem] = []
    var inventoryItems: [InventoryItem] = []
    private var tapGesture: UITapGestureRecognizer?
    
    var qrCodeModel = QRCodeModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setPlaceholderColor(textField: additemfield, placeholderText: "Add Item", color: UIColor.black)
        setPlaceholderColor(textField: addquantityview, placeholderText: "Add Qunantity", color: UIColor.black)
        

        itemtable.register(UINib(nibName: "misscealaneouscell", bundle: nil), forCellReuseIdentifier: "misscealaneouscell")
        itemtable.delegate = self
        itemtable.dataSource = self
        self.addmisscealaneousview.layer.cornerRadius = 10
        self.addmisscealaneousview.isHidden = true
        getmisscealaneousdetail()
        
        // Setup tap gesture recognizer
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        if let tapGesture = tapGesture {
            self.view.addGestureRecognizer(tapGesture)
            tapGesture.isEnabled = false // Initially disabled
        }
    }
    
    
    func setPlaceholderColor(textField: UITextField, placeholderText: String, color: UIColor) {
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderText,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
    
    

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        self.addmisscealaneousview.isHidden = true
        tapGesture?.isEnabled = false // Disable tap gesture
    }

    func getmisscealaneousdetail() {
        let dict = [String: Any]()
        APIManager.apiCall(postData: dict as NSDictionary, url: misscealaneousapi) { result, response, error, data in
            DispatchQueue.main.async {
                Loader.hideLoader()
            }
            if let JSONData = data {
                print(JSONData)
                do {
                    let response = try JSONDecoder().decode(MiscellaneousItemResponse.self, from: JSONData)
                    if response.status {
                        self.miscellaneousItems = response.data
                        DispatchQueue.main.async {
                            self.updateDropdownData()
                        }
                    } else {
                        print(response.message)
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("API call error: \(error)")
            }
        }
    }

    private func updateDropdownData() {
        let itemNames = miscellaneousItems.map { $0.misc_item_name }
        additemfield.dropdownData = itemNames
    }

    @IBAction func backbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func SAveaction(_ sender: UIButton) {
        // Save action code
    }

    @IBAction func Submitbtnaction(_ sender: UIButton) {
        // Submit action code
    }

    @IBAction func Addinventorybtnaction(_ sender: UIButton) {
        let scannerVC = QRCodeScannerViewController()
                scannerVC.didScanQRCode = { [weak self] scannedCode in
                    guard let self = self else { return }
                    
                    // Append the scanned code to the model
                    self.qrCodeModel.addCode(scannedCode)
                    
                    self.printAllScannedCodes()
          //          print("Scanned codes: \(self.qrCodeModel.scannedCodes)")
                }
                self.navigationController?.pushViewController(scannerVC, animated: true)
    }

    func printAllScannedCodes() {
           let allScannedCodesString = qrCodeModel.scannedCodes.joined(separator: ", ")
           print("All scanned codes: \(allScannedCodesString)")
       }
    
    
//    private func showAlertWithQRCode(_ scannedCode: String) {
//        let alert = UIAlertController(title: "Scanned Code", message: "Scanned QR Code: \(scannedCode)", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        alert.addAction(okAction)
//        present(alert, animated: true, completion: nil)
//    }

    @IBAction func addmisscealaneousbtnaction(_ sender: UIButton) {
        self.addmisscealaneousview.isHidden = false
        tapGesture?.isEnabled = true // Enable tap gesture
    }

    @IBAction func savemisscealaneousbtnaction(_ sender: UIButton) {
        guard let itemName = additemfield.text, !itemName.isEmpty,
              let quantity = addquantityview.text, !quantity.isEmpty else {
            print("Item name or quantity is missing")
            return
        }

        let newItem = InventoryItem(name: itemName, quantity: quantity)
        inventoryItems.append(newItem)
        itemtable.reloadData()
        updateCountLabel() // Update count after adding new item

        additemfield.text = ""
        addquantityview.text = ""

        self.addmisscealaneousview.isHidden = true
        tapGesture?.isEnabled = false // Disable tap gesture
    }

    private func updateCountLabel() {
        countlbl.text = "Total count: \(inventoryItems.count)"
    }
}

extension Additemvc: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inventoryItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = itemtable.dequeueReusableCell(withIdentifier: "misscealaneouscell", for: indexPath) as! misscealaneouscell
        let item = inventoryItems[indexPath.row]
        cell.itemnamelbl.text = item.name
        cell.itemQuantitylbl.text = item.quantity

        cell.deletebtn.tag = indexPath.row
        cell.deletebtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        return cell
    }

    @objc func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        if index < inventoryItems.count {
            inventoryItems.remove(at: index)
            // Delete the row
            let indexPath = IndexPath(row: index, section: 0)
            itemtable.deleteRows(at: [indexPath], with: .automatic)
            // Update the tags of the remaining cells
            for i in index..<inventoryItems.count {
                if let cell = itemtable.cellForRow(at: IndexPath(row: i, section: 0)) as? misscealaneouscell {
                    cell.deletebtn.tag = i
                }
            }
            updateCountLabel() // Update count after deleting an item
        }
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.backgroundColor = UIColor.clear

        let spacerView = UIView()
        spacerView.backgroundColor = UIColor.clear
        spacerView.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(spacerView)

        NSLayoutConstraint.activate([
            spacerView.leadingAnchor.constraint(equalTo: footerView.leadingAnchor),
            spacerView.trailingAnchor.constraint(equalTo: footerView.trailingAnchor),
            spacerView.topAnchor.constraint(equalTo: footerView.topAnchor),
            spacerView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor)
        ])
        
        footerView.frame.size.height = 50
        return footerView
    }
}



struct QRCodeModel {
    var scannedCodes: [String] = []
    
    mutating func addCode(_ code: String) {
        scannedCodes.append(code)
    }
}
