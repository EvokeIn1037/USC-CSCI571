//
//  AppModel.swift
//  StocksAppCSCI571
//
//  Created by Yifan Li on 4/28/24.
//

import Foundation

struct SearchResult: Codable, Hashable {
    let description: String
    let symbol: String
}

struct BaseResult: Codable, Hashable {
    let ticker: String
    let name: String
    let exchange: String
    let logo: String
    let c: String
    let d: String
    let dp: String
    let t: Int
    let timestampForm: String
    let op: Int
}

struct HourlyResult: Codable, Hashable {
    let v: Int
    let vw: Float
    let o: Float
    let c: Float
    let h: Float
    let l: Float
    let t: Int
    let n: Int
}

struct HourlyChartData: Codable, Hashable {
    let t: Int
    let c: Float
}

struct HistoricalChartData: Codable, Hashable {
    let t: Int
    let o: Float
    let h: Float
    let l: Float
    let c: Float
    let v: Int
}

struct HourlyData: Codable, Hashable {
    let ticker: String
    let queryCount: Int
    let resultsCount: Int
    let adjusted: Bool
    let results: [HourlyResult]
    let status: String
    let request_id: String
    let count: Int
}

struct SummaryData: Codable, Hashable {
    let h: Float
    let l: Float
    let o: Float
    let pc: Float
    let ipo: String
    let finnhubIndustry: String
    let weburl: String
    let peers: [String]
}

struct InsightsData: Codable, Hashable {
    let name: String
    let totalMSPR: Float
    let totalChange: Int
    let positiveMSPR: Float
    let positiveChange: Int
    let negativeMSPR: Float
    let negativeChange: Int
}

struct RecommendData: Codable, Hashable {
    let buy: Int
    let hold: Int
    let period: String
    let sell: Int
    let strongBuy: Int
    let strongSell: Int
    let symbol: String
}

struct EarningsData: Codable, Hashable {
    let actual: Float
    let estimate: Float
    let period: String
    let quarter: Int
    let surprise: Float
    let surprisePercent: Float
    let symbol: String
    let year: Int
}

struct NewsData: Codable, Hashable {
    let image: String
    let source: String
    let datetime: String
    let headline: String
    let summary: String
    let url: String
    let differNow: String
}

struct DPortfolioData: Codable, Hashable {
    let ticker: String
    let name: String
    let c: String
    let d: String
    let Quantity: String
    let Avg: String
    let Total: String
    let Mv: String
}

struct DWatchlistData: Codable, Hashable {
    let ticker: String
    let name: String
    let c: String
    let d: String
    let dp: String
}
