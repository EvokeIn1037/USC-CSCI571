import { Component, OnInit, ElementRef, ViewChild } from '@angular/core';
import { ApiService } from '../services/api.service';
// import { JsonPipe } from '@angular/common'

@Component({
  selector: 'app-search',
  templateUrl: './search.component.html',
  styleUrls: ['./search.component.css']
})
export class SearchComponent implements OnInit {

  responseData: any;
  @ViewChild('tickerInput') tickerInput: any;
  @ViewChild('myInput') myInputKey!: ElementRef;

  constructor(private apiService: ApiService, private elementRef: ElementRef) {}

  async fetchDataFromServer(paramValue: string) {
    try {
      this.responseData = await this.apiService.fetchData(paramValue);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  }

  ngOnInit(): void {
    this.addEventListenerToInput();
  }

  addEventListenerToInput() {
    const inputElement = document.getElementById('tickerInputText');
    const inputBtn = document.getElementById('tickerInputBtn');

    if (inputElement) {
      inputElement.addEventListener('keydown', (event) => {
        if (event.key === 'Enter') {
          event.preventDefault();
          if (inputBtn) {
            inputBtn.click();
          }
        }
      });
    }
  }

  clear() {
    this.tickerInput.nativeElement.value = '';
    this.responseData = {};
  }

}
