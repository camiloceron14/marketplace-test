import { Injectable } from '@angular/core';
import { AppConfigService } from './app-config.service';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { UserModel } from '../core/marketplace-api/models/user.model';
import {map} from "rxjs/operators";

@Injectable({
  providedIn: 'root'
})
export class SecurityService {

  public readonly constans = AppConfigService.settings.constans;
  private readonly apiUrl: string;

  private readonly USERID = 'userId';
  private readonly USERNAME = 'username';

  constructor(private http: HttpClient) { 
    this.apiUrl = this.constans.API_URL;
  }

  get userId(): string {
    return localStorage.getItem(this.USERID);
  }

  get username(): string {
    return localStorage.getItem(this.USERNAME);
  }

  login(username: string): Observable<UserModel> {
    const url = `${this.apiUrl}/User/login`;
    return this.http.post( url, {username} )
      .pipe ( map((result: any) => {
        this.setLocalstorage(result.id, result.username);
        return result;
      }));
  }

  setLocalstorage( id: string, username: string ) {
    localStorage.setItem(this.USERID, id);
    localStorage.setItem(this.USERNAME, username);
  }

  logout(): void{
    localStorage.removeItem(this.USERID);
    localStorage.removeItem(this.USERNAME);
  }

  isLoggedIn(): boolean {
    return !!this.userId;
  }
}
