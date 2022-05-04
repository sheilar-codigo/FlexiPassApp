//
//  UIViewController+Extension.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/4/22.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
