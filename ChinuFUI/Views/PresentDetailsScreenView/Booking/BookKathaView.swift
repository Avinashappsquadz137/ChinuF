//
//  BookKathaView.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 30/05/25.
//
import SwiftUI

enum ActiveSheetType {
    case category
    case time
}

extension ActiveSheetType: Identifiable {
    var id: Int {
        switch self {
        case .category: return 0
        case .time: return 1
        }
    }
}
struct BookKathaView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var activeSheet: ActiveSheetType? = nil
    @State private var selectedChannel: ChannelList? = nil
    @State private var selectedCategory: KathaCategory? = nil

    @State private var channels: [ChannelList] = []
    @State private var kathaTime: [KathaTimingCategory] = []
    @State private var existGuru: [ExistGuruList] = []

    @State private var categoryList: [KathaCategory] = []

    @State private var selectedUIImage: UIImage?
    @State private var selectedFileUrl: URL?
    
    @State private var suggestedFromDate = Date()
    @State private var suggestedToDate = Date()
    @State private var selectedGuru: ExistGuruList? = nil

    @State private var selectedSlot: KathaTimingCategory?
    @State private var guruSearchText: String = ""
    @State private var showGuruList = false
    
    @State private var venue = ""
    @State private var amount = ""
    @State var isSelected: Bool
    
    func filteredGuruList() -> [ExistGuruList] {
        if guruSearchText.isEmpty {
            return existGuru
        } else {
            return existGuru.filter { guru in
                guru.guru_name?.localizedCaseInsensitiveContains(guruSearchText) ?? false
            }
        }
    }


    var body: some View {
        VStack(alignment: .leading){
            ScrollView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(channels, id: \.sno) { channel in
                            HStack(spacing: 1) {
                                Button(action: {
                                    selectedChannel = (selectedChannel?.channelName == channel.channelName) ? nil : channel
                                }) {
                                    Image(systemName: selectedChannel?.channelName == channel.channelName ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(selectedChannel?.channelName == channel.channelName ? .green : .gray)
                                        .imageScale(.medium)
                                }
                                let imageUrlString = "\(Constant.imageURL)\(channel.channel_thumbnail ?? "")" 
                                AsyncImage(url: URL(string: "\(imageUrlString)")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                }
                                .frame(width: 80, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .shadow(radius: 2)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                
                // MARK: - Dropdown (Picker) for Katha Category
                Button(action: {
                    activeSheet = .category
                }) {
                    HStack {
                        Text(selectedCategory?.kathaName ?? "Select Katha Category")
                            .foregroundColor(selectedCategory?.kathaName == nil ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                        
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                    .padding(.horizontal)
                }
                FilePickerAdsView(
                    selectedCategory: $selectedCategory,
                    selectedUIImage: $selectedUIImage,
                    selectedFileUrl: $selectedFileUrl
                )
                    Text("Select Date & Time")
                        .font(.headline)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                dateAndTimeSelectionView
                selectGuruAndValue
                
            }
            
            Spacer()
        }
        .navigationTitle("Book Katha")
        .actionSheet(item: $activeSheet) { sheet in
            switch sheet {
            case .category:
                return ActionSheet(
                    title: Text("Select Katha Category"),
                    buttons: categoryList.map { category in
                        .default(Text(category.kathaName ?? "Unknown")) {
                            selectedCategory = category
                            getKathaTimingCategoryAPI(kathaIds: String(category.iD ?? 0))
                        }
                    } + [.cancel()]
                )
            case .time:
                return ActionSheet(
                    title: Text("Select Katha Time"),
                    buttons: kathaTime.map { slot in
                            .default(Text("\(slot.slotTiming ?? "") - \(slot.slotName ?? "") ")) {
                            selectedSlot = slot
                        }
                    } + [.cancel()]
                )
            }
        }
        .overlay(ToastView())
        .onAppear {
            channelListApi()
            kathaCategoryApi()
            existGuruListAPI()
        }
    }

    private var selectGuruAndValue: some View {
        VStack(alignment: .leading) {
            Text("Select Guru")
                .font(.headline)
                .padding(.horizontal)
            
            TextField("Search Guru...", text: $guruSearchText, onEditingChanged: { editing in
                showGuruList = editing
            })
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
            .cornerRadius(8)
            .padding(.horizontal)
        
            if showGuruList && !filteredGuruList().isEmpty {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(filteredGuruList(), id: \.guru_ID) { guru in
                            Text(guru.guru_name ?? "Unknown")
                                .padding(.horizontal)
                                .padding(.vertical, 5)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .onTapGesture {
                                    guruSearchText = guru.guru_name ?? ""
                                    showGuruList = false
                                    selectedGuru = guru
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxHeight: 200)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 16) {
                    TextField("Enter Venue", text: $venue)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                    
                    TextField("Enter Amount", text: $amount)
                        .keyboardType(.numberPad)
                        .onChange(of: amount) { newValue in
                            amount = newValue.filter { $0.isNumber }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                }
            }
            .padding(.horizontal)
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Button(action: {
                        isSelected.toggle()
                    }) {
                        Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(isSelected ? .green : .gray)
                            .imageScale(.large)
                    }

                    Text("GST")
                        .fontWeight(.semibold)

                    Spacer()

                    Text("Amount: ₹\(amount)")
                        .foregroundColor(.secondary)
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
                .padding(.horizontal)
            }
            CustonButton(title: "Submit", backgroundColor: .maroon) {
                BookKathaApi()
            }.padding(20)
        }
        
    }
    private var dateAndTimeSelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 16){
                VStack(alignment: .leading) {
                 
                    DatePicker(
                        "From",
                        selection: $suggestedFromDate,
                        displayedComponents: [.date]
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                }
                .frame(maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                   
                    DatePicker(
                        "To",
                        selection: $suggestedToDate,
                        in: suggestedFromDate...,
                        displayedComponents: [.date]
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Button(action: {
                    activeSheet = .time
                }) {
                    HStack {
                        Text(selectedSlot == nil ? "Select Time" : "\(selectedSlot?.slotName ?? "") \(selectedSlot?.slotTiming ?? "")")
                            .foregroundColor(selectedSlot == nil ? .gray : .primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                    }
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                }
                .padding(.horizontal)
                
                if selectedSlot?.slotName == "Custom" {
                    HStack(alignment: .center, spacing: 16){
                        VStack(alignment: .leading) {
                          
                            DatePicker(
                                "From",
                                selection: $suggestedFromDate,
                                displayedComponents: [.hourAndMinute]
                            )
                           
                            .datePickerStyle(.compact)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading) {
                            
                            DatePicker(
                                "To",
                                selection: $suggestedToDate,
                                in: suggestedFromDate...,
                                displayedComponents: [.hourAndMinute]
                            )
                            
                            .datePickerStyle(.compact)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray))
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
    func existGuruListAPI(){
        var dict = Dictionary<String, Any>()
        dict["EmpCode"] = UserDefaultsManager.getEmpCode()
        dict["searchTerm"] = ""
        
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.existGuruList,
            method: .post,
            param: dict,
            model: ExistGuruListModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.existGuru = model.data ?? []
                    print(model.data ?? [])
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }

    func getKathaTimingCategoryAPI(kathaIds : String){
        var dict = Dictionary<String, Any>()
        dict["category_id"] = kathaIds
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.getKathaTimingCategory,
            method: .post,
            param: dict,
            model: KathaTimingCategoryModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.kathaTime = model.data ?? []
                    print(model.data ?? [])
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
    
    func channelListApi() {
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.channelList,
            method: .post,
            param: [:],
            model: ChannelListModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.channels = model.data ?? []
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
    func kathaCategoryApi() {
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.kathaCategory,
            method: .post,
            param: [:],
            model: KathaCategoryModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.categoryList = model.data ?? []
                case .failure(let error):
                    print("API Error: \(error)")
                }
            }
        }
    }
    func BookKathaApi() {                                                
        var dict = [String: Any]()
        dict["EmpCode"] = UserDefaultsManager.getEmpCode()
        if let selectedGuru = selectedGuru {
            dict["guru_ID"] = String(selectedGuru.guru_ID ?? 0)
            dict["name"] = selectedGuru.guru_name ?? ""
        } else {
            dict["guru_ID"] = "0"
            dict["name"] = guruSearchText
        }
        dict["channel"] = "\(selectedChannel?.sno ?? 0)"
        dict["amount"] = amount
        dict["gst"] = isSelected ? "yes" : "no"
        dict["gst_percentage"] = "18"
        dict["venue"] = venue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dict["katha_from_date"] = dateFormatter.string(from: suggestedFromDate)
        dict["katha_to_date"] = dateFormatter.string(from: suggestedToDate)
        dict["katha_category_id"] = "\(selectedCategory?.iD ?? 0)"
        if let slot = selectedSlot {
            dict["katha_slot"] = slot.sno ?? ""
            if slot.slotName == "Custom" {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "HH:mm"
                dict["start_time"] = timeFormatter.string(from: suggestedFromDate)
                dict["end_time"] = timeFormatter.string(from: suggestedToDate)
            }
        }
        if selectedUIImage != nil || selectedFileUrl != nil {
            var imagesData: [String: Data] = [:]

            if let selectedUIImage = selectedUIImage,
               let imageData = selectedUIImage.jpegData(compressionQuality: 0.8) {
                imagesData["image"] = imageData
            }

            if let fileUrl = selectedFileUrl,
               let fileData = try? Data(contentsOf: fileUrl) {
                imagesData["file"] = fileData
            }

            ApiClient.shared.callHttpMethod(
                apiendpoint: Constant.kathabookingApi,
                method: .post,
                param: dict,
                model: GetSuccessMessageBook.self,
                isMultipart: true,
                images: imagesData
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        ToastManager.shared.show(message: model.message ?? "Successfully booked katha")
                        dismiss()
                    case .failure(let error):
                        ToastManager.shared.show(message: "Error: \(error.localizedDescription)")
                        print("Error booking katha:", error)
                    }
                }
            }

        } else {
            ApiClient.shared.callHttpMethod(
                apiendpoint: Constant.kathabookingApi,
                method: .post,
                param: dict,
                model: GetSuccessMessageBook.self,
                isMultipart: false
            ) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let model):
                        if model.status == true {
                            ToastManager.shared.show(message: model.message ?? "Successfully booked katha")
                            dismiss()
                        } else {
                            ToastManager.shared.show(message: model.message ?? "Booking failed")
                        }
                    case .failure(let error):
                        ToastManager.shared.show(message: "Error: \(error.localizedDescription)")
                        print("Error booking katha:", error)
                    }
                }
            }
        }
    }
}


