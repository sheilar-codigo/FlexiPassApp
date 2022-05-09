//
//  UnlockHotelKeyVC.swift
//  FlexiPassApp
//
//  Created by Kyaw Zay Ya Lin Tun on 5/3/22.
//

import UIKit
import FlexipassSDK
import CoreBluetooth

class UnlockHotelKeyVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var btnUnlockDoor: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
        
    private var currentButtonState: ButtonState? {
        willSet {
            handleButtonStyle(basedOn: newValue)
        }
    }
    
    private var isReading: Bool = false
    private var bluetoothManager: CBCentralManager!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnUnlockDoor.layer.cornerRadius = btnUnlockDoor.frame.height / 2
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBluetooth()
        setupFlexipass()
        setupInteractions()
        
        showLoading()
        fp.updateMobileKey()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isReading {
            fp.stopReader()
        }
    }
    
    // MARK: - Set up funcs
    private func setupView() {
        currentButtonState = .neutral
        spinner.stopAnimating()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseBarButtonTapped))
    }
    
    private func setupBluetooth() {
        bluetoothManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey : false])
    }
    
    private func setupFlexipass() {
        fp.delegate = self
    }
    
    private func setupInteractions() {
        btnUnlockDoor.addTarget(self, action: #selector(handleKeyUnlock), for: .touchUpInside)
    }
    
    // MARK: - Action Handlers
    @objc private func handleKeyUnlock() {
        guard let currentButtonState = currentButtonState else {
            return
        }
    
        guard bluetoothManager.authorization == .allowedAlways else {
            showSettingsAlert(title: "\"FlexiPassApp\" Would Like to Use Bluetooth", message: "We need to use your bluetooth to open the door.")
            return
        }

        switch currentButtonState {
        case .neutral:
            startUnlocking()
        case .unlocking:
            stopUnlocking()
        default:
            ()
        }
    }
    
    @IBAction func handleClose(_ sender: Any) {
        openKeyInfoScreen()
    }
    
    @objc private func handleCloseBarButtonTapped() {
        openKeyInfoScreen()
    }
    
    private func openKeyInfoScreen() {
        guard let vc = UIStoryboard.KeyInfoScreen() else { return }
        replaceRootViewController(with: vc)
    }
    
    // MARK: - Private Helpers
    private func startUnlocking() {
        fp.startReader()
    }
    
    private func stopUnlocking() {
        fp.stopReader()
    }
    
    private func handleButtonStyle(basedOn state: ButtonState?) {
        guard let state = state else { return }
        switch state {
        case .neutral:
            btnUnlockDoor.backgroundColor = .systemBlue
            btnUnlockDoor.setTitle("Unlock Door", for: .normal)
        case .unlocking:
            btnUnlockDoor.backgroundColor = .systemGray
            btnUnlockDoor.setTitle("Stop", for: .normal)
        case .completed(let success):
            btnUnlockDoor.backgroundColor = success ? .systemGreen : .systemRed
            btnUnlockDoor.setTitle(
                success ? "Door opened!" : "Failed!",
                for: .normal
            )
        }
    }
    
    deinit {
        print("deinit: \(self)")
    }
}

extension UnlockHotelKeyVC {
    enum ButtonState {
        case neutral
        case unlocking
        case completed(Bool)
    }
}

extension UnlockHotelKeyVC: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.authorization {
        case .notDetermined:
            print("bluetooth: notDetermined")
        case .restricted:
            print("bluetooth: restricted")
        case .denied:
            print("bluetooth: denied")
        case .allowedAlways:
            print("bluetooth: allowedAlways")
        @unknown default:
            print("bluetooth: default")
        }
        
        switch central.state {
        case .unauthorized:
            print("bluetooth: unauthorized")
        case .unknown:
            print("bluetooth: unknown")
        case .resetting:
            print("bluetooth: resetting")
        case .unsupported:
            print("bluetooth: unsupported")
        case .poweredOff:
            print("bluetooth: poweredOff")
        case .poweredOn:
            print("bluetooth: poweredOn")
        @unknown default:
            print("bluetooth: default")
        }
    }
}

// MARK: - FlexipassCallbackDelegate

extension UnlockHotelKeyVC: FlexipassCallbackDelegate {
    
    func callback_listener(_ fpco: FlexipassCallbackObject) {
        DispatchQueue.main.async { [weak self] in
            
            switch fpco.result {
                
            case .update_success:
                self?.hideLoading()
                print("Unlock Screen: update_success")
                print("Unlock Screen: key count => \(String(describing: fp.mobileKeyCount()))")
                
            case .update_failed:
                print("Unlock Screen: update_failed")
                self?.hideLoading()
                self?.showAlert(title: "Error", message: "setup_failed")
                
            case .reader_stared:
                print("reader_stared")
                self?.spinner.startAnimating()
                self?.currentButtonState = .unlocking
                self?.isReading = true
                
            case .reader_stopped:
                print("reader_stopped")
                self?.spinner.stopAnimating()
                self?.currentButtonState = .neutral
                self?.isReading = false
                
            case .lock_reader_failure:
                self?.spinner.stopAnimating()
                self?.showAlert(title: "Error", message: "lock_reader_failure")
                
            case .lock_opened:
                self?.currentButtonState = .completed(true)
                self?.spinner.stopAnimating()
                print("lock_opened")
                
            case .lock_failed:
                self?.spinner.stopAnimating()
                self?.currentButtonState = .completed(false)
                self?.spinner.stopAnimating()
                self?.showAlert(title: "Error", message: "lock_failed")
                
            case .setupNotCompleted:
                self?.hideLoading()
                self?.showAlert(title: "Error", message: "setupNotCompleted")
                
            case .lock_timed_out:
                self?.currentButtonState = .completed(false)
                self?.spinner.stopAnimating()
                self?.showAlert(title: "Error", message: "lock_timed_out")
                
            default:
                self?.spinner.stopAnimating()
                self?.showAlert(title: "Error", message: "Something went wrong")
            }
        }
    }
}
