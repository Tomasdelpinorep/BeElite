import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { environment } from '../../environment/environtments';
import { AllUsersResponse } from '../../models/all-coaches-response.interface';
import { CoachDetails } from '../../models/coach-details-dto.interface';

@Injectable({
  providedIn: 'root'
})
export class PostService {

  constructor(private http: HttpClient) { }

  token = localStorage.getItem("auth-token");

  headers = new HttpHeaders({
    'Authorization': `Bearer ${this.token}`
  });

  checkUsername(username: String): Observable<boolean> {
    return this.http.get<boolean>(`${environment.apiBaseUrl}checkAvailability/${username}`,
      { headers: this.headers }
    );
  }

  getAllCoaches(pageNumber: number): Observable<AllUsersResponse> {
    return this.http.get<AllUsersResponse>(`${environment.apiBaseUrl}coach/all?page=${pageNumber}`,
      { headers: this.headers }
    );
  }

  findCoach(coachUsername: String) {
    return this.http.get<CoachDetails>(`${environment.apiBaseUrl}coach/${coachUsername}`,
    { headers: this.headers }
    );
  }


  editCoach(coachData: any, originalCoachUsername: String) {
    return this.http.put<any>(`${environment.apiBaseUrl}admin/user/edit/${originalCoachUsername}`,
    { name: coachData.name, email: coachData.email},
    { headers: this.headers }
    );
  }

  createCoach(coachData: any) {
    return this.http.post<any>(`${environment.apiBaseUrl}auth/register`,
      { name: coachData.name, username: coachData.username, email: coachData.email, password: coachData.password, verifyPassword: coachData.verifyPassword, userType: "coach" });
  }

  delete(coachUsername: String) {
    return this.http.delete(`${environment.apiBaseUrl}admin/delete/${coachUsername}`,
    { headers: this.headers }
    );
  }

  errorHandler(error: any) {
    let errorMessage = '';
    if (error.error instanceof ErrorEvent) {
      errorMessage = error.error.message;
    } else {
      errorMessage = `Error Code: ${error.status}\nMessage: ${error.message}`;
    }
    return throwError(errorMessage);
  }
}