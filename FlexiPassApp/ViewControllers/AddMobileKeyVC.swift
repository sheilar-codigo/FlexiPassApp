//
//  AddMobileKeyVC.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/3/22.
//

import UIKit

class AddMobileKeyVC: UIViewController {
    
    @IBOutlet weak var txtKeyCode: UITextField!
    @IBOutlet weak var btnSetupKey: UIButton!

    var key: String {
        return txtKeyCode.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInteraction()
    }
    
    private func setupInteraction() {
        btnSetupKey.addTarget(self, action: #selector(routeToUnlockHotelKey), for: .touchUpInside)
    }
    
    @objc private func routeToUnlockHotelKey() {
        guard let keyInfoVC = UIStoryboard.KeyInfoScreen() else { return }
        let navVC = UINavigationController(rootViewController: keyInfoVC)
        navVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(navVC, animated: true)
    }
    
}
