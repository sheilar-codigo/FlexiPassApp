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
    private var flexipassManager: FlexipassManager!

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
        flexipassManager = .shared
        flexipassManager.delegate = self
        flexipassManager.setupDelegate = self
        if !flexipassManager.isStartUpFinished {
            btnSetupKey.isUserInteractionEnabled = false
            btnSetupKey.backgroundColor = .gray
        }
    }
    
    private func setupInteraction() {
        btnSetupKey.addTarget(self, action: #selector(handleKeySetup), for: .touchUpInside)
    }
    
    // MARK: - Action Handlers
    @objc private func handleKeySetup() {
        txtKeyCode.resignFirstResponder()
        showLoading()
        
        flexipassManager.useMobileKey(keyCode: key)
    }
    
    // MARK: - Routing Logic
    private func openKeyInfoScreen() {
        guard let keyInfoVC = UIStoryboard.KeyInfoScreen() else { return }
        let navVC = UINavigationController(rootViewController: keyInfoVC)
        navVC.modalPresentationStyle = .fullScreen
        self.replaceRootViewController(with: navVC)
    }
    
    deinit {
        print("deinit: \(self)")
    }
}

// MARK: - FlexipassCallbackDelegate
extension AddMobileKeyVC: FlexipassManagerDelegate, KeySetupDelegate {
    
    func didStartUpSuccess() {
        print("startup_success")
        btnSetupKey.isUserInteractionEnabled = true
        btnSetupKey.backgroundColor = .blue
    }
    
    func didStartUpFailed(error: String) {
        showAlert(title: "Error", message: error)
    }
    
    func didSetupNotCompleted(error: String) {
        showAlert(title: "Error", message: error)
    }
    
    func didSuccess() {
        hideLoading()
        openKeyInfoScreen()
    }
    
    func didFailed(error: String) {
        hideLoading()
        showAlert(title: "Error", message: error)
    }
}
