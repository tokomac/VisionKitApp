//
//  ContentView.swift
//  VisionKitApp
//
//  Created by tokomac.
//

import SwiftUI

struct ContentView: View {
    
    enum Tabs: String {
        case tab1 = "DocumentData"
        case tab2 = "DataScanner"
        case tab3 = "LiveText"
    }

    @State private var navigationTitle: String = Tabs.tab1.rawValue
    @State private var selectedTab: Tabs = .tab1
    
    var body: some View {
        TabView() {
            TabDocumentDataView().tabItem {
                VStack {
                    Image(systemName: "doc.viewfinder")
                    Text(Tabs.tab1.rawValue)
                }
            }
            .tag(Tabs.tab1)
            TabBarcodeScannerVew().tabItem {
                VStack {
                    Image(systemName: "barcode")
                    Text(Tabs.tab2.rawValue)
                }
            }
            .tag(Tabs.tab2)
            TabDataScannerView().tabItem {
                VStack {
                    Image(systemName: "text.viewfinder")
                    Text(Tabs.tab3.rawValue)
                }
            }
            .tag(Tabs.tab3)
        }
        
//        NavigationStack {
//            TabView(selection: $selectedTab) {
//                TabAView().tabItem {
//                    VStack {
//                        Image(systemName: "bold")
//                        Text(Tabs.tab1.rawValue)
//                    }
//                }
//                .tag(Tabs.tab1)
//                TabBView().tabItem {
//                    VStack {
//                        Image(systemName: "bold")
//                        Text(Tabs.tab2.rawValue)
//                    }
//                }
//                .tag(Tabs.tab2)
//                TabCView().tabItem {
//                    VStack {
//                        Image(systemName: "bold")
//                        Text(Tabs.tab3.rawValue)
//                    }
//                }
//                .tag(Tabs.tab3)
//            }
//            .navigationTitle(navigationTitle)
//            .onChange(of: selectedTab) { tab in
//                navigationTitle = selectedTab.rawValue
//            }
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
