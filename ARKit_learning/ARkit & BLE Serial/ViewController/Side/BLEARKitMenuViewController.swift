//
//  BLEARKitMenuViewController.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2020/01/22.
//  Copyright © 2020 鈴木公章. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol BLEARKitMenuViewControllerDelegate: class {
    func okButtonTapped(_ BLEARKitMenuViewController: BLEARKitMenuViewController, sliderValue: Double)
    func completedBLE(_ data: [[[Double]]])
}

final class BLEARKitMenuViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    weak var delegate: BLEARKitMenuViewControllerDelegate?
    private var xArray: [Double] = []
    private var zArray: [[Double]] = []
    private var nodeData: [[[Double]]] = []
    private var nodeCounter: Int = 0
    
    private var numberOfX: Int = BLEARKitSettings.Constants.numberOfX
    private var numberOfY: Int = BLEARKitSettings.Constants.numberOfY
    private var numberOfZ: Int = BLEARKitSettings.Constants.numberOfZ
    private var numberOfAll: Int {
        return numberOfX * numberOfY * numberOfZ
    }
    
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    private var characteristic: CBCharacteristic!
    private var centralManagerReady: Bool = false
    private var peripheralReady: Bool = false
    
    @IBOutlet private weak var SSIDUILabel: UILabel!
    @IBAction private func connectBtnTapped(_ sender: Any) {
        if !self.centralManagerReady {
            return
        }
        progressStatusLabel.text = "now loading..."
        sliderValueLabel.isEnabled = false
        slider.isEnabled = false
        okButton.isEnabled = false
        self.scanBLESerial3()
    }
    @IBAction private func cancelBtnTapped(_ sender: Any) {
        xArray = []
        zArray = []
        nodeData = []
        nodeCounter = 0
        progress.setProgress(0, animated: true)
        
        progressStatusLabel.text = "stop loading"
        cancelScan()
    }
    @IBOutlet private weak var progressStatusLabel: UILabel!
    @IBOutlet private weak var progress: UIProgressView!
    @IBOutlet private weak var sliderValueLabel: UILabel! {
        didSet {
            sliderValueLabel.isEnabled = false
        }
    }
    @IBOutlet private weak var slider: UISlider! {
        didSet {
            slider.isEnabled = false
        }
    }
    @IBOutlet private weak var okButton: UIButton! {
        didSet {
            okButton.isEnabled = false
        }
    }
    @IBAction private func okButtonTapped(_ sender: UIButton) {
        guard let sliderValue: Double = Double(self.sliderValueLabel.text!) else { return }
        delegate?.okButtonTapped(self, sliderValue: sliderValue)
        guard let drawerParent = parent else { return }
        guard let _drawerParent = drawerParent as? DrawerParentViewController else { return }
        _drawerParent.hiddenDrawerMenu()
    }
    @IBAction private func sliderChanged(_ sender: UISlider) {
        sliderValueLabel.text = String(sender.value * 10)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            self.centralManagerReady = true
        default:
            break
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.stopScan()
        self.connectPeripheral(peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        self.SSIDUILabel.text = peripheral.name
        self.scanService()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let service: CBService = peripheral.services![0]
        self.scanCharacteristics(service)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characreristic in service.characteristics!{
            if characreristic.uuid.uuidString == "FEEDAA03-C497-4476-A7ED-727DE7648AB1" {
                peripheral.setNotifyValue(true, for: characreristic)
            }
            
            if characreristic.uuid.uuidString == "FEEDAA02-C497-4476-A7ED-727DE7648AB1" {
                self.characteristic = characreristic
            }
        }
        peripheralReady = true
    }
    
    private func scanBLESerial3() {
        let BLESerial3UUID: [CBUUID] = [CBUUID.init(string: "FEED0001-C497-4476-A7ED-727DE7648AB1")]
        self.centralManager?.scanForPeripherals(withServices: BLESerial3UUID, options: nil)
    }
    
    private func stopScan() {
        self.centralManager.stopScan()
    }
    
    private func cancelScan() {
        self.centralManager.cancelPeripheralConnection(peripheral)
    }
    
    func connectPeripheral(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        self.centralManager.connect(self.peripheral, options: nil)
    }
    
    func scanService() {
        self.peripheral.delegate = self
        let TXCBUUID: [CBUUID] = [CBUUID.init(string: "FEED0001-C497-4476-A7ED-727DE7648AB1")]
        self.peripheral.discoverServices(TXCBUUID)
    }
    
    func scanCharacteristics(_ service: CBService) {
        let characteristics: [CBUUID] = [CBUUID.init(string: "FEEDAA02-C497-4476-A7ED-727DE7648AB1"), CBUUID.init(string: "FEEDAA03-C497-4476-A7ED-727DE7648AB1")]
        self.peripheral.discoverCharacteristics(characteristics, for: service)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let data: Data = characteristic.value!
        let dataStr = String(data: data, encoding: .utf8)
        let dataArray = dataStr!.components(separatedBy: ",")
        let dataDoubleArray = dataArray.map({ (value: String) -> Double in
            guard let double = Double(value) else {
                return 0.000
            }
            return double / 1000
        })
        nodeCounter += dataDoubleArray.count
        print(dataDoubleArray)
        print(data)
        for data in dataDoubleArray {
            xArray.append(data)
            if xArray.count == numberOfX {
                zArray.append(xArray)
                xArray = []
                
                if zArray.count == numberOfZ {
                    nodeData.append(zArray)
                    zArray = []
                }
            }
        }
        
        progress.setProgress(Float(nodeCounter/numberOfAll), animated: true)
        if nodeCounter >= numberOfAll {
            progressStatusLabel.text = "succsesful"
            sliderValueLabel.isEnabled = true
            slider.isEnabled = true
            okButton.isEnabled = true
            self.cancelScan()
            
            delegate?.completedBLE(nodeData)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
}



