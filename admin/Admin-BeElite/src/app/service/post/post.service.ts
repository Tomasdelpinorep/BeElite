import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { environment } from '../../environment/environtments';
import { AllUsersResponse } from '../../models/all-coaches-response.interface';
import { CoachDetails } from '../../models/coach-details-dto.interface';
import { AthleteDetails } from '../../models/athlete-details';
import { AllProgramsResponse } from '../../models/all-programs-response';
import { ProgramDetails } from '../../models/program-details';
import { CoachBasicDto } from '../../models/coachBasicDto';

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

  getAllAthletes(pageNumber: number): Observable<AllUsersResponse> {
    return this.http.get<AllUsersResponse>(`${environment.apiBaseUrl}athlete/all?page=${pageNumber}`,
      { headers: this.headers }
    );
  }

  getAllPrograms(pageNumber: number): Observable<AllProgramsResponse> {
    return this.http.get<AllProgramsResponse>(`${environment.apiBaseUrl}admin/programs/all?page=${pageNumber}`,
      { headers: this.headers }
    );
  }

  findCoach(coachUsername: String) {
    return this.http.get<CoachDetails>(`${environment.apiBaseUrl}coach/${coachUsername}`,
      { headers: this.headers }
    );
  }

  findAthlete(coachUsername: String) {
    return this.http.get<AthleteDetails>(`${environment.apiBaseUrl}athlete/${coachUsername}`,
      { headers: this.headers }
    );
  }

  findProgram(coachUsername: String, programName: String) {
    return this.http.get<ProgramDetails>(`${environment.apiBaseUrl}coach/${coachUsername}/${programName}/details`,
      { headers: this.headers }
    );
  }

  getUserProfilePicture(username: String) {
    return this.http.get(`${environment.apiBaseUrl}profile-picture/${username}`,
      { headers: this.headers }
    );
  }


  editUser(coachData: any, selectedProfilePic: File | null) {
    const formData: FormData = new FormData();
    formData.append('name', coachData.name);
    formData.append('email', coachData.email);
    formData.append('username', coachData.username);

    if (selectedProfilePic != null && selectedProfilePic != undefined) {
      formData.append('profilePic', selectedProfilePic, selectedProfilePic.name)
    }

    return this.http.put<any>(`${environment.apiBaseUrl}admin/user/edit`,
      formData,
      { headers: this.headers }
    );
  }

  editProgram(programData: any, programPic: File | null) {
    const formData: FormData = new FormData();
    formData.append('programName', programData.programName);
    formData.append('originalProgramName', programData.originalProgramName);
    formData.append('coachUsername', programData.coachUsername);
    formData.append('programDescription', programData.programDescription);

    if (programPic != null && programPic != undefined) {
      formData.append('programPic', programPic, programPic.name)
    }

    return this.http.put<any>(`${environment.apiBaseUrl}admin/program/edit`,
      formData,
      { headers: this.headers }
    );
  }

  createUser(coachData: any, userType: String) {
    return this.http.post<any>(`${environment.apiBaseUrl}auth/register`,
      { name: coachData.name, username: coachData.username, email: coachData.email, password: coachData.password, verifyPassword: coachData.verifyPassword, userType: userType });
  }

  createProgram(postProgramDto: any, programPic: File | null) {
    const formData: FormData = new FormData();
    formData.append('programName', postProgramDto.programName);
    formData.append('programDescription', postProgramDto.programDescription);

    if (programPic != null && programPic != undefined) {
      formData.append('programPic', programPic, programPic.name)
    }

    return this.http.post<any>(`${environment.apiBaseUrl}admin/create/program`,
      formData,
      { headers: this.headers }
    );
  }

  delete(coachUsername: String) {
    return this.http.delete(`${environment.apiBaseUrl}admin/user/delete/${coachUsername}`,
      { headers: this.headers }
    );
  }

  deleteProgram(coachUsername: string, programName: string) {
    return this.http.delete(`${environment.apiBaseUrl}coach/${coachUsername}/${programName}`,
      { headers: this.headers }
    );
  }

  deleteWeek(coachUsername: String, programName: string, weekName: string, weekNumber: number) {
    return this.http.delete(`${environment.apiBaseUrl}coach/${coachUsername}/${programName}/weeks/${weekName}/${weekNumber}`,
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

  getAllCoachNamesAndId() {
    return this.http.get<CoachBasicDto>(`${environment.apiBaseUrl}coach/allNamesAndIds`,
      { headers: this.headers }
    );
  }
}