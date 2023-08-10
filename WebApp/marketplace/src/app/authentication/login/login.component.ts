import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { SecurityService } from 'src/app/Services/security.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

  username: string;

  constructor(
    private readonly securityService: SecurityService,
    private router: Router
  ) { }


  ngOnInit(): void {
  }

  login(): void {
    this.securityService.login(this.username)
      .subscribe(
        () => {
          this.router.navigate(['']);
        },
        (err) => {
          alert('Error: login');
        });
  }

}
