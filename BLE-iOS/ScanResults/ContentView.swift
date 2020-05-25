//
//  ContentView.swift
//  BLE-iOS
//
//  Created by James Taylor on 5/24/20.
//  Copyright © 2020 James Taylor. All rights reserved.
//

import SwiftUI
import CoreBluetooth

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct ContentView: View {
    @ObservedObject var vm: BluetoothViewModel

    var body: some View {
        ZStack(alignment: .center) {
            NavigationView {
                MasterView(vm: vm)
                    .navigationBarTitle(Text("Scan Results"))
                    .navigationBarItems(
                        leading: Button(action: {
                            self.vm.results = [BleDevice]()
                        }) {
                            if self.vm.results.count != 0 { Text("Clear") }
                        },
                        trailing: Button(action: {
                            if self.vm.showActivityIndicator { self.vm.stopScan() }
                            else { self.vm.startScan() }
                        }) {
                            if vm.showActivityIndicator { Text("Stop Scan") }
                            else { Text("Scan") }
                        }
                )
                DetailView(vm: vm)
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
            ActivityIndicator(shouldAnimate: self.$vm.showActivityIndicator)
        }
    }
}

struct MasterView: View {
    @ObservedObject var vm: BluetoothViewModel
    var body: some View {
        List {
            ForEach(vm.results, id: \.self) { result in
                NavigationLink(destination: DetailView(vm: self.vm,
                                                       selectedResult: result)) {
                                                        Text("\(result.peripheral.name ?? "No name assigned")")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: BluetoothViewModel())
    }
}


