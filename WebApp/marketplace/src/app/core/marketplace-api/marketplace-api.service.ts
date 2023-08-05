import {Injectable} from '@angular/core';
import {Observable, of} from 'rxjs';
import {OfferModel} from './models/offer.model';

@Injectable({
  providedIn: 'root'
})
export class MarketplaceApiService {

  private readonly marketplaceApUrl = '';

  constructor() { }

  getOffers(page: number, pageSize: number): Observable<OfferModel[]> {
    // TODO: implement the logic to retrieve paginated offers from the service
    return of([]);
  }

  postOffer(): Observable<string> {
    // TODO: implement the logic to post a new offer, also validate whatever you consider before posting
    return of('');
  }

  getCategories(): Observable<string[]> {
    // TODO: implement the logic to retrieve the categories from the service
    return of([]);
  }
}
