//
//  BLESerialViewController.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2019/11/10.
//  Copyright © 2019 鈴木公章. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLESerialViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var characteristic: CBCharacteristic!
    var centralManagerReady: Bool = false
    var peripheralReady: Bool = false
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var SSIDUILabel: UILabel!
    
    // MARK: - IBAction
    
    @IBAction func connectBtnTapped(_ sender: Any) {
        if !self.centralManagerReady {
            return
        }
        
        self.scanBLESerial3()
    }
    
    @IBAction func send1BtnTapped(_ sender: Any) {
        if !peripheralReady {
            return
        }
        
        var val1: Int = 1
        let data: NSData = NSData.init(bytes: &val1, length: 1)
        self.peripheral.writeValue(data as Data, for: self.characteristic, type: .withoutResponse)
    }
    
    @IBAction func send2BtnTapped(_ sender: Any) {
        if !peripheralReady {
            return
        }
        
        var val2: Int = 2
        let data: NSData = NSData.init(bytes: &val2, length: 1)
        self.peripheral.writeValue(data as Data, for: self.characteristic, type: .withoutResponse)
    }
    
    // MARK: - CBCentralManager Delegate
    
    // CBCentralManagerの状態が変化するたびに呼ばれる
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            self.centralManagerReady = true
        default:
            break
        }
    }
    
    // Scanをして、該当のBLE(ペリフェラル)が見つかると呼ばれる
    // 第2引数に該当のBLE（ペリフェラル）が渡されてくる
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("発見したBLE: \(peripheral)")
        self.stopScan()
        self.connectPeripheral(peripheral: peripheral)
    }
    
    // BLE（ペリフェラル）に接続が成功すると呼ばれる
    // 第2引数に接続したBLE（ペリフェラル）が渡されてくる
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("接続したBLE: \(peripheral)")
        self.SSIDUILabel.text = peripheral.name
        self.scanService()
    }
    
    // MARK: - CBPeripheralDelegate Delegate
    
    // サービスを発見すると呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let service: CBService = peripheral.services![0]
        self.scanCharacteristics(service)
    }
    
    // キャラスタリスティックを発見すると呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        let characteristic: CBCharacteristic = service.characteristics![0]
        self.characteristic = characteristic
        
        peripheralReady = true
    }
    
    // MARK: - Method
    
    func scanBLESerial3() {
        let BLESerial3UUID: [CBUUID] = [CBUUID.init(string: "FEED0001-C497-4476-A7ED-727DE7648AB1")]
        self.centralManager?.scanForPeripherals(withServices: BLESerial3UUID, options: nil)
    }
    
    func stopScan() {
        self.centralManager.stopScan()
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
        let characteristics: [CBUUID] = [CBUUID.init(string: "FEEDAA02-C497-4476-A7ED-727DE7648AB1")]
        self.peripheral.discoverCharacteristics(characteristics, for: service)
    }
    
    // MARK: - Get Value
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let data: Data = characteristic.value!
        let hexStr = data.map { String(format: "%02hhx ", $0) }.joined()
        print(hexStr)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        if let error = error {
            print("Failed... error: \(error)")
            return
        }
        
        print("Succeeded! service uuid: \(characteristic.service.uuid), characteristic uuid: \(characteristic.uuid), value: \(characteristic.value)")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(navigationController!)
        // centralManagerを初期化する
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
