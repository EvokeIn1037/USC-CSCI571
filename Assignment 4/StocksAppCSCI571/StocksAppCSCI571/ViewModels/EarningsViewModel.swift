//
//  EarningsViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 5/1/24.
//

import Foundation
import SwiftUI
import WebKit

class EarningsViewModel: ObservableObject {
    @Published var earningsData: [EarningsData] = []
    @Published var urlStr: String = "https://assignment-3-419113.wl.r.appspot.com/api/earnings?param="
    @Published var dataJson: String = ""
    @Published var aJson: String = ""
    @Published var eJson: String = ""
    @Published var html: String = ""
    @Published var loaded: Bool = false
    
    func getErnsChart(for urlParam: String) async {
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
                    let decodedData = try JSONDecoder().decode([EarningsData].self, from: data)
                    DispatchQueue.main.async {
                        self.earningsData = decodedData
                        self.setString()
                        self.html = """
                            <!DOCTYPE html>
                            <html>
                            <head>
                                <script src="https://code.highcharts.com/highcharts.js"></script>
                                <script src="https://code.highcharts.com/modules/series-label.js"></script>
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
                                            type: 'spline'
                                        },
                                        title: {
                                            text: 'Historical EPS Surprises'
                                        },
                                        xAxis: {
                                            categories: \(self.dataJson),
                                            accessibility: {
                                                description: 'Date'
                                            }
                                        },
                                        yAxis: {
                                            title: {
                                                text: 'Quaterly EPS'
                                            },
                                            labels: {
                                                format: '{value}'
                                            }
                                        },
                                        tooltip: {
                                            crosshairs: true,
                                            shared: true
                                        },
                                        plotOptions: {
                                            spline: {
                                                marker: {
                                                    radius: 4,
                                                    lineColor: '#666666',
                                                    lineWidth: 1
                                                }
                                            }
                                        },
                                        series: [{
                                            name: 'Actual',
                                            data: \(self.aJson)

                                        }, {
                                            name: 'Estimate',
                                            marker: {
                                                symbol: 'diamond'
                                            },
                                            data: \(self.eJson)
                                        }]
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
        let size = self.earningsData.count
        self.dataJson = self.dataJson + "["
        self.aJson = self.aJson + "["
        self.eJson = self.eJson + "["
        if size > 0 {
            self.dataJson = self.dataJson + "'" + self.earningsData[0].period + "<br/>Surprise: " + String(self.earningsData[0].surprise) + "'"
            self.aJson = self.aJson + String(self.earningsData[0].actual)
            self.eJson = self.eJson + String(self.earningsData[0].estimate)
            var i = 1
            while i < size {
                self.dataJson = self.dataJson + ", '" + self.earningsData[i].period + "<br/>Surprise: " + String(self.earningsData[i].surprise) + "'"
                self.aJson = self.aJson + ", " + String(self.earningsData[i].actual)
                self.eJson = self.eJson + ", " + String(self.earningsData[i].estimate)
                i = i + 1
            }
        }
        self.dataJson = self.dataJson + "]"
        self.aJson = self.aJson + "]"
        self.eJson = self.eJson + "]"
    }
}
