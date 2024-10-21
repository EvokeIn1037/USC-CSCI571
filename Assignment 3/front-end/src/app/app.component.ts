import { Component, OnInit } from '@angular/core';
import { ElementRef } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'front-end';

  constructor(private elementRef: ElementRef, private http: HttpClient) {}

  initBalance: number = 25000;
  initStart: number = 0;
  initDb(): void {
    const initUrl = 'http://localhost:3000/api/initDB?param=' + this.initBalance;
    this.http.get<any[]>(initUrl).subscribe(
      value => {
        console.log(JSON.stringify(value));
      }
    );
  }

  ngOnInit() {
    const searchButton = this.elementRef.nativeElement.querySelector('#searchNavBtn');
    const watchlistButton = this.elementRef.nativeElement.querySelector('#watchlistNavBtn');
    const portfolioButton = this.elementRef.nativeElement.querySelector('#portfolioNavBtn');

    this.initStart++;
    if (this.initStart === 1)
    {
      this.initDb();
    }
    
    function searchFontB() {
      searchButton.style.fontWeight = "bold";
    }
    function searchFontN() {
      searchButton.style.fontWeight = "normal";
    }

    function watchlistFontB() {
      watchlistButton.style.fontWeight = "bold";
    }
    function watchlistFontN() {
      watchlistButton.style.fontWeight = "normal";
    }

    function portfolioFontB() {
      portfolioButton.style.fontWeight = "bold";
    }
    function portfolioFontN() {
      portfolioButton.style.fontWeight = "normal";
    }

    function showSearch() {
      searchFontB();
      watchlistFontN();
      portfolioFontN();
      searchButton.style.borderWidth = "2px";
      watchlistButton.style.borderWidth = "0";
      portfolioButton.style.borderWidth = "0";
  
      watchlistButton.addEventListener("mouseenter", watchlistFontB);
      portfolioButton.addEventListener("mouseenter", portfolioFontB);
      watchlistButton.addEventListener("mouseleave", watchlistFontN);
      portfolioButton.addEventListener("mouseleave", portfolioFontN);
      searchButton.removeEventListener("mouseenter", searchFontB);
      searchButton.removeEventListener("mouseleave", searchFontN);
    }
  
    function showWatchlist() {
      watchlistFontB();
      searchFontN();
      portfolioFontN();
      watchlistButton.style.borderWidth = "2px";
      searchButton.style.borderWidth = "0";
      portfolioButton.style.borderWidth = "0";
  
      searchButton.addEventListener("mouseenter", searchFontB);
      portfolioButton.addEventListener("mouseenter", portfolioFontB);
      searchButton.addEventListener("mouseleave", searchFontN);
      portfolioButton.addEventListener("mouseleave", portfolioFontN);
      watchlistButton.removeEventListener("mouseenter", watchlistFontB);
      watchlistButton.removeEventListener("mouseleave", watchlistFontN);
    }
    
    function showPortfolio() {
      portfolioFontB();
      searchFontN();
      watchlistFontN();
      portfolioButton.style.borderWidth = "2px";
      searchButton.style.borderWidth = "0";
      watchlistButton.style.borderWidth = "0";
  
      searchButton.addEventListener("mouseenter", searchFontB);
      watchlistButton.addEventListener("mouseenter", watchlistFontB);
      searchButton.addEventListener("mouseleave", searchFontN);
      watchlistButton.addEventListener("mouseleave", watchlistFontN);
      portfolioButton.removeEventListener("mouseenter", portfolioFontB);
      portfolioButton.removeEventListener("mouseleave", portfolioFontN);
    }

    searchButton.addEventListener('click', showSearch);
    watchlistButton.addEventListener('click', showWatchlist);
    portfolioButton.addEventListener('click', showPortfolio);
  }
}
