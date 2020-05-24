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
//  By default, your app is unable to perform Bluetooth low energy tasks while it is in the background or in a suspended state.
//  You can declare background support for one or both of the Core Bluetooth background execution modes (there’s one for the central role, and one for the peripheral role).
//  Even apps that support background processing may be terminated by the system at any time to free up memory for the current foreground app.

import Foundation
import CoreBluetooth

class ScanViewModel: NSObject, ObservableObject, CBCentralManagerDelegate  {
    @Published var results = [CBPeripheral]()
    private var centralManager: CBCentralManager? = nil
    override init() {
        super.init()
        centralManager = CBCentralManager.init(delegate: self, queue: nil)//specifying the dispatch queue as nil, the central manager dispatches central role events using the main queue


    }

    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {

    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if results.contains(peripheral) { return }
        results.append(peripheral)
    }

    func startScan(){
        centralManager?.scanForPeripherals(withServices: nil, options: nil)//specifying nil for the first parameter, the central manager returns all discovered peripherals, regardless of their supported services
    }

    func stopScan(){
        centralManager?.stopScan()
    }

    func connectTo(peripheral: CBPeripheral) {
        centralManager?.connect(peripheral, options: nil)
    }

}
