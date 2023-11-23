//
//  ContentView.swift
//  Smart Home
//
//  Created by Coder on 21/11/2023.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    let api = NiceHashAPI()
    let space = SpacePoolAPI()
    var spaceFarmDetails: [String: Any]?
    var nicehashOnlineDevicesNumber: Int = 99
    @State var isSpacePoolOnline: Bool
    @State var isNoSSDPoolOnline: Bool = false
    @State var nicehashAPIKey: String
    @State var nicehashAPIORG: String
    @State var nicehashAPISecret: String
    let defaults = UserDefaults.standard
    
    init() {
        self.nicehashOnlineDevicesNumber = api.getTotalDevices()
        self.spaceFarmDetails = space.getFarmData()
        
        if spaceFarmDetails!["estimatedPlots"] as! Int > 800 {
            self.isSpacePoolOnline = true
        }
        else {
            self.isSpacePoolOnline = false
        }
        if defaults.string(forKey: "nicehashAPIKey") != nil {
            self.nicehashAPIKey = defaults.string(forKey: "nicehashAPIKey")!
        }
        else {
            self.nicehashAPIKey = ""
        }
        if defaults.string(forKey: "nicehashAPISecret") != nil {
            self.nicehashAPISecret = defaults.string(forKey: "nicehashAPISecret")!
        }
        else {
            self.nicehashAPISecret = ""
        }
        if defaults.string(forKey: "nicehashAPIORG") != nil {
            self.nicehashAPIORG = defaults.string(forKey: "nicehashAPIORG")!
        }
        else {
            self.nicehashAPIORG = ""
        }
    }

    var body: some View {
        TabView {
            ScrollView {
                VStack {
                    HStack {
                        ZStack {
                            // The outside curved rectangle - top left
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.gray)
                                .frame(width: 150, height: 150)
                                .padding()
                            VStack {
                                HStack {
                                    // The top left circle
                                    RoundedRectangle(cornerRadius: 25)
                                        .background(Image("nicehash_logo")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(25)
                                        )
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.clear)
                                }
                                HStack {
                                    // The bottom left circle
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 25)
                                            .foregroundColor(.clear)
                                            .frame(width: 50, height: 50)
                                        Circle()
                                            .stroke(nicehashOnlineDevicesNumber > 0 ? .green: .red, lineWidth: 8)
                                            .frame(width: 42, height: 42)
                                        Text(String(nicehashOnlineDevicesNumber))
                                            .font(.title)
                                            .bold()
                                    }
                                }
                            }
                        }
                        Spacer()
                        ZStack {
                            // The outside curved rectangle - top left
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.gray)
                                .frame(width: 150, height: 150)
                                .padding()
                            VStack {
                                HStack {
                                    // The top left circle
                                    RoundedRectangle(cornerRadius: 25)
                                        .background(Image("space_pool_logo")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(25)
                                        )
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.clear)
                                    RoundedRectangle(cornerRadius: 25)
                                        .background(Image("nossd_pool_logo")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(25)
                                        )
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.clear)
                                }
                                HStack {
                                    // TODO: It should display how many devices are active
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 25)
                                            .foregroundColor(.clear)
                                            .frame(width: 50, height: 50)
                                        Circle()
                                            .fill(isSpacePoolOnline ? .green: .red)
                                            .frame(width: 50, height: 50)
                                        
                                    // TODO: It should display how many devices are active
                                    }
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 25)
                                            .foregroundColor(.clear)
                                            .frame(width: 50, height: 50)
                                        Circle()
                                            .fill(isNoSSDPoolOnline ? .green: .red)
                                            .frame(width: 50, height: 50)
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                    Spacer()
                }
                .padding()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            Text("Cryto Stuff Goes Here Soon")
                .tabItem {
                    Label("Crypto", systemImage: "bitcoinsign.circle")
                }
            Text("EV Stuff Goes Here Soon")
                .tabItem {
                    Label("EV", systemImage: "bolt.car")
                }
            ScrollView{
                VStack {
                    Text("Settings")
                    Form {
                        SecureField(text: $nicehashAPIKey, prompt: Text("NiceHash API Key")) {
                        }
                        SecureField(text: $nicehashAPISecret, prompt: Text("NiceHash API Secret")) {
                        }
                        SecureField(text: $nicehashAPIORG, prompt:
                            Text("NiceHash ORG ID")) {
                        }
                        Button {
                            if nicehashAPIKey != ""{
                                defaults.set(nicehashAPIKey, forKey: "nicehashAPIKey")
                            }
                            if nicehashAPISecret != ""{
                                defaults.set(nicehashAPISecret, forKey: "nicehashAPISecret")
                            }
                            if nicehashAPIORG != ""{
                                defaults.set(nicehashAPIORG, forKey: "nicehashAPIORG")
                            }
                        } label: {
                            Text("Submit")
                        }

                    }.frame(height: 200)
                }
            }
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
