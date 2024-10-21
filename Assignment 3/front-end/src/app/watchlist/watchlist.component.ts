import { Component, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';

@Component({
  selector: 'app-watchlist',
  templateUrl: './watchlist.component.html',
  styleUrls: ['./watchlist.component.css']
})
export class WatchlistComponent implements OnInit {
  constructor(private http: HttpClient) { }

  isHidden = false;

  watchlist: any[] = [];
  showWatchlist(jsonData: any): void {
    this.watchlist = JSON.parse(jsonData);
    this.watchlist = this.watchlist.map((item, index) => ({
      ...item,
      index: index
  }));
    if (this.watchlist.length === 0){
      this.isHidden = false;
    }
    else
    {
      this.isHidden = true;
    }
  }

  delete(): void {
    const deleteURL = "http://localhost:3000/api/opWatchlist?t=" + this.watchlist[0].t + "&n=" + encodeURIComponent(this.watchlist[0].n) + "&c=" + this.watchlist[0].c + "&d=" + this.watchlist[0].d + "&dp=" + this.watchlist[0].dp + "&op=0";
    this.http.get<any[]>(deleteURL).subscribe();
  }

  ngOnInit(): void {
    const getWatchlistUrl = 'http://localhost:3000/api/fetchContent?param=1';
    this.http.get<any[]>(getWatchlistUrl).subscribe(
      value => {
        this.showWatchlist(JSON.stringify(value));
      }
    );
  }

}
