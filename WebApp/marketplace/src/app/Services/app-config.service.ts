import { Injectable } from '@angular/core';
import { AppConfig } from '../Contracts/app-config';
import { HttpClient } from '@angular/common/http';

@Injectable({
  providedIn: 'root'
})
export class AppConfigService {

  static settings: AppConfig;

    constructor(private http: HttpClient) {}

    load(): any {
        const jsonFile = `assets/Config/configuration.json?p=` + (new Date()).getTime();
        return new Promise<void>((resolve, reject) => {
            this.http.get(jsonFile).toPromise().then((response: AppConfig) => {
               AppConfigService.settings = response as AppConfig;
               resolve();
            }).catch((response: any) => {
               reject(`Could not load the config file`);
            });
        });
    }
}
