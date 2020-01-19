//
//  BLESerialViewController3.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2020/01/20.
//  Copyright © 2020 鈴木公章. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLESerialViewController3: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    @IBOutlet weak var SSIDUILabel: UILabel!
    
    // MARK: - IBAction
    
    @IBAction func connectBtnTapped(_ sender: Any) {
        scanStart()
    }
    
    @IBAction func send1BtnTapped(_ sender: Any) {
        
        var val1: Int = 1
        let data: NSData = NSData.init(bytes: &val1, length: 1)
        self.cbPeripheral!.writeValue(data as Data, for: self.writeCharacteristic!, type: .withoutResponse)
    }
    
    @IBAction func send2BtnTapped(_ sender: Any) {
        
        var val2: Int = 2
        let data: NSData = NSData.init(bytes: &val2, length: 1)
        self.cbPeripheral!.writeValue(data as Data, for: self.writeCharacteristic!, type: .withoutResponse)
    }
    
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .poweredOff:
        // BLE PoweredOff
            print("PoweredOff")
        case .poweredOn:
        // BLE PoweredOn
            print("PoweredOn")
        case .resetting:
        // BLE Resetting
            print("Resetting")
        case .unauthorized:
        // BLE Unauthorized
            print("Unauthorized")
        case .unknown:
        // BLE Unknown
            print("Unknown")
        case .unsupported:
        // BLE Unsupported
            print("Unsupported")
        }
    }
    
    var centralManager: CBCentralManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    func scanStart() {
        if centralManager!.isScanning == false {
            print("ppp")
            // サービスのUUIDを指定しない
//            centralManager!.scanForPeripherals(withServices: nil, options: nil)
            
            // サービスのUUIDを指定する
             let service: [CBUUID] = [CBUUID.init(string: "FEED0001-C497-4476-A7ED-727DE7648AB1")]
             centralManager!.scanForPeripherals(withServices: service, options: nil)
        }
    }
    
    var peripherals: [CBPeripheral] = []
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        peripherals.append(peripheral)
    }
    
    var cbPeripheral: CBPeripheral? = nil
    
    func connect() {
        for peripheral in peripherals {
            if peripheral.name != nil && peripheral.name == "E151BEFF-954C-C11E-67E9-E70D3438D30C" {
                cbPeripheral = peripheral
                centralManager?.stopScan()
                break;
            }
        }
        
        if cbPeripheral != nil {
            centralManager!.connect(cbPeripheral!, options: nil)
        }
    }
    
    // 接続が成功すると呼ばれるデリゲートメソッド
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        cbPeripheral?.delegate = self
        
        // 指定のサービスを探す
//        let services: [CBUUID] = [CBUUID(string: "FEED0001-C497-4476-A7ED-727DE7648AB1")]
//        cbPeripheral!.discoverServices(services)
        
        // すべてのサービスを探す
         cbPeripheral!.discoverServices(nil)
    }
    
    // 接続が失敗すると呼ばれるデリゲートメソッド
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("connection failed.")
    }
    
    var writeCharacteristic: CBCharacteristic? = nil
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characreristic in service.characteristics!{
            if characreristic.uuid.uuidString == "FEEDAA03-C497-4476-A7ED-727DE7648AB1" {
                //Notificationを受け取るハンドラ
                peripheral.setNotifyValue(true, for: characreristic)
            }
            
            if characreristic.uuid.uuidString == "FEEDAA02-C497-4476-A7ED-727DE7648AB1" {
                writeCharacteristic = characreristic
            }
        }
    }
    
    func  sendMessage(message: String) {
        let command = message + "\n"
        let data = command.data(using: String.Encoding.utf8, allowLossyConversion:true)
        cbPeripheral!.writeValue(data! , for: writeCharacteristic!, type: .withoutResponse)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("error \(error)")
            return
        }
        
        print("received Notification")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let notify: CBUUID = CBUUID(string: "ペリフェラルから値が受信できるキャラクタリスティックのUUID")
        if characteristic.uuid.uuidString == notify.uuidString {
            let message = String(bytes: characteristic.value!, encoding: String.Encoding.ascii)
            print("received \(String(describing: message))")
        }
    }
}
