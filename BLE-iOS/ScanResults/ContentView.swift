//
//  ContentView.swift
//  BLE-iOS
//
//  Created by James Taylor on 5/24/20.
//  Copyright © 2020 James Taylor. All rights reserved.
//

import SwiftUI

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .medium
    return dateFormatter
}()

struct ContentView: View {
    @ObservedObject var vm: ScanViewModel
    @State private var dates = [Date]()
    @State private var shouldAnimate = false

    var body: some View {
        VStack{
            ActivityIndicator(shouldAnimate: self.$shouldAnimate)
            NavigationView {

                MasterView(dates: $dates)
                    .navigationBarTitle(Text("Scan Results"))
                    .navigationBarItems(
                        trailing: Button(action: {
                            self.vm.startScan()
                            self.shouldAnimate = true
                        }) {
                            Text("Scan")
                        }
                )
                DetailView()
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
}

struct MasterView: View {
    @Binding var dates: [Date]

    var body: some View {
        List {
            ForEach(dates, id: \.self) { date in
                NavigationLink(
                    destination: DetailView(selectedDate: date)
                ) {
                    Text("\(date, formatter: dateFormatter)")
                }
            }.onDelete { indices in
                indices.forEach { self.dates.remove(at: $0) }
            }
        }
    }
}

struct DetailView: View {
    var selectedDate: Date?

    var body: some View {
        Group {
            if selectedDate != nil {
                Text("\(selectedDate!, formatter: dateFormatter)")
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


