//
//  HomeMasterDetailViewModel.swift
//  SanskarEPUI
//
//  Created by Sanskar IOS Dev on 23/07/25.
//

import SwiftUI

class HomeMasterDetailViewModel: ObservableObject {
    @Published var masterDetail: HomeMasterDetail? = nil
   
    func getMasterDetail() {
        let params: [String: Any] = [
            "EmpCode": UserDefaultsManager.getEmpCode()
        ]
        ApiClient.shared.callmethodMultipart(
            apiendpoint: Constant.employeeMasterDetail,
            method: .post,
            param: params,
            model: HomeMasterDetailModel.self
        ) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    if model.status == true {
                        self.masterDetail = model.data
                        UserDefaultsManager.setPlBalance(self.masterDetail?.pl_balance ?? "")
                    } else {
                        ToastManager.shared.show(message: model.message ?? "Something went wrong.")
                    }
                case .failure(let error):
                    ToastManager.shared.show(message: error.localizedDescription)
                    print("API Error: \(error)")
                }
            }
        }
    }
}
