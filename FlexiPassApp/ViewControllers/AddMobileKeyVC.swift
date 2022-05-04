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
    @IBOutlet weak var spinnerView: SpinnerView!

    private var keychain: KeychainSwift!
    private var flexipass: Flexipass!

    private var key: String {
        return txtKeyCode.text ?? ""
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeychain()
        setupFlexipass()
        setupInteraction()
    }
    
    // MARK: - Set up funcs
    private func setupKeychain() {
        keychain = KeychainSwift()
    }
    
    private func setupFlexipass() {
        flexipass = Flexipass()
        flexipass.delegate = self
    }
    
    private func setupInteraction() {
        btnSetupKey.addTarget(self, action: #selector(handleKeySetup), for: .touchUpInside)
    }
    
    // MARK: - Action Handlers
    @objc private func handleKeySetup() {
        spinnerView.startSpinning()
        
        flexipass.useMobileKey(key, saveToKeychain, handleKeySetupFailure)
    }
    
    // MARK: - Helpers
    private func saveToKeychain(_ keyInfo: KeyInformationObject) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.keychain.set(self.key, forKey: KeychainKeys.DIGITAL_KEY_CODE)
            self.keychain.set(keyInfo.doorID, forKey: KeychainKeys.DIGITAL_KEY_ROOM)
            self.keychain.set(keyInfo.checkInDate, forKey: KeychainKeys.DIGITAL_KEY_CHECKIN)
            self.keychain.set(keyInfo.checkOutDate, forKey: KeychainKeys.DIGITAL_KEY_CHECKOUT)
        }
        
    }
    
    private func handleKeySetupFailure(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.spinnerView.stopSpinning()
            self?.showAlert(message: error.localizedDescription)
        }
    }
    
    // MARK: - Routing Logic
    private func routeToUnlockHotelKey() {
        guard let keyInfoVC = UIStoryboard.KeyInfoScreen() else { return }
        let navVC = UINavigationController(rootViewController: keyInfoVC)
        navVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(navVC, animated: true)
    }
    
}

// MARK: - FlexipassCallbackDelegate
extension AddMobileKeyVC: FlexipassCallbackDelegate {
    func callback_listener(_ fpco: FlexipassCallbackObject) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            switch fpco.result {
            case .setup_success:
                self.flexipass.updateMobileKey()
                print(("Successfully setup the key on this device. Digital Key is ready to use ✅."))
            case .update_success:
                self.spinnerView.stopSpinning()
                self.routeToUnlockHotelKey()
                print("Key is updated successfully ✅.")
            case .update_failed:
                self.spinnerView.stopSpinning()
                print("Can't update key ⚠️.")
            default:
                ()
            }
        }
    }
}
