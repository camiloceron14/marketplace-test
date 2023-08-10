import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { SecurityService } from '../Services/security.service';

@Component({
  selector: 'app-main-menu',
  templateUrl: './main-menu.component.html',
  styleUrls: ['./main-menu.component.scss']
})
export class MainMenuComponent {

  constructor( public readonly securityService: SecurityService,
    private router: Router) { }

  mainMenuOpen: boolean = false;
  
  logout(){
    this.securityService.logout();
    this.router.navigate(['/login']);
    this.mainMenuOpen = false;
  }
  

}
