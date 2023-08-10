import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';
import { SecurityService } from 'src/app/Services/security.service';


@Injectable({
  providedIn: 'root'
})
export class LoginGuard implements CanActivate {

  constructor(
    private router: Router,
    private securityService: SecurityService
  ) {}

  canActivate() {
    const isLoggedIn = this.securityService.isLoggedIn();

    if (!isLoggedIn) {
      this.router.navigate(['login']);
    }

    return isLoggedIn;
  }

}
