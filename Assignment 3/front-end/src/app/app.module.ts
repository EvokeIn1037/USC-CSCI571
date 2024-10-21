import { NgModule } from '@angular/core';
import { BrowserModule, DomSanitizer, SafeResourceUrl, SafeUrl } from '@angular/platform-browser';
import { HttpClientModule } from '@angular/common/http';
import { ReactiveFormsModule } from '@angular/forms';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatInputModule } from '@angular/material/input';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { MatTabsModule } from '@angular/material/tabs';
import { MatCardModule } from '@angular/material/card';
import { MatDialogModule } from '@angular/material/dialog';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { SearchComponent } from './search/search.component';
import { WatchlistComponent } from './watchlist/watchlist.component';
import { PortfolioComponent } from './portfolio/portfolio.component';
import { HomeComponent } from './search/home/home.component';
import { TickerComponent } from './search/ticker/ticker.component';
import { HighchartsChartModule } from 'highcharts-angular';
import { ModalWindowComponent } from './modal-window/modal-window.component';

@NgModule({
  declarations: [
    AppComponent,
    SearchComponent,
    WatchlistComponent,
    PortfolioComponent,
    HomeComponent,
    TickerComponent,
    ModalWindowComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    ReactiveFormsModule,
    MatAutocompleteModule,
    BrowserAnimationsModule,
    MatInputModule,
    MatFormFieldModule,
    MatProgressSpinnerModule,
    HighchartsChartModule,
    MatTabsModule,
    MatCardModule,
    MatDialogModule
  ],
  entryComponents: [
    ModalWindowComponent
  ],
  providers: [
    {
      provide: 'defaultPolicy',
      useValue: {
        allowList: {
          a: ['routerLink', 'href'],
          // Add other allowed elements and attributes as needed
        },
      },
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
