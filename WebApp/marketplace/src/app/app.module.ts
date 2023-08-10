import { BrowserModule } from '@angular/platform-browser';
import { APP_INITIALIZER, NgModule } from '@angular/core';
import { HttpClientModule } from '@angular/common/http';

import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { MainMenuComponent } from './main-menu/main-menu.component';
import { OffersModule } from './offers/offers.module';
import { AuthenticationModule } from './authentication/authentication.module';
import { AppConfigService } from './Services/app-config.service';
import { NgbModule } from '@ng-bootstrap/ng-bootstrap';

export function initializeApp(appConfigService: AppConfigService) {
  return (): Promise<any> => {
    return appConfigService.load();
  };
}
@NgModule({
  declarations: [
    AppComponent,
    MainMenuComponent
  ],
  imports: [
    BrowserModule,
    AppRoutingModule,
    HttpClientModule,
    OffersModule,
    AuthenticationModule,
    NgbModule
  ],
  providers: [AppConfigService,
    { provide: APP_INITIALIZER, useFactory: initializeApp, deps: [AppConfigService], multi: true }],
  bootstrap: [AppComponent]
})
export class AppModule { }
