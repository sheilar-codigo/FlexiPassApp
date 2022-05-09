//
//  AddMobileKeyVC.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/3/22.
//

import UIKit
import FlexipassSDK
import KeychainSwift

class AddMobileKeyVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var txtKeyCode: UITextField!
    @IBOutlet weak var btnSetupKey: UIButton!

    private var keychain: KeychainSwift!

    private var key: String {
        return txtKeyCode.text ?? ""
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlexipass()
        setupKeychain()
        setupInteraction()
    }
    
    // MARK: - Set up funcs
    private func setupKeychain() {
        keychain = KeychainSwift()
    }
    
    private func setupFlexipass() {
        fp.delegate = self
    }
    
    private func setupInteraction() {
        btnSetupKey.addTarget(self, action: #selector(handleKeySetup), for: .touchUpInside)
    }
    
    // MARK: - Action Handlers
    @objc private func handleKeySetup() {
        txtKeyCode.resignFirstResponder()
        showLoading()
        fp.useMobileKey(key) { [weak self] keyInfo in
            self?.keychain.set(self?.key ?? "", forKey: KeychainKeys.DIGITAL_KEY_CODE)
            self?.keychain.set(keyInfo.doorID, forKey: KeychainKeys.DIGITAL_KEY_ROOM)
            self?.keychain.set(keyInfo.checkInDate, forKey: KeychainKeys.DIGITAL_KEY_CHECKIN)
            self?.keychain.set(keyInfo.checkOutDate, forKey: KeychainKeys.DIGITAL_KEY_CHECKOUT)
        } _: { [weak self] error in
            DispatchQueue.main.async {
                self?.hideLoading()
                self?.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Routing Logic
    private func openKeyInfoScreen() {
        guard let keyInfoVC = UIStoryboard.KeyInfoScreen() else { return }
        keyInfoVC.modalPresentationStyle = .fullScreen
        keyInfoVC.isComeFromSetupScreen = true
        self.present(keyInfoVC, animated: true, completion: nil)
    }
    
    deinit {
        print("deinit: \(self)")
    }
}

// MARK: - FlexipassCallbackDelegate
extension AddMobileKeyVC: FlexipassCallbackDelegate {
    
    func callback_listener(_ fpco: FlexipassCallbackObject) {
        DispatchQueue.main.async { [weak self] in
            
            switch fpco.result {
            case .startup_success:
                print("Add Key Screen: startup_success")
                
            case .startup_failed:
                self?.showAlert(title: "Error", message: "startup_failed")
                
            case .setup_success:
                print("Add Key Screen: setup_success")
                self?.showLoading()
                fp.updateMobileKey()
                
            case .setup_failed:
                self?.showAlert(title: "Error", message: "setup_failed")
                
            case .update_success:
                print("Add Key Screen: update_success")
                print("Add Key Screen: key count => \(String(describing: fp.mobileKeyCount()))")
                self?.hideLoading()
                self?.openKeyInfoScreen()
                
            case .update_failed:
                self?.hideLoading()
                self?.showAlert(title: "Error", message: "update_failed")
                
            case .setupNotCompleted:
                print("setupNotCompleted")
                
            default:
                break
            }
        }
    }
}

