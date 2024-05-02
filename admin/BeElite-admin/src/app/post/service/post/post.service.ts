import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import {  Observable, throwError } from 'rxjs';
import { AllUsersResponse } from '../../../models/all-coaches-response.interface';
import { environment } from '../../../environment/environtments';
import { CoachDetails } from '../../../models/coach-details-dto.interface';
  
@Injectable({
  providedIn: 'root'
})
export class PostService {

  constructor(private http: HttpClient) { }

  token = localStorage.getItem("auth-token");

  headers = new HttpHeaders({
    'Authorization': `Bearer ${this.token}`
  });

  getAllCoaches(pageNumber : number): Observable<AllUsersResponse> {
    return this.http.get<AllUsersResponse>(`${environment.apiBaseUrl}coach/all?page=${pageNumber}`,
      {headers: this.headers}
    );
  }

  findCoach(coachUsername:String){
    return this.http.get<CoachDetails>(`${environment.apiBaseUrl}coach/${coachUsername}`);
  }
   
    
  editCoach(coachUsername : String, coachData :any){
    return this.http.put<any>(`${environment.apiBaseUrl}admin/edit/coach/${coachUsername}`, coachData);
  }
  
  createCoach(coachData:any){
    return this.http.post<any>(`${environment.apiBaseUrl}admin/create/coach`, coachData);
  }
    
  delete(coachUsername : String){
    return this.http.delete(`${environment.apiBaseUrl}admin/delete/${coachUsername}`);
  }
    
  errorHandler(error:any) {
    let errorMessage = '';
    if(error.error instanceof ErrorEvent) {
      errorMessage = error.error.message;
    } else {
      errorMessage = `Error Code: ${error.status}\nMessage: ${error.message}`;
    }
    return throwError(errorMessage);
 }
}