//
//  UIViewController+Extension.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/4/22.
//

import UIKit
import PKHUD

extension UIViewController {
    
    func replaceRootViewController(with viewController: UIViewController) {
        guard let keyWindow = UIApplication.shared.windows.first else { return }
        UIView.transition(with: keyWindow, duration: 0, options: .init(), animations: {
            keyWindow.rootViewController = viewController
            keyWindow.makeKeyAndVisible()
        })
    }
    
    func showAlert(title: String? = nil, message: String, onAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            onAction?()
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    func showSettingsAlert(title: String, message: String, positiveButtonTitle: String = "Settings", negativeButtonTitle: String = "Cancel", negativeAction:  (() -> Void)? = nil, settingCompletionHandler:  (() -> Void)? = nil) {
        if let appSettingURL = URL(string: UIApplication.openSettingsURLString) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: negativeButtonTitle, style: .default, handler: { (_) in
                if negativeAction == nil { alert.dismiss(animated: true, completion: nil) }
                negativeAction?()
            }))
            
            alert.addAction(UIAlertAction(title: positiveButtonTitle, style: .cancel, handler: { (_) -> Void in
                guard UIApplication.shared.canOpenURL(appSettingURL) else {
                    debugPrint("can't open app setting url: ", appSettingURL)
                    return
                }
                UIApplication.shared.open(appSettingURL, options: [:], completionHandler: { _ in
                    settingCompletionHandler?()
                })
            }))
            present(alert, animated: true)
        }
    }
    
    func showLoading() {
        HUD.show(.progress, onView: view)
    }
    
    func hideLoading() {
        HUD.hide()
    }
}
