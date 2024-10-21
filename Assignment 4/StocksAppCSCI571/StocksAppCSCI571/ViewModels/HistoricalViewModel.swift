//
//  HistoricalViewModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/30/24.
//

import Foundation
import SwiftUI
import WebKit

class HistoricalViewModel: ObservableObject {
    @Published var historicalData: HourlyData = HourlyData(ticker: "", queryCount: 0, resultsCount: 0, adjusted: false, results: [], status: "", request_id: "", count: 0)
    @Published var historicalChartData: [HistoricalChartData] = []
    @Published var urlStr: String = "https://assignment-3-419113.wl.r.appspot.com/api/historicalData?param="
    @Published var dataJson: String = ""
    @Published var volumeJson: String = ""
    @Published var titleName: String = ""
    @Published var html: String = ""
    @Published var loaded: Bool = false
    
    func getHistoricalChart(for urlParam: String) async {
        self.urlStr = self.urlStr + urlParam
        guard let apiUrl = URL(string: urlStr) else {
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
                        self.historicalData = decodedData
                        self.historicalChartData = self.historicalData.results.map { HistoricalChartData(t: $0.t, o: $0.o, h: $0.h, l: $0.l, c: $0.c, v: $0.v) }
                        self.setString()
                        self.titleName = self.historicalData.ticker + " Historical"
                        self.html = """
                            <!DOCTYPE html>
                            <html>
                            <head>
                                <script src="https://code.highcharts.com/stock/highstock.js"></script>
                                <script src="https://code.highcharts.com/stock/modules/drag-panes.js"></script>
                                <script src="https://code.highcharts.com/stock/modules/exporting.js"></script>
                                <script src="https://code.highcharts.com/stock/indicators/indicators.js"></script>
                                <script src="https://code.highcharts.com/stock/indicators/volume-by-price.js"></script>
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
                                    const groupingUnits = [['week', [1]], ['month', [1, 2, 3, 4, 6]]];    // set the allowed units for data grouping
                                    Highcharts.stockChart('chart-container', {
                                        rangeSelector: {
                                              selected: 2
                                          },

                                          title: {
                                              text: '\(self.titleName)'
                                          },

                                          subtitle: {
                                              text: 'With SMA and Volume by Price technical indicators'
                                          },

                                          yAxis: [{
                                              startOnTick: false,
                                              endOnTick: false,
                                              labels: {
                                                  align: 'right',
                                                  x: -3
                                              },
                                              title: {
                                                  text: 'OHLC'
                                              },
                                              height: '60%',
                                              lineWidth: 2,
                                              resize: {
                                                  enabled: true
                                              }
                                          }, {
                                              labels: {
                                                  align: 'right',
                                                  x: -3
                                              },
                                              title: {
                                                  text: 'Volume'
                                              },
                                              top: '65%',
                                              height: '35%',
                                              offset: 0,
                                              lineWidth: 2
                                          }],

                                          tooltip: {
                                              split: true
                                          },

                                          plotOptions: {
                                              series: {
                                                  dataGrouping: {
                                                      units: groupingUnits
                                                  }
                                              }
                                          },

                                          series: [{
                                              type: 'candlestick',
                                              name: '\(self.historicalData.ticker)',
                                              id: '\(self.historicalData.ticker.lowercased())',
                                              zIndex: 2,
                                              data: \(self.dataJson)
                                          }, {
                                              type: 'column',
                                              name: 'Volume',
                                              id: 'volume',
                                              data: \(self.volumeJson),
                                              yAxis: 1
                                          }, {
                                              type: 'vbp',
                                              linkedTo: '\(self.historicalData.ticker.lowercased())',
                                              params: {
                                                  volumeSeriesID: 'volume'
                                              },
                                              dataLabels: {
                                                  enabled: false
                                              },
                                              zoneLines: {
                                                  enabled: false
                                              }
                                          }, {
                                              type: 'sma',
                                              linkedTo: '\(self.historicalData.ticker.lowercased())',
                                              zIndex: 1,
                                              marker: {
                                                  enabled: false
                                              }
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
        let size = self.historicalChartData.count
        self.dataJson = self.dataJson + "["
        self.volumeJson = self.volumeJson + "["
        if size > 0 {
            self.dataJson = self.dataJson + "[" + String(self.historicalChartData[0].t) + ", " + String(self.historicalChartData[0].o) + ", " + String(self.historicalChartData[0].h) + ", " + String(self.historicalChartData[0].l) + ", " + String(self.historicalChartData[0].c) + "]"
            self.volumeJson = self.volumeJson + "[" + String(self.historicalChartData[0].t) + ", " + String(self.historicalChartData[0].v) + "]"
            var i = 1
            while i < size {
                self.dataJson = self.dataJson + ", [" + String(self.historicalChartData[i].t) + ", " + String(self.historicalChartData[i].o) + ", " + String(self.historicalChartData[i].h) + ", " + String(self.historicalChartData[i].l) + ", " + String(self.historicalChartData[i].c) + "]"
                self.volumeJson = self.volumeJson + ", [" + String(self.historicalChartData[i].t) + ", " + String(self.historicalChartData[i].v) + "]"
                i = i + 1
            }
        }
        self.dataJson = self.dataJson + "]"
        self.volumeJson = self.volumeJson + "]"
    }
}
