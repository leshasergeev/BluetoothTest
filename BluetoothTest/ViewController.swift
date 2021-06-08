//
//  ViewController.swift
//  BluetoothTest
//
//  Created by Алексей Сергеев on 03.06.2021.
//  Copyright © 2021 Алексей Сергеев. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController {
    
    //MARK:- JDY-23 Information
    private let jdy23UUID = "FDA50693" + "A4E24FB" + "1AFCFC" + "6EB076" + "47123"
    
    private let jdy23Service = CBUUID(string: "0xFFE0")
    
    class JDY23Charct {
        static let shared = JDY23Charct()
        let uart       = CBUUID(string: "0xFFE1")
        let ioControl  = CBUUID(string: "0xFFE2")
    }

    //MARK:- Bluetooth properties
    var cbCentralManager: CBCentralManager?
    var peripheral: CBPeripheral?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cbCentralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState() {
        
    }
    
    
}


//MARK:- ManagerDelegate
extension ViewController: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
            print("Scanning...")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard peripheral.name != nil else { return }
        
        if peripheral.identifier.uuidString == jdy23UUID {
            print("\(peripheral.name ?? "HAS NOT") Has Been Found!")
            
            // stop scan
            cbCentralManager?.stopScan()
            
            // connect
            cbCentralManager?.connect(peripheral, options: nil)
            self.peripheral = peripheral
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices([jdy23Service])
        peripheral.delegate = self
    }
}

//MARK:- PeripheralDelegate
extension ViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            // discover characteristics of server
            for service in services {
                peripheral.discoverCharacteristics([JDY23Charct.shared.uart, JDY23Charct.shared.uart], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for char in characteristics {
                if char.uuid == JDY23Charct.shared.ioControl {
                    
                }
            }
        }
    }
}









