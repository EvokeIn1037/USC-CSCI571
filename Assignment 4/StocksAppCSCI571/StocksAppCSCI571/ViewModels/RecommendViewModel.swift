//
//  RecommendViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import Foundation
import SwiftUI
import WebKit

class RecommendViewModel: ObservableObject {
    @Published var recommendData: [RecommendData] = []
    @Published var urlStr: String = "https://assignment-3-419113.wl.r.appspot.com/api/recommendationTrends?param="
    @Published var dataJson: String = ""
    @Published var strongBJson: String = ""
    @Published var bJson: String = ""
    @Published var strongSJson: String = ""
    @Published var sJson: String = ""
    @Published var hJson: String = ""
    @Published var html: String = ""
    @Published var loaded: Bool = false
    
    func getRcmdChart(for urlParam: String) async {
        self.urlStr = self.urlStr + urlParam
        guard let apiUrl = URL(string: self.urlStr) else {
            return
        }
        URLSession.shared.dataTask(with: apiUrl) {
            data, _, error in
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([RecommendData].self, from: data)
                    DispatchQueue.main.async {
                        self.recommendData = decodedData
                        self.setString()
                        self.html = """
                            <!DOCTYPE html>
                            <html>
                            <head>
                                <script src="https://code.highcharts.com/highcharts.js"></script>
                                <script src="https://code.highcharts.com/modules/exporting.js"></script>
                                <script src="https://code.highcharts.com/modules/export-data.js"></script>
                                <script src="https://code.highcharts.com/modules/accessibility.js"></script>
                                <style>
                                    #chart-container {
                                        width: 100%;
                                        height: auto;
                                        aspect-ratio: 1 / 0.85;
                                    }
                                </style>
                            <head>
                            <body>
                                <div id="chart-container"></div>
                                <script>
                                    Highcharts.chart('chart-container', {
                                        chart: {
                                            type: 'column'
                                        },
                                        title: {
                                            text: 'Recommendation Trends',
                                            align: 'center'
                                        },
                                        xAxis: {
                                            categories: \(self.dataJson)
                                        },
                                        yAxis: {
                                            min: 0,
                                            title: {
                                                text: '#Analysis'
                                            },
                                            stackLabels: {
                                                enabled: true
                                            },
                                            opposite: false
                                        },
                                        legend: {
                                            align: 'left',
                                            x: 70,
                                            verticalAlign: 'top',
                                            y: 70,
                                            floating: true,
                                            backgroundColor:
                                                Highcharts.defaultOptions.legend.backgroundColor || 'white',
                                            borderColor: '#CCC',
                                            borderWidth: 1,
                                            shadow: false
                                        },
                                        tooltip: {
                                            headerFormat: '<b>{point.x}</b><br/>',
                                            pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}'
                                        },
                                        plotOptions: {
                                            column: {
                                                stacking: 'normal',
                                                dataLabels: {
                                                    enabled: true
                                                }
                                            }
                                        },
                                        series: [{
                                              type: 'column',
                                              name: 'strongBuy',
                                              data: \(self.strongBJson),
                                              color: '#006400'
                                          }, {
                                              type: 'column',
                                              name: 'buy',
                                              data: \(self.bJson),
                                              color: '#008000'
                                          }, {
                                              type: 'column',
                                              name: 'hold',
                                              data: \(self.hJson),
                                              color: '#A52A2A'
                                          }, {
                                              type: 'column',
                                              name: 'sell',
                                              data: \(self.sJson),
                                              color: '#FFC0CB'
                                          }, {
                                              type: 'column',
                                              name: 'strongSell',
                                              data: \(self.strongSJson),
                                              color: '#FF0000'
                                          }],
                                        navigator: {
                                            enabled: false
                                        },
                                        rangeSelector: {
                                            enabled: false
                                        }
                                    });
                                </script>
                            </body>
                            </html>
                        """
                        self.loaded = true
                    }
                } catch {
                    print("Error decoding data: \(error)")
                }
            }
        }.resume()
    }
    
    func setString() {
        let size = self.recommendData.count
        self.dataJson = self.dataJson + "["
        self.strongBJson = self.strongBJson + "["
        self.bJson = self.bJson + "["
        self.strongSJson = self.strongSJson + "["
        self.sJson = self.sJson + "["
        self.hJson = self.hJson + "["
        if size > 0 {
            self.dataJson = self.dataJson + "'" + String(self.recommendData[0].period.prefix(7)) + "'"
            self.strongBJson = self.strongBJson + String(self.recommendData[0].strongBuy)
            self.bJson = self.bJson + String(self.recommendData[0].buy)
            self.strongSJson = self.strongSJson + String(self.recommendData[0].strongSell)
            self.sJson = self.sJson + String(self.recommendData[0].sell)
            self.hJson = self.hJson + String(self.recommendData[0].hold)
            var i = 1
            while i < size {
                self.dataJson = self.dataJson + ", '" + String(self.recommendData[i].period.prefix(7)) + "'"
                self.strongBJson = self.strongBJson + ", " + String(self.recommendData[i].strongBuy)
                self.bJson = self.bJson + ", " + String(self.recommendData[i].buy)
                self.strongSJson = self.strongSJson + ", " + String(self.recommendData[i].strongSell)
                self.sJson = self.sJson + ", " + String(self.recommendData[i].sell)
                self.hJson = self.hJson + ", " + String(self.recommendData[i].hold)
                i = i + 1
            }
        }
        self.dataJson = self.dataJson + "]"
        self.strongBJson = self.strongBJson + "]"
        self.bJson = self.bJson + "]"
        self.strongSJson = self.strongSJson + "]"
        self.sJson = self.sJson + "]"
        self.hJson = self.hJson + "]"
    }
}
