//
//  Addinventordetailvc.swift
//  InventoryApp
//
//  Created by Sanskar IOS Dev on 06/08/24.
//
import UIKit

class Addinventordetailvc: UIViewController {

    @IBOutlet weak var itemtable: UITableView!
    @IBOutlet weak var countlbl: UILabel!
    @IBOutlet weak var addmisscealaneousview: UIView!
    @IBOutlet weak var additemfield: DropdownTextField!
    @IBOutlet weak var addquantityview: UITextField!

    var miscellaneousItems: [MiscellaneousItem] = []
    var inventoryItems: [InventoryItem] = []
    var data: Datum?
    var newMiscellaneousItems: [Misproduct] = []
    private var tapGesture: UITapGestureRecognizer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Data at viewDidLoad: \(String(describing: data))")
        setPlaceholderColor(textField: additemfield, placeholderText: "Add Item", color: UIColor.black)
        setPlaceholderColor(textField: addquantityview, placeholderText: "Add Qunantity", color: UIColor.black)
        itemtable.dataSource = self
        itemtable.delegate = self
        itemtable.register(UINib(nibName: "misscealaneouscell", bundle: nil), forCellReuseIdentifier: "misscealaneouscell")
        itemtable.register(UINib(nibName: "Inventoryitemcell", bundle: nil), forCellReuseIdentifier: "Inventoryitemcell")
        self.addmisscealaneousview.layer.cornerRadius = 10
        self.addmisscealaneousview.isHidden = true

        getmisscealaneousdetail()
        updateCountLabel() // Initial count update
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
    private func updateDropdownData() {
        let itemNames = miscellaneousItems.map { $0.misc_item_name }
        additemfield.dropdownData = itemNames
    }
    func getmisscealaneousdetail() {
        let dict = [String: Any]()
        APIManager.apiCall(postData: dict as NSDictionary, url: misscealaneousapi) { result, response, error, data in
            DispatchQueue.main.async {
                Loader.hideLoader()
            }
            if let JSONData = data {
                print("JSON Data: \(JSONData)")
                do {
                    let response = try JSONDecoder().decode(MiscellaneousItemResponse.self, from: JSONData)
                    if response.status {
                        self.miscellaneousItems = response.data
                        DispatchQueue.main.async {
                            self.updateDropdownData()
                            self.itemtable.reloadData() // Reload table view after data is fetched
                            self.updateCountLabel() // Update count after reloading data
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
            DispatchQueue.main.async {
                // Handle the scanned QR code
                self?.showAlertWithQRCode(scannedCode)
            }
        }
        self.navigationController?.pushViewController(scannerVC, animated: true)
    }

    private func showAlertWithQRCode(_ scannedCode: String) {
        let alert = UIAlertController(title: "Scanned Code", message: "Scanned QR Code: \(scannedCode)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

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
        let totalItems = (data?.products.count ?? 0) + (data?.misproducts?.count ?? 0) + newMiscellaneousItems.count + inventoryItems.count
        countlbl.text = "Total count: \(totalItems)"
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        self.addmisscealaneousview.isHidden = true
        tapGesture?.isEnabled = false // Disable tap gesture
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension Addinventordetailvc: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (data?.products.count ?? 0) + (data?.misproducts?.count ?? 0) + newMiscellaneousItems.count + inventoryItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < (data?.misproducts?.count ?? 0) {
            let cell = itemtable.dequeueReusableCell(withIdentifier: "misscealaneouscell", for: indexPath) as! misscealaneouscell
            let misProduct = data?.misproducts?[indexPath.row]
            cell.itemnamelbl.text = misProduct?.itemName
            cell.itemQuantitylbl.text = misProduct?.itemQuantity

            cell.deletebtn.tag = indexPath.row
            cell.deletebtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
            return cell
        } else if indexPath.row < (data?.misproducts?.count ?? 0) + newMiscellaneousItems.count {
            let newIndex = indexPath.row - (data?.misproducts?.count ?? 0)
            let cell = itemtable.dequeueReusableCell(withIdentifier: "misscealaneouscell", for: indexPath) as! misscealaneouscell
            let misProduct = newMiscellaneousItems[newIndex]
            cell.itemnamelbl.text = misProduct.itemName
            cell.itemQuantitylbl.text = misProduct.itemQuantity

            cell.deletebtn.tag = indexPath.row
            cell.deletebtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
            return cell
        } else if indexPath.row < (data?.misproducts?.count ?? 0) + newMiscellaneousItems.count + inventoryItems.count {
            let inventoryIndex = indexPath.row - (data?.misproducts?.count ?? 0) - newMiscellaneousItems.count
            let cell = itemtable.dequeueReusableCell(withIdentifier: "misscealaneouscell", for: indexPath) as! misscealaneouscell
            let inventoryItem = inventoryItems[inventoryIndex]
            cell.itemnamelbl.text = inventoryItem.name
            cell.itemQuantitylbl.text = inventoryItem.quantity

            cell.deletebtn.tag = indexPath.row
            cell.deletebtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
            return cell
        } else {
            let productIndex = indexPath.row - (data?.misproducts?.count ?? 0) - newMiscellaneousItems.count - inventoryItems.count
            let cell = itemtable.dequeueReusableCell(withIdentifier: "Inventoryitemcell", for: indexPath) as! Inventoryitemcell
            let product = data?.products[productIndex]
            cell.itemnamelbl.text = product?.itemName
            cell.itemtypelbl.text = product?.modelNo
            cell.itemmodlenolbl.text = product?.srNumber

            cell.deletebtn.tag = indexPath.row
            cell.deletebtn.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
            return cell
        }
    }

    @objc func deleteButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        if index < (data?.misproducts?.count ?? 0) {
            data?.misproducts?.remove(at: index)
        } else if index < (data?.misproducts?.count ?? 0) + newMiscellaneousItems.count {
            let newIndex = index - (data?.misproducts?.count ?? 0)
            newMiscellaneousItems.remove(at: newIndex)
        } else if index < (data?.misproducts?.count ?? 0) + newMiscellaneousItems.count + inventoryItems.count {
            let inventoryIndex = index - (data?.misproducts?.count ?? 0) - newMiscellaneousItems.count
            inventoryItems.remove(at: inventoryIndex)
        } else {
            let productIndex = index - (data?.misproducts?.count ?? 0) - newMiscellaneousItems.count - inventoryItems.count
            data?.products.remove(at: productIndex)
        }
        // Reload the table view or delete the specific row
        itemtable.reloadData()
        // or use itemtable.deleteRows(at: [indexPath], with: .automatic)
        updateCountLabel() // If you have a count label to update
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let data = data else {
            return 80 // Default height if no data
        }
        if indexPath.row < (data.misproducts?.count ?? 0) {
            return 100 // Height for miscellaneous items
        } else if indexPath.row < (data.misproducts?.count ?? 0) + newMiscellaneousItems.count {
            return 100 // Height for new miscellaneous items
        } else if indexPath.row < (data.misproducts?.count ?? 0) + newMiscellaneousItems.count + inventoryItems.count {
            return 100 // Height for inventory items
        } else {
            return 120 // Height for inventory items
        }
    }
}
