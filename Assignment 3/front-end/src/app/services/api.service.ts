import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http'
import { lastValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class ApiService {

  private apiUrl = 'http://localhost:3000/api/data';

  constructor(private http: HttpClient) {}

  async fetchData(param: string): Promise<any> {
    let result = await lastValueFrom(this.http.get<any>(`${this.apiUrl}?param=${param}`));
    return result;
  }
}
