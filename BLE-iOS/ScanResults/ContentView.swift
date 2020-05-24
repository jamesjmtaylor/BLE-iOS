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
    @ObservedObject var vm: ScanViewModel
    @State private var isScanning = false

    var body: some View {
        ZStack(alignment: .center) {
            NavigationView {
                MasterView(results: $vm.results)
                    .navigationBarTitle(Text("Scan Results"))
                    .navigationBarItems(
                        leading: Button(action: {
                            self.vm.results = [CBPeripheral]()
                        }) {
                            if self.vm.results.count != 0 { Text("Clear") }
                        },
                        trailing: Button(action: {
                            if self.isScanning { self.vm.stopScan() }
                            else { self.vm.startScan() }
                            self.isScanning = !self.isScanning
                        }) {
                            if isScanning { Text("Stop Scan") }
                            else { Text("Scan") }
                        }
                )
                DetailView()
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
            ActivityIndicator(shouldAnimate: self.$isScanning)
        }
    }
}

struct MasterView: View {
    @Binding var results: [CBPeripheral]

    var body: some View {
        List {
            ForEach(results, id: \.self) { result in
                NavigationLink(
                    destination: DetailView(selectedResult: result)
                ) {
                    Text("\(result.name ?? "No name assigned")")
                }
            }
        }
    }
}

struct DetailView: View {
    var selectedResult: CBPeripheral?

    var body: some View {
        Group {
            if selectedResult != nil {
                Text("\(selectedResult?.name  ?? "No name assigned")")
            } else {
                Text("Detail view content goes here")
            }
        }.navigationBarTitle(Text("Detail"))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(vm: ScanViewModel())
    }
}


