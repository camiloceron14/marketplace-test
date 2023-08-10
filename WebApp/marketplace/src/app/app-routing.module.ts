import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import {LoginComponent} from './authentication/login/login.component';
import {OfferListComponent} from './offers/offer-list/offer-list.component';
import {OfferCreationComponent} from './offers/offer-creation/offer-creation.component';
import {LoginGuard} from './core/guards/login.guard';


const routes: Routes = [
  {path: 'create', component: OfferCreationComponent, pathMatch: 'full', canActivate: [LoginGuard]},
  {path: 'login', component: LoginComponent, pathMatch: 'full'},
  {path: '', component: OfferListComponent, pathMatch: 'full', canActivate: [LoginGuard] },
  {path: '*', redirectTo: ''},
];


@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
