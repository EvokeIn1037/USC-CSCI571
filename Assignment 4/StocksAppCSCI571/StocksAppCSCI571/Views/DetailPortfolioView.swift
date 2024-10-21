//
//  DetailPortfolioView.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import SwiftUI

struct DetailPortfolioView: View {
    let portfolioInfo: [DPortfolioData]
    let balanceLeft: Double
    let exist: Int
    let baseInfoDP: BaseResult
    @Binding var showingSheetDP: Bool
    
//    @ObservedObject var viewModel = DPortfolioViewModel()
    
    var body: some View {
        VStack {
            Text("Portfolio")
                .font(.title)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical)
            HStack {
                VStack {
                    let indexP = exist
                    if indexP >= 0 {
                        (Text("Shares Owned: ")
                            .fontWeight(.bold)
                         + Text(portfolioInfo[indexP].Quantity))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        (Text("Avg. Cost/Share: ")
                            .fontWeight(.bold)
                         + Text("$" + portfolioInfo[indexP].Avg))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        (Text("Total Cost: ")
                            .fontWeight(.bold)
                         + Text("$" + portfolioInfo[indexP].Total))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if Float(portfolioInfo[indexP].d)! > 0 {
                            (Text("Change: ")
                                .fontWeight(.bold)
                             + Text("$" + portfolioInfo[indexP].d)
                                .foregroundColor(.green))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            (Text("Market Value: ")
                                .fontWeight(.bold)
                             + Text("$" + portfolioInfo[indexP].Mv)
                                .foregroundColor(.green))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        else {
                            (Text("Change: ")
                                .fontWeight(.bold)
                             + Text("$" + portfolioInfo[indexP].d)
                                .foregroundColor(.red))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            (Text("Market Value: ")
                                .fontWeight(.bold)
                             + Text("$" + portfolioInfo[indexP].Mv)
                                .foregroundColor(.red))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    else {
                        Text("You have 0 shares of " + baseInfoDP.ticker + ".")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Start trading!")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                Button(action: {
                    showingSheetDP = true
                }) {
                    Text("Trade")
                        .font(.headline)
                        .frame(width: 100, height: 50)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(25)
                }
                .sheet(isPresented: $showingSheetDP) {
                    if exist >= 0 {
                        TradeSheetView(blnc: balanceLeft, infoPort: portfolioInfo[exist], showingSheetDPS: $showingSheetDP)
                    }
                    else {
                        let portContent = DPortfolioData(ticker: baseInfoDP.ticker, name: baseInfoDP.name, c: baseInfoDP.c, d: baseInfoDP.d, Quantity: "0", Avg: "0.0", Total: "0.0", Mv: "0.0")
                        TradeSheetView(blnc: balanceLeft, infoPort: portContent, showingSheetDPS: $showingSheetDP)
                    }
                }
            }
        }
        .onAppear {
            Task {
//                await viewModel.getPortInfoD(for: ticker)
//                await viewModel.getBlncInfoD()
            }
        }
        .onChange(of: showingSheetDP) {
            oldValue, newValue in
            Task {
//                if !newValue {
//                    await viewModel.getPortInfoD(for: baseInfoDP.ticker)
//                    await viewModel.getBlncInfoD()
//                }
            }
        }
        .padding(.horizontal)
    }
}

struct TradeSheetView: View {
    let blnc: Double
    let infoPort: DPortfolioData
    @Binding var showingSheetDPS: Bool
    
    @ObservedObject var viewModel = DPortfolioViewModel()
    @ObservedObject var tViewModel = TradeViewModel()
    
    @State private var number: Int = 0
    @State private var numberString: String = ""
    @State private var cPrice = 0.0
    @State private var chosenP = 0.0
    @State private var notNum = false
    @State private var showBuy = false
    @State private var showSell = false
    @State private var showZeroB = false
    @State private var showZeroS = false
    @State private var doneBuy = false
    @State private var doneSell = false
    @State private var strStat = ""
    
    var body: some View {
        ZStack {
            if (doneBuy || doneSell) {
                Color.green
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Spacer()
                    
                    Text("Congratulations!")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                    Text("You have successfully " + strStat + " shares of " + infoPort.ticker)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        showingSheetDPS = false
                    }) {
                        Text("Done")
                            .font(.headline)
                            .frame(width: 300, height: 25)
                            .foregroundColor(.green)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(25)
                    }
                }
            }
            else {
                VStack {
                    Button(action: {
                        showingSheetDPS = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .padding()
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    Text("Trade " + infoPort.name + " shares")
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    HStack {
                        TextField("0", text: $numberString)
                            .onChange(of: numberString) {
                                oldValue, newValue in
                                Task {
                                    showBuy = false
                                    showSell = false
                                    showZeroB = false
                                    showZeroS = false
                                    if !viewModel.isStringOnlyNumbers(newValue) {
                                        notNum = true
                                    }
                                    else {
                                        notNum = false
                                        if !newValue.isEmpty {
                                            number = Int(newValue)!
                                        }
                                        else {
                                            number = 0
                                        }
                                        cPrice = (Double(infoPort.c)!)
                                        chosenP = cPrice * Double(number)
                                    }
                                }
                            }
                            .font(.system(size: 80))
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Shares")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    Text("x $" + infoPort.c + "/share = $" + String(format: "%.2f", chosenP))
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Spacer()
                    
                    Text("$" + String(format: "%.2f", blnc) + " available to buy " + infoPort.ticker)
                    HStack {
                        Button(action: {
                            if chosenP > blnc {
                                showBuy = true
                            }
                            else if chosenP == 0.0 {
                                showZeroB = true
                            }
                            else {
                                Task {
                                    await tViewModel.buyStockD(number: number, chosenP: chosenP, infoParam: infoPort, blnc: blnc)
                                }
                                strStat = "bought " + String(number)
                                doneBuy = true
                            }
                        }) {
                            Text("Buy")
                                .font(.headline)
                                .frame(width: 100, height: 25)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(25)
                        }
                        
                        Button(action: {
                            if number > Int(infoPort.Quantity)! {
                                showSell = true
                            }
                            else if number == 0 {
                                showZeroS = true
                            }
                            else {
                                Task {
                                    await tViewModel.sellStockD(number: number, chosenP: chosenP, infoParam: infoPort, blnc: blnc)
                                }
                                strStat = "sold " + String(number)
                                doneSell = true
                            }
                        }) {
                            Text("Sell")
                                .font(.headline)
                                .frame(width: 100, height: 25)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(25)
                        }
                    }
                }
                .padding(.horizontal)
                VStack {
                    Spacer()
                    
                    if notNum {
                        Text("Please enter a valid amount")
                            .frame(width: 250, height: 25)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(Color.white)
                            .cornerRadius(25)
                            .transition(.slide)
                            .zIndex(1)
                    }
                    
                    if showBuy {
                        Text("Not enough money to buy")
                            .frame(width: 250, height: 25)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(Color.white)
                            .cornerRadius(25)
                            .transition(.slide)
                            .zIndex(1)
                    }
                    
                    if showSell {
                        Text("Not enough shares to sell")
                            .frame(width: 250, height: 25)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(Color.white)
                            .cornerRadius(25)
                            .transition(.slide)
                            .zIndex(1)
                    }
                    
                    if showZeroB {
                        Text("Cannot buy non-positive shares")
                            .frame(width: 250, height: 25)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(Color.white)
                            .cornerRadius(25)
                            .transition(.slide)
                            .zIndex(1)
                    }
                    
                    if showZeroS {
                        Text("Cannot sell non-positive shares")
                            .frame(width: 250, height: 25)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(Color.white)
                            .cornerRadius(25)
                            .transition(.slide)
                            .zIndex(1)
                    }
                }
            }
        }
    }
}

//#Preview {
//    DetailPortfolioView()
//}
