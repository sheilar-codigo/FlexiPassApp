//
//  KeyInfoVC.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/4/22.
//

import UIKit
import KeychainSwift

class KeyInfoVC: UIViewController {

    @IBOutlet weak var lblKeyCode: UILabel!
    @IBOutlet weak var lblDoor: UILabel!
    @IBOutlet weak var lblCheckIn: UILabel!
    @IBOutlet weak var lblCheckOut: UILabel!
    @IBOutlet weak var btnUnlock: UIButton!
    
    private var keychain: KeychainSwift!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeychain()
        setupView()
        setupInteractions()
    }
    
    
    // MARK: - Set up funcs
    private func setupView() {
        lblKeyCode.text = keychain.get(KeychainKeys.DIGITAL_KEY_CODE)
        lblDoor.text = keychain.get(KeychainKeys.DIGITAL_KEY_ROOM)
        lblCheckIn.text = keychain.get(KeychainKeys.DIGITAL_KEY_CHECKIN)
        lblCheckOut.text = keychain.get(KeychainKeys.DIGITAL_KEY_CHECKOUT)
    }
    
    private func setupKeychain() {
        keychain = KeychainSwift()
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
