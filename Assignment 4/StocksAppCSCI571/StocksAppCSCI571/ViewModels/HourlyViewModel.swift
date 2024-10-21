//
//  HourlyViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/29/24.
//

import Foundation
import SwiftUI
import WebKit

class HourlyViewModel: ObservableObject {
    @Published var hourlyData: HourlyData = HourlyData(ticker: "", queryCount: 0, resultsCount: 0, adjusted: false, results: [], status: "", request_id: "", count: 0)
    @Published var hourlyChartData: [HourlyChartData] = []
    @Published var dataJson: String = ""
    @Published var titleName: String = ""
    @Published var html: String = ""
    @Published var loaded: Bool = false
    
    func getHourlyChart(for urlParam: String) async {
        guard let apiUrl = URL(string: urlParam) else {
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
                    let decodedData = try JSONDecoder().decode(HourlyData.self, from: data)
                    DispatchQueue.main.async {
                        self.hourlyData = decodedData
                        self.hourlyChartData = self.hourlyData.results.map { HourlyChartData(t: $0.t, c: $0.c) }
                        self.setString()
                        self.titleName = self.hourlyData.ticker + " Hourly Price Variation"
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
                                            backgroundColor: 'white'
                                        },
                                        title: {
                                            text: '\(self.titleName)'
                                        },
                                        xAxis: {
                                            type: 'datetime',
                                            scrollbar: {
                                                enabled: false
                                            }
                                        },
                                        yAxis: {
                                            title: {
                                                text: ''
                                            },
                                            opposite: true
                                        },
                                        plotOptions: {
                                            line: {
                                                color: 'red',
                                                marker: {
                                                    enabled: false
                                                }
                                            }
                                        },
                                        series: [{
                                            type: 'line',
                                            name: '\(self.hourlyData.ticker)',
                                            data: \(self.dataJson)
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
        let size = self.hourlyChartData.count
        self.dataJson = self.dataJson + "["
        if size > 0 {
            self.dataJson = self.dataJson + "[" + String(self.hourlyChartData[0].t) + ", " + String(self.hourlyChartData[0].c) + "]"
            var i = 1
            while i < size {
                self.dataJson = self.dataJson + ", [" + String(self.hourlyChartData[i].t) + ", " + String(self.hourlyChartData[i].c) + "]"
                i = i + 1
            }
        }
        self.dataJson = self.dataJson + "]"
    }
}
