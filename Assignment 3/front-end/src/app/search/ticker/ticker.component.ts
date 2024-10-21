import { Component, OnInit, ViewChild } from '@angular/core';
import { ApiService } from 'src/app/services/api.service';
import { FormControl } from '@angular/forms';
import { finalize } from 'rxjs/operators';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router, ActivatedRoute } from '@angular/router';
import { MatAutocompleteSelectedEvent } from '@angular/material/autocomplete';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA, MatDialogConfig } from '@angular/material/dialog';
import { MatTabChangeEvent } from '@angular/material/tabs';
import * as Highcharts from 'highcharts';
import * as Highchartsstock from 'highcharts/highstock';
import IndicatorsCore from 'highcharts/indicators/indicators';
import VBP from 'highcharts/indicators/volume-by-price';
import HC_indicators from 'highcharts/indicators/indicators';
import HC_vbp from 'highcharts/indicators/volume-by-price';

IndicatorsCore(Highchartsstock);
VBP(Highchartsstock);
HC_indicators(Highchartsstock);
HC_vbp(Highchartsstock);

import { Link } from 'src/app/peers-link';
import { ResultJson } from 'src/app/stock-array';
import { ModalWindowComponent } from 'src/app/modal-window/modal-window.component';

@Component({
  selector: 'app-ticker',
  templateUrl: './ticker.component.html',
  styleUrls: ['./ticker.component.css']
})

export class TickerComponent implements OnInit {

  responseData: any;                                    // Receiver for error block
  @ViewChild('tickerInput') tickerInput: any;           // Get input text
  inputControl = new FormControl();                     // Get input text for auto-complete
  options: any[] = [];                                  // Auto-complete options
  loadingIcon = false;                                  // Auto-complete loading icon
  isHidden = true;                                      // Error block hidden
  loadingTicker = true;                                 // Loading page content
  isAddToList = true;
  inWatchlist = false;
  outWatchlist = true;

  Highchartsstock: typeof Highchartsstock = Highchartsstock;
  
  constructor(private apiService: ApiService, private route: ActivatedRoute, private http: HttpClient, private router: Router, public dialog: MatDialog) { }

  transformData(data: any): [number, number][] {
    // Check if data and data.results are defined
    if (data && data.results)
    {
      return data.results.map((item: ResultJson) => [item.t, item.c]);
    }
    else
    {
      // Return an empty array or handle the case when data.results is undefined
      return [];
    }
  }
  constructHourlyChart(jsonData: any): void {
    const jsonValue = JSON.parse(jsonData);
    const titleName = jsonValue.ticker + " Hourly Price Variation";
    const data = this.transformData(jsonValue);
    const options:Highcharts.Options = {
      chart: {
        backgroundColor: 'lightgray' // Set background color to light gray
      },
      title: {
        text: titleName
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
          color: 'green',
          marker: {
            enabled: false
          }
        }
      },
      series: [{
        type: 'line',
        name: jsonValue.ticker,
        data: data
      }],
      navigator: {
        enabled: false
      },
      rangeSelector: {
        enabled: false
      }
    };

