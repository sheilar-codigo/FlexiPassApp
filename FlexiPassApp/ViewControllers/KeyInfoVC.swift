//
//  KeyInfoVC.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/4/22.
//

import UIKit

class KeyInfoVC: UIViewController {

    @IBOutlet weak var lblKeyCode: UILabel!
    @IBOutlet weak var lblDoor: UILabel!
    @IBOutlet weak var lblCheckIn: UILabel!
    @IBOutlet weak var lblCheckOut: UILabel!
    @IBOutlet weak var btnUnlock: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupInteractions()
    }
    
    private func setupView() {
        // TODO: - Bind key data form keychain
    }
    
    private func setupInteractions() {
        btnUnlock.addTarget(self, action: #selector(handleBtnTapped), for: .touchUpInside)
    }
    
    @objc private func handleBtnTapped() {
        guard let unlockHomeKeyVC = UIStoryboard.UnlockHotelKeyScreen() else { return }
        let vc = UINavigationController(rootViewController: unlockHomeKeyVC)
        self.navigationController?.present(vc, animated: true)
    }
}
