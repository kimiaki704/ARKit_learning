//
//  BLESerialViewController2.swift
//  ARKit_learning
//
//  Created by 鈴木公章 on 2020/01/10.
//  Copyright © 2020 鈴木公章. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLESerialViewController2: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var myPeripheral: CBPeripheral!
    let serviceUUID: [CBUUID] = [CBUUID(string: "FEED0001-C497-4476-A7ED-727DE7648AB1")]
    let characteristicsUUID: [CBUUID] = [CBUUID(string: "FEED0002-C497-4476-A7ED-727DE7648AB1")]
    let descriptorUUID: [CBUUID] = [CBUUID(string: "FEED0003-C497-4476-A7ED-727DE7648AB1")]
    
    // MARK: - IBOutlet
    @IBOutlet weak var SSIDUILabel: UILabel!
    
    // MARK: - IBAction
//    @IBAction func connectBtnTapped(_ sender: Any) {
//        if !self.centralManagerReady {
//            return
//        }
//
//        self.scanBLESerial3()
//    }
//
//    @IBAction func send1BtnTapped(_ sender: Any) {
//        if !peripheralReady {
//            return
//        }
//
//        var val1: Int = 1
//        let data: NSData = NSData.init(bytes: &val1, length: 1)
//        self.peripheral.writeValue(data as Data, for: self.characteristic, type: .withoutResponse)
//    }
//
//    @IBAction func send2BtnTapped(_ sender: Any) {
//        if !peripheralReady {
//            return
//        }
//
//        var val2: Int = 2
//        let data: NSData = NSData.init(bytes: &val2, length: 1)
//        self.peripheral.writeValue(data as Data, for: self.characteristic, type: .withoutResponse)
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // centralManager の初期化
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .unknown:
            print(".unknown")
            break
        case .resetting:
            print(".resetting")
            break
        case .unsupported:
            print(".unsupported")
            break
        case .unauthorized:
            print(".unauthorized")
            break
        case .poweredOff:
            print(".poweredOff")
            break
        case .poweredOn:
            print(".poweredOnnn")
            // Service UUID を指定してデバイスをスキャン
            self.centralManager.scanForPeripherals(withServices: serviceUUID, options: nil)
            break
        }
    }
    
    // デバイスを検出したら呼ばれる
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.myPeripheral = peripheral
        print("device name: \(myPeripheral!.name!)")
        self.centralManager.connect(self.myPeripheral, options: nil)
    }
    
    // デバイスへの接続が成功すると呼ばれる
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!")
        myPeripheral!.delegate = self
        //指定されたサービスを探す
        myPeripheral!.discoverServices(serviceUUID)
    }
    
    // デバイスへの接続が失敗すると呼ばれる
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Connect failed...")
    }
    
    // サービスの検索が成功したら呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discover Services")
        let service: CBService = myPeripheral!.services![0]
        myPeripheral!.discoverCharacteristics(characteristicsUUID, for: service)
    }
    
    // Characteristics を発見したら呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Find Characteristics")
        for i in service.characteristics!{
            if i.uuid == characteristicsUUID[0] {
                self.myPeripheral.setNotifyValue(true, for: i)
            }
        }
    }
    
    // Characteristic の値が更新されたら呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        let data: Data = characteristic.value!
        let hexStr = data.map { String(format: "%02hhx ", $0) }.joined()
        print(hexStr)
    }
}
