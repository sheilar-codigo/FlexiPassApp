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
    private var flexipassManager: FlexipassManager!
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // load key
        showLoading()
        flexipassManager.updateMobileKey()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isReading {
            flexipassManager.stopReader()
        }
    }
    
    // MARK: - Set up funcs
    private func setupView() {
        btnUnlockDoor.isHidden = true
        currentButtonState = .neutral
        spinner.stopAnimating()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleCloseBarButtonTapped))
    }
    
    private func setupBluetooth() {
        bluetoothManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey : false])
    }
    
    private func setupFlexipass() {
        flexipassManager = .shared
        flexipassManager.delegate = self
        flexipassManager.doorUnlockDelegate = self
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
        self.dismiss(animated: true)
    }
    
    @objc private func handleCloseBarButtonTapped() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Private Helpers
    private func startUnlocking() {
        flexipassManager.startReader()
    }
    
    private func stopUnlocking() {
        flexipassManager.stopReader()
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

extension UnlockHotelKeyVC: FlexipassManagerDelegate, DoorUnlockDelegate {
    
    
    func didStartUpSuccess() {
        flexipassManager.updateMobileKey()
    }
    
    func didStartUpFailed(error: String) {
        showAlert(title: "Error", message: error)
    }
    
    func didSetupNotCompleted(error: String) {
        hideLoading()
        showAlert(title: "Error", message: error)
    }
    
    func didUpdateSuccess() {
        hideLoading()
        btnUnlockDoor.isHidden = false
    }
    
    func didUpdateFailed(error: String) {
        spinner.stopAnimating()
        showAlert(title: "Error", message: error)
    }
    
    func didLockOpened() {
        currentButtonState = .completed(true)
        spinner.stopAnimating()
        print("Door lock is opened. You can now go into the room 🥳.")
    }
    
    func didLockFailed(error: String) {
        spinner.stopAnimating()
        currentButtonState = .completed(false)
        spinner.stopAnimating()
        showAlert(title: "Error", message: error)
    }
    
    func didReaderStarted() {
        spinner.startAnimating()
        currentButtonState = .unlocking
        isReading = true
    }
    
    func didReaderStopped() {
        print("reader_stop")
        spinner.stopAnimating()
        currentButtonState = .neutral
        isReading = false
    }
    
    func didLoadReaderFailure(error: String) {
        spinner.stopAnimating()
        showAlert(title: "Error", message: error)
    }
    
    func didLockBusy() {
        currentButtonState = .completed(false)
        spinner.stopAnimating()
        showAlert(title: "Error", message: "lock_busy")
    }
    
    func didLockTimeout() {
        currentButtonState = .completed(false)
        spinner.stopAnimating()
        showAlert(title: "lock_timed_out", message: "Lock timeout error ⚠️.")
    }
}
