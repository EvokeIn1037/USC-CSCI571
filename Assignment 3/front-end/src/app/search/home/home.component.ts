import { Component, OnInit, ViewChild } from '@angular/core';
import { ApiService } from 'src/app/services/api.service';
import { FormControl } from '@angular/forms';
import { finalize } from 'rxjs/operators';
import { HttpClient } from '@angular/common/http';
import { Router } from '@angular/router';
import { MatAutocompleteSelectedEvent } from '@angular/material/autocomplete';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {

  responseData: any;
  @ViewChild('tickerInput') tickerInput: any;
  inputControl = new FormControl();
  options: any[] = [];
  loadingIcon = false;
  isHidden = true;
  
  constructor(private apiService: ApiService, private http: HttpClient, private router: Router) { }

  ngOnInit(): void {
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

  onOptionSelected(event: MatAutocompleteSelectedEvent): void {
    this.isHidden = true;
    const selectedOptionSymbol = event.option.value;
    this.router.navigateByUrl('/search/' + selectedOptionSymbol);
  }

  displayFn(option: any): string {
    return option ? `${option.symbol} - ${option.description}` : '';
  }

  async fetchDataFromServer(paramValue: string) {
    this.isHidden = true;
    try {
      const responseData = await this.apiService.fetchData(paramValue);
      if (Object.keys(responseData).length === 0)
      {
        this.isHidden = false;
      }
      else
      {
        this.router.navigateByUrl('/search/' + paramValue);
      }
    } catch (error) {
      console.error('Error fetching data:', error);
    }
  }

  clear() {
    this.tickerInput.nativeElement.value = '';
    this.isHidden = true;
  }

}
