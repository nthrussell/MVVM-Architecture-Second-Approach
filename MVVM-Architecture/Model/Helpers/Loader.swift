//
//  Loader.swift
//  MVVM-Architecture
//
//  Created by russel on 12/8/24.
//

import SVProgressHUD

class Loader {
    static func show() {
        SVProgressHUD.show()
    }
    
    static func hide() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}
