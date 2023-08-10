import {Injectable} from '@angular/core';
import {Observable, of} from 'rxjs';
import {OfferModel} from './models/offer.model';
import { HttpClient, HttpParams } from '@angular/common/http';
import { CategoryModel } from './models/category.model';

@Injectable({
  providedIn: 'root'
})
export class MarketplaceApiService {

  private readonly marketplaceApUrl = 'https://localhost:44313';

  constructor(private http: HttpClient) { }

  getOffers(page: number, pageSize: number): Observable<OfferModel[]> {
    const url = `${this.marketplaceApUrl}/OffersPagination`;
    let params = new HttpParams();
    params = params.append('PageNumber', page.toString());
    params = params.append('PageSize', pageSize.toString());
    return this.http.get( url, { params } )
      .pipe ( (resp: any) => resp );
  }

  postOffer(offer: OfferModel): Observable<OfferModel> {
    const url = `${this.marketplaceApUrl}/Offer`;
    offer.userId = 1;
    return this.http.post( url, offer)
      .pipe ( (resp: any) => resp );
  }

  getCategories(): Observable<CategoryModel[]> {
    const url = `${this.marketplaceApUrl}/Category`;
    return this.http.get( url )
      .pipe ( (resp: any) => resp );
  }
}
