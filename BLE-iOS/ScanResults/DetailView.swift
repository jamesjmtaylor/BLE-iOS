//
//  DetailView.swift
//  BLE-iOS
//
//  Created by James Taylor on 5/24/20.
//  Copyright © 2020 James Taylor. All rights reserved.
//

import SwiftUI
import CoreBluetooth

struct DetailView: View {
    @ObservedObject var vm: BluetoothViewModel
    var selectedResult: BleDevice?

    var body: some View {
        let keys = selectedResult?.advertisementData.map{$0.key.description} ?? [String]()
        let values = selectedResult?.advertisementData.map {($0.value as AnyObject).description} ?? [String]()
        return Group {
            VStack(alignment: .leading, spacing: 16.0) {
                Text("RSSI: \(selectedResult?.rssi ?? 0.0)")
                ForEach(keys.indices) { index in
                    Text("\(keys[index]): \(values[index] ?? "No value")")
                }
                Spacer()
            }
            .alignmentGuide(.leading, computeValue: {d in d[.leading] - 16})
            .frame(maxWidth: .infinity, alignment: .leading)

        }.navigationBarTitle("\(selectedResult?.peripheral.name  ?? "No name assigned")").onAppear { self.vm.stopScan()
        }.navigationBarItems(
            trailing: Button(action: {
                guard let peripheral = self.selectedResult?.peripheral else { return }
                if self.vm.isConnected { self.vm.disconnectFrom(peripheral: peripheral) }
                else { self.vm.connectTo(peripheral: peripheral) }
            }) {
                if vm.isConnected { Text("Disconnect") }
                else { Text("Connect") }
            }
        )
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(vm: BluetoothViewModel())
    }
}
