//
//  ContentView.swift
//  Smart Home
//
//  Created by Coder on 21/11/2023.
//

import SwiftUI

struct ContentView: View {
    let api = NiceHashAPI()
    @State private var counter = 0
    @State var nicehashOnlineDevicesNumber: Int = 0
    @State var isSpacePoolOnline: Bool = true
    @State var isNoSSDPoolOnline: Bool = false
    
    init() {
        api.getData()
    }

    var body: some View {
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
                            // TODO: It should display how many devices are active
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
                                    .onAppear(perform: {
                                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { time in
                                            nicehashOnlineDevicesNumber = api.getTotalDevices()
                                        }
                                    })
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
}

#Preview {
    ContentView()
}