    // Create the Highcharts chart
    Highcharts.chart('hourlyChart', options);
  }

  // InnerHtmlText
  descriptionTicker: string = '';
  descriptionName: string = '';
  descriptionExchange: string = '';
  logoUrl: string = '';
  lastPriceInfo: string = '';
  marketState: string = '';
  marketOpen: number = 0;
  marketCloseDate: string = '';
  currentPrice: number = 0;
  dPrice: number = 0;
  dPercent: number = 0;
  // Page construct function
  constructBase(jsonData: any): void {
    const jsonValue = JSON.parse(jsonData);
    this.descriptionTicker = jsonValue.ticker;
    const hourlyUrlTmp = 'http://localhost:3000/api/hourly?param=' + jsonValue.ticker;
    this.descriptionName = jsonValue.name;
    this.descriptionExchange =  jsonValue.exchange;
    this.logoUrl = jsonValue.logo;
    this.currentPrice = jsonValue.c;
    this.dPrice = jsonValue.d;
    this.dPercent = jsonValue.dp;
    if (jsonValue.d >= 0)
    {
      this.lastPriceInfo = '<h1 class="text-success mb-0">' + jsonValue.c + '</h1>';
      this.lastPriceInfo += '<div class="d-flex justify-content-center align-items-center"><i class="bi bi-caret-up-fill text-success"></i>';
      this.lastPriceInfo += '<h2 class="text-success mb-0">' + jsonValue.d + '(' + jsonValue.dp + '%)' + '</h2></div>';
      this.lastPriceInfo += '<p class="mb-0">' + jsonValue.timestampForm + '</p>';
    }
    else
    {
      this.lastPriceInfo = '<h1 class="text-danger mb-0">' + jsonValue.c + '</h1>';
      this.lastPriceInfo += '<div class="d-flex justify-content-center align-items-center"><i class="bi bi-caret-down-fill text-danger"></i>';
      this.lastPriceInfo += '<h2 class="text-danger mb-0">' + jsonValue.d + '(' + jsonValue.dp + '%)' + '</h2></div>';
      this.lastPriceInfo += '<p class="mb-0">' + jsonValue.timestampForm + '</p>';
    }
    if (jsonValue.op === 1)
    {
      this.marketState = '<p class="mt-3 text-success font-weight-bold">Market is Open</p>';
      this.marketOpen = 1;
      var hourlyUrl1 = hourlyUrlTmp;
    }
    else
    {
      this.marketState = '<p class="mt-3 text-danger font-weight-bold">Market Closed on ' + jsonValue.timestampForm + '</p>';
      this.marketOpen = 0;
      const closeDate = new Date(jsonValue.timestampForm);
      const year = closeDate.getFullYear();
      const month = ('0' + (closeDate.getMonth() + 1)).slice(-2);
      const day = ('0' + closeDate.getDate()).slice(-2);
      this.marketCloseDate = `${year}-${month}-${day}`;
      var hourlyUrl1 = hourlyUrlTmp + "&op=0&closeDate=" + this.marketCloseDate;
    }
    const hourlyUrl = hourlyUrl1;
    this.http.get<any[]>(hourlyUrl).subscribe(
      value => {
        this.constructHourlyChart(JSON.stringify(value));
      }
    );
  }

  highPrice: string = '';
  lowPrice: string = '';
  openPrice: string = '';
  prevClose: string = '';
  ipoDate: string = '';
  industryInfo: string = '';
  webLink: string = '';
  webLinkText: string = '';
  peersJson: any[] = [];
  routeLinks: { label: string, route: string }[] = [];
  peersLink() {
    let i = 0;
    let len = this.peersJson.length;
    let links: Link[] = [];
    let routeValue = '', ticker = '';
    for (; i < len; i++)
    {
      ticker = this.peersJson[i];
      routeValue = '/search/' + ticker;
      links.push({ label: ticker, route: routeValue });
    }
    this.routeLinks = links;
  }
  constructSummary(jsonData: any): void {
    const jsonValue = JSON.parse(jsonData);

    this.peersJson = jsonValue.peers;

    this.highPrice = jsonValue.h;
    this.lowPrice = jsonValue.l;
    this.openPrice = jsonValue.o;
    this.prevClose = jsonValue.pc;
    this.ipoDate = jsonValue.ipo;
    this.industryInfo = jsonValue.finnhubIndustry;
    this.webLink = jsonValue.weburl;
    this.webLinkText = jsonValue.weburl;
    this.peersLink();
  }

  newsData: any[] = [];
  newsData1: any[] = [];
  newsData2: any[] = [];
  constructNews(jsonData: any): void {
    this.newsData = JSON.parse(jsonData);
    const midpoint = Math.ceil(this.newsData.length / 2);
    this.newsData1 = this.newsData.slice(0, midpoint);
    this.newsData2 = this.newsData.slice(midpoint);
  }
  openModal(news: any): void {
    this.dialog.open(ModalWindowComponent, {
      data: news,
      width: '33%',
      position: {
        top: '0'
      },
      panelClass: 'modal-window-mobile'
    });
  }

  chartOptions: Highchartsstock.Options = {};
  chartContent: Highchartsstock.Chart | undefined;
  constructStockCharts(jsonData: any): void {
    const jsonValue = JSON.parse(jsonData);
    const titleName = jsonValue.ticker + ' Historical';
    var dataArray: any[] = [];
    jsonValue.results.forEach((result: ResultJson) => {
      const dataPoint = [
        result.t,
        result.o,
        result.h,
        result.l,
        result.c,
        result.v
      ];
      dataArray.push(dataPoint);
    });
    const data = dataArray;
    // split the data set into ohlc and volume
    const ohlc = [],
        volume = [],
        dataLength = data.length,
        // set the allowed units for data grouping
        groupingUnits: [string, number[] | null][] = [[
            'week',                         // unit name
            [1]                             // allowed multiples
        ], [
            'month',
            [1, 2, 3, 4, 6]
        ]];

    for (let i = 0; i < dataLength; i += 1) {
        ohlc.push([
            data[i][0], // the date
            data[i][1], // open
            data[i][2], // high
            data[i][3], // low
            data[i][4] // close
        ]);

        volume.push([
            data[i][0], // the date
            data[i][5] // the volume
        ]);
    }

    const options:Highchartsstock.Options = {
      rangeSelector: {
          selected: 2
      },

      title: {
          text: titleName
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
          name: jsonValue.ticker,
          id: jsonValue.ticker.toLowerCase(),
          zIndex: 2,
          data: ohlc
      }, {
          type: 'column',
          name: 'Volume',
          id: 'volume',
          data: volume,
          yAxis: 1
      }, {
          type: 'vbp',
          linkedTo: jsonValue.ticker.toLowerCase(),
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
          linkedTo: jsonValue.ticker.toLowerCase(),
          zIndex: 1,
          marker: {
              enabled: false
          }
      }]
    };
    this.chartOptions = options;
  }

  tableNameText:string = '';
  totalMSPR:string = '';
  totalChange:string = '';
  positiveMSPR:string = '';
  positiveChange:string = '';
  negativeMSPR:string = '';
  negativeChange:string = '';
  constructTable(jsonData: any): void {
    const jsonValue = JSON.parse(jsonData);
    this.tableNameText = jsonValue.name;
    this.totalMSPR = jsonValue.totalMSPR;
    this.totalChange = jsonValue.totalChange;
    this.positiveMSPR = jsonValue.positiveMSPR;
    this.positiveChange = jsonValue.positiveChange;
    this.negativeMSPR = jsonValue.negativeMSPR;
    this.negativeChange = jsonValue.negativeChange;
  }

  trendOptions: Highcharts.Options = {};
  trendContent: Highcharts.Chart | undefined;
  constructRecommendationTrends(jsonData: any): void {
    const jsonValue = JSON.parse(jsonData);
    const xCategoriesStr: string[] = jsonValue.map((item: { period: any; }) => item.period.substr(0, 7));
    const strongBuyArray: number[] = jsonValue.map((item: { strongBuy: any; }) => item.strongBuy);
    const buyArray: number[] = jsonValue.map((item: { buy: any; }) => item.buy);
    const holdArray: number[] = jsonValue.map((item: { hold: any; }) => item.hold);
    const sellArray: number[] = jsonValue.map((item: { sell: any; }) => item.sell);
    const strongSellArray: number[] = jsonValue.map((item: { strongSell: any; }) => item.strongSell);
    this.trendOptions = {
      chart: {
          type: 'column'
      },
      title: {
          text: 'Recommendation Trends',
          align: 'center'
      },
      xAxis: {
          type: 'datetime',
          categories: xCategoriesStr,
          scrollbar: {
            enabled: false
          }
      } as Highcharts.XAxisOptions,
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
      tooltip: {
          headerFormat: '<b>{point.x}</b><br/>',
          pointFormat: '{series.name}: {point.y}<br/>Total: {point.stackTotal}<br/>'
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
          data: strongBuyArray,
          color: '#006400'
      }, {
          type: 'column',  
          name: 'buy',
          data: buyArray,
          color: '#008000'
      }, {
          type: 'column',  
          name: 'hold',
          data: holdArray,
          color: '#A52A2A'
      }, {
          type: 'column',  
          name: 'sell',
          data: sellArray,
          color: '#FFC0CB'
      }, {
          type: 'column',  
          name: 'strongSell',
          data: strongSellArray,
          color: '#FF0000'
      }],
      navigator: {
          enabled: false
      },
      rangeSelector: {
          enabled: false
      }
    };
  }

  earningsOptions: Highcharts.Options = {};
  earningsContent: Highcharts.Chart | undefined;
  constructEarnings(jsonData: any): void {
    const jsonValue = JSON.parse(jsonData);
    const xCategoriesStr: string[] = jsonValue.map((item: { period: any; }) => item.period).reverse();
    const dateString = jsonValue[3].period;
    const parts = dateString.split('-');
    const year = parseInt(parts[0], 10);
    const month = parseInt(parts[1], 10) - 1;
    const day = parseInt(parts[2], 10);
    const utcDate = Date.UTC(year, month, day);
    const actualArray: number[] = jsonValue.map((item: { actual: any; }) => item.actual).reverse();
    const estimateArray: number[] = jsonValue.map((item: { estimate: any; }) => item.estimate).reverse();
    const surpriseArray: string[] = jsonValue.map((item: { surprise: any; }) => 'Surprise: ' + item.surprise).reverse();
    this.earningsOptions = {
      title: {
        text: 'Historical EPS Surprises',
        align: 'center'
      },

    plotOptions: {
        series: {
            pointStart: utcDate,
            pointInterval: 91.3125,
            pointIntervalUnit: "day"
        }
    },

    tooltip: {
        pointFormat: '<span style="color:{series.color}">{series.name}</span>: <b>{point.y}</b><br/>',
        changeDecimals: 2,
        valueDecimals: 2
    },

    xAxis: {
      categories: xCategoriesStr,
      labels: {
        formatter: function() {
          return Highcharts.dateFormat('%e. %b', (this.value as number));
        }
      }
    },
    yAxis: {
        title: {
            text: 'Quarterly EPS'
        },
        stackLabels: {
            enabled: true
        },
        opposite: false
    },

    series: [{
        type: 'line',
        name: 'Actual',
        data: actualArray.map((value, index) => [surpriseArray[index], value])
    }, {
        type: 'line',
        name: 'Estimate',
        data: estimateArray.map((value, index) => [surpriseArray[index], value])
    }],
    rangeSelector: {
      enabled: false
    },
    };
  }
  
  initializeChart(): void {
    if (!this.chartContent) {
      this.chartContent = Highchartsstock.stockChart('stockChartsShow', this.chartOptions);
    } else {
      // If the chart already exists, reflow it to adjust to the new container size
      setTimeout(() => this.chartContent?.reflow(), 0);
    }
  }
  initializeTrend(): void {
    if (!this.trendContent) {
      this.trendContent = Highcharts.chart('trendChart', this.trendOptions);
    } else {
      // If the chart already exists, reflow it to adjust to the new container size
      setTimeout(() => this.trendContent?.reflow(), 0);
    }
  }
  initializeEarnings(): void {
    if (!this.earningsContent) {
      this.earningsContent = Highcharts.chart('epsChart', this.earningsOptions);
    } else {
      // If the chart already exists, reflow it to adjust to the new container size
      setTimeout(() => this.earningsContent?.reflow(), 0);
    }
  }
  onTabChanged(event: MatTabChangeEvent): void {
    if (event.index === 2) {
      this.initializeChart();
    }
    else if (event.index === 3) {
      this.initializeTrend();
      this.initializeEarnings();
    }
  }

  starMark(jsonData: any): void {
    const jsonValue = JSON.parse(jsonData);
    console.log(jsonValue);
    const containsAAPL = jsonValue.some((item: { ticker: string; }) => item.ticker === this.descriptionTicker);
    console.log(containsAAPL);
    if (containsAAPL === true)
    {
      this.outWatchlist = false;
      this.inWatchlist = true;
    }
    else
    {
      this.outWatchlist = true;
      this.inWatchlist = false;
    }
  }

  // Construct page with input
  getPage(param: string): boolean {
    const baseUrl = 'http://localhost:3000/api/base?param=' + param;
    const summaryUrl = 'http://localhost:3000/api/summary?param=' + param;
    const newsUrl = 'http://localhost:3000/api/news?param=' + param;
    const historicalDataUrl = 'http://localhost:3000/api/historicalData?param=' + param;
    const insiderSentimentUrl = 'http://localhost:3000/api/insiderSentiment?param=' + param;
    const recommendationTrendsUrl = 'http://localhost:3000/api/recommendationTrends?param=' + param;
    const earningsUrl = 'http://localhost:3000/api/earnings?param=' + param;
    const getBalanceUrl = 'http://localhost:3000/api/fetchContent?param=0';
    const getWatchlistUrl = 'http://localhost:3000/api/fetchContent?param=1';
    const getPortfolioUrl = 'http://localhost:3000/api/fetchContent?param=2';

    const headers = new HttpHeaders({
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': 'http://localhost:3000'
    });
    
    this.http.get<any[]>(baseUrl).subscribe(
      value => {
        this.constructBase(JSON.stringify(value));
      }
    );
    this.http.get<any[]>(summaryUrl).subscribe(
      value => {
        this.constructSummary(JSON.stringify(value));
      }
    );
    this.http.get<any[]>(newsUrl).subscribe(
      value => {
        this.constructNews(JSON.stringify(value));
      }
    );
    this.http.get<any[]>(historicalDataUrl).subscribe(
      value => {
        this.constructStockCharts(JSON.stringify(value));
      }
    );
    this.http.get<any[]>(insiderSentimentUrl).subscribe(
      value => {
        this.constructTable(JSON.stringify(value));
      }
    );
    this.http.get<any[]>(recommendationTrendsUrl).subscribe(
      value => {
        this.constructRecommendationTrends(JSON.stringify(value));
      }
    );
    this.http.get<any[]>(earningsUrl).subscribe(
      value => {
        this.constructEarnings(JSON.stringify(value));
      }
    );
    console.log(getWatchlistUrl);
    this.http.get<any[]>(getWatchlistUrl, { headers: headers }).subscribe(
      value => {
        this.starMark(JSON.stringify(value));
      }
    );
    
    return true;
  }

  ngOnInit(): void {
    // Subscribe to route params
    this.route.params.subscribe(params => {
      // Extract the value of :ticker from the route params
      const ticker = params['ticker'];
      this.loadingTicker = true;
      // Set the value of the input control
      this.inputControl.setValue(ticker);
      if (this.getPage(ticker) === true)
      {
        this.loadingTicker = false;
      }
    });
    
    this.inputControl.valueChanges.subscribe(
      value => {
        this.options = [];
        this.loadingIcon = true;
        const url = 'http://localhost:3000/api/autofill?param=' + value;
        this.http.get<any[]>(url).pipe(finalize(() => this.loadingIcon = false)).subscribe( 
          value => {
            this.options = value;
        });
      }
    );
  }

  // Auto-complete route
  onOptionSelected(event: MatAutocompleteSelectedEvent): void {
    this.isHidden = true;
    const selectedOptionSymbol = event.option.value;
    this.router.navigateByUrl('/search/' + selectedOptionSymbol);
  }

  displayFn(option: any): string {
    return option ? `${option.symbol} - ${option.description}` : '';
  }

  // Show error data(the red block)
  async fetchDataFromServer(paramValue: string) {
    this.isHidden = true;
    try {
      const responseData = await this.apiService.fetchData(paramValue);
      if (Object.keys(responseData).length === 0)
      {
        this.isHidden = false;
        this.isAddToList = true;
      }
      else
      {
        this.router.navigateByUrl('/search/' + paramValue);
      }
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  }

  isAddToWatchlist: string = "";
  watchlist(num: number): void {
    const opWatchlistURL = "http://localhost:3000/api/opWatchlist?t=" + this.descriptionTicker + "&n=" + encodeURIComponent(this.descriptionName) + "&c=" + this.currentPrice + "&d=" + this.dPrice + "&dp=" + this.dPercent;
    if (num === 1)
    {
      const addWatchlistURL = opWatchlistURL + "&op=1";
      console.log(addWatchlistURL);
      this.http.get<any[]>(addWatchlistURL).subscribe();
      this.inWatchlist = true;
      this.outWatchlist = false;
      this.isAddToWatchlist = this.descriptionTicker + " added to Watchlist";
      this.isAddToList = false;
      this.isHidden = true;
    }
    else
    {
      const removeWatchlistURL = opWatchlistURL + "&op=0";
      this.http.get<any[]>(removeWatchlistURL).subscribe();
      this.inWatchlist = false;
      this.outWatchlist = true;
      this.isAddToWatchlist = "";
      this.isAddToList = true;
    }
  }

}
