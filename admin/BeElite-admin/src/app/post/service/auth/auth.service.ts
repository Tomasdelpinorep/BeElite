import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable, of } from 'rxjs';
import { Injectable, inject } from '@angular/core';
import { TokenStorageService } from './token.storage.service';
import { environment } from '../../../environment/environtments';

const httpOptions = {
  headers: new HttpHeaders({ 'Content-Type': 'application/json' })
}

@Injectable({
  providedIn: 'root'
})
export class AuthService {

  constructor(private http: HttpClient) { }
  userRole!: string;
  tokenStorageService!: TokenStorageService;

  login(username: string, password: string): Observable<any> {
    //return this.http.post(AUTH_API + 'signin', {
    return this.http.post(`${environment.authUrl}login`, {
      username,
      password
    });
  }

  isAdmin(): boolean {
    if (inject(TokenStorageService).getUser().role === 'ROLE_ADMIN') return true;

    return false;
  }
}
