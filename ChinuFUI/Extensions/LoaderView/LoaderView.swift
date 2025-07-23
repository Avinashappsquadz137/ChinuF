//
//  LoaderView.swift
//  InventoryAppUI
//
//  Created by Sanskar IOS Dev on 18/02/25.
//

import SwiftUI

class LoaderView: UIView {

    static let shared = LoaderView()

    private var loader: UIActivityIndicatorView!

    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame = UIScreen.main.bounds
        self.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        loader = UIActivityIndicatorView(style: .large)
        loader.center = self.center
        loader.hidesWhenStopped = true
        loader.color = UIColor(Color.black)
        self.addSubview(loader)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show(in view: UIView) {
        view.addSubview(self)
        loader.startAnimating()
    }

    func hide() {
        loader.stopAnimating()
        self.removeFromSuperview()
    }
}
