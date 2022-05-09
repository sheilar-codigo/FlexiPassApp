//
//  KeyInfoVC.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/4/22.
//

import UIKit
import KeychainSwift
import FlexipassSDK
import PKHUD

class KeyInfoVC: UIViewController {

    @IBOutlet weak var lblKeyCode: UILabel!
    @IBOutlet weak var lblDoor: UILabel!
    @IBOutlet weak var lblCheckIn: UILabel!
    @IBOutlet weak var lblCheckOut: UILabel!
    @IBOutlet weak var btnUnlock: UIButton!
    
    var isComeFromSetupScreen: Bool = false
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fp.delegate = self
        setupInteractions()
        showData()
    }
    
    
    // MARK: - Set up funcs
    private func showData() {
        let keyCode = keychain.get(KeychainKeys.DIGITAL_KEY_CODE) ?? ""
        let door = keychain.get(KeychainKeys.DIGITAL_KEY_ROOM) ?? ""
        let checkIn = keychain.get(KeychainKeys.DIGITAL_KEY_CHECKIN) ?? ""
        let checkOut = keychain.get(KeychainKeys.DIGITAL_KEY_CHECKOUT) ?? ""
        
        lblKeyCode.text = keyCode
        lblDoor.text = door
        lblCheckIn.text = checkIn
        lblCheckOut.text = checkOut
    }
  
    private func setupInteractions() {
        btnUnlock.addTarget(self, action: #selector(handleBtnTapped), for: .touchUpInside)
    }
    
    private func openKeySetupScreen() {
        guard let vc = UIStoryboard.AddMobileKeyScreen() else {
            return
        }
        self.replaceRootViewController(with: vc)
    }
    
    @objc private func handleBtnTapped() {
        guard let vc = UIStoryboard.UnlockHotelKeyScreen() else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func handleRevokeKey(_ sender: Any) {
        showLoading()
        fp.updateMobileKey()
    }

    deinit {
        print("deinit: \(self)")
    }
    
}

// MARK: - FlexipassCallbackDelegate
extension KeyInfoVC: FlexipassCallbackDelegate {
    
    func callback_listener(_ fpco: FlexipassCallbackObject) {
        DispatchQueue.main.async { [weak self] in
            
            switch fpco.result {
                
            case .startup_success:
                print("Key Info Screen: startup_success")
            
            case .update_success:
                fp.terminateMobileKey()
                print("Key Info Screen: update_success")
                print("Key Info Screen: key count => \(String(describing: fp.mobileKeyCount()))")
                
            case .update_failed:
                print("Key Info Screen: update_failed")
                self?.hideLoading()
                self?.showAlert(title: "Error", message: "setup_failed")
                
            case .terminated:
                self?.hideLoading()
                self?.keychain.delete(KeychainKeys.DIGITAL_KEY_CODE)
                self?.keychain.delete(KeychainKeys.DIGITAL_KEY_ROOM)
                self?.keychain.delete(KeychainKeys.DIGITAL_KEY_CHECKIN)
                self?.keychain.delete(KeychainKeys.DIGITAL_KEY_CHECKOUT)
                self?.openKeySetupScreen()
                
            case .termination_failed:
                self?.hideLoading()
                self?.showAlert(title: "Error", message: "termination_failed")
          
            case .setupNotCompleted:
                self?.hideLoading()
                self?.showAlert(title: "Error", message: "setupNotCompleted")
                
            default:
                self?.hideLoading()
                self?.showAlert(title: "Error", message: "Something went wrong")
            }
        }
    }
}

