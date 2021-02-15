//
//  ScanViewModel.swift
//  BLE-iOS
//
//  Created by James Taylor on 5/24/20.
//  Copyright © 2020 James Taylor. All rights reserved.
//
//  Developed using documentation available at
//  https://developer.apple.com/library/archive/documentation/NetworkingInternetWeb/Conceptual/CoreBluetooth_concepts/AboutCoreBluetooth/Introduction.html#//apple_ref/doc/uid/TP40013257
//  This app acts a central to scanned peripherals. A peripheral typically has data that is needed by other devices.
//  A central typically uses the information served up by a peripheral to accomplish some task.
//  By default, your app is unable to perform Bluetooth Low Energy tasks while it is in the background or in a suspended state.
//  You can declare background support for one or both of the Core Bluetooth background execution modes (there’s one for the central role, and one for the peripheral role).
//  Even apps that support background processing may be terminated by the system at any time to free up memory for the current foreground app.

import Foundation
import CoreBluetooth

struct BleDevice: Equatable, Hashable {
    let peripheral: CBPeripheral; let advertisementData: [String : Any]; let rssi: Double
    static func == (lhs: BleDevice, rhs: BleDevice) -> Bool {return lhs.peripheral == rhs.peripheral}
    func hash(into hasher: inout Hasher) {hasher.combine(peripheral)}
}

class BluetoothViewModel: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate  {
    @Published var results = [BleDevice]()
    @Published var showActivityIndicator = false
    @Published var isConnected = false

    private var centralManager: CBCentralManager? = nil
    override init() {
        super.init()
        centralManager = CBCentralManager.init(delegate: self, queue: nil)//specifying the dispatch queue as nil, the central manager dispatches central role events using the main queue
    }

    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .resetting: print("BLE resetting")
            case .unsupported: print("BLE unsupported")
            case .unauthorized: print("BLE unauthorized")//TODO: Message user to authorize bluetooth
            case .poweredOff: print("BLE turned off")//TODO: Message user to turn on bluetooth
            case .poweredOn: print("BLE turned on")
            case .unknown: print("BLE unknown state")
            @unknown default: print("BLE unknown state \(central.state)")
        }
        print(central.state)
    }

    //MARK: - Scanning
    func startScan(){
        centralManager?.scanForPeripherals(withServices: nil, options: nil)//specifying nil for the first parameter, the central manager returns all discovered peripherals, regardless of their supported services
        showActivityIndicator = centralManager?.isScanning ?? false
    }

    func stopScan(){
        centralManager?.stopScan()
        showActivityIndicator = centralManager?.isScanning ?? false
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = BleDevice(peripheral: peripheral, advertisementData: advertisementData, rssi: RSSI.doubleValue)
        if results.contains(device) { return }
        results.append(device)
    }

    //MARK: - Connecting
    func connectTo(peripheral: CBPeripheral) {
        centralManager?.connect(peripheral, options: nil)
        showActivityIndicator = true
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral){
        self.isConnected = true
        self.showActivityIndicator = false
    }

    func disconnectFrom(peripheral: CBPeripheral) {
        centralManager?.cancelPeripheralConnection(peripheral)
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        self.isConnected = false
        self.showActivityIndicator = false
    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        self.isConnected = false
        self.showActivityIndicator = false
    }
}
