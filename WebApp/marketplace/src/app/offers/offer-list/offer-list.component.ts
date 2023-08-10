import { Component, OnInit } from '@angular/core';
import { MarketplaceApiService } from 'src/app/core/marketplace-api/marketplace-api.service';
import { OfferModel } from 'src/app/core/marketplace-api/models/offer.model';

@Component({
  selector: 'app-offer-list',
  templateUrl: './offer-list.component.html',
  styleUrls: ['./offer-list.component.scss']
})
export class OfferListComponent implements OnInit {

  pageSize = 10;
  offers: OfferModel[] = [];
  totalPages;
  hasPrevious: boolean;
  hasNext: boolean;

  constructor(private readonly marketplaceApiService: MarketplaceApiService) { }

  ngOnInit(): void {
    this.getData(1);
  }

  private getData(pageNumber: number){
    this.marketplaceApiService.getOffers(pageNumber,this.pageSize).subscribe( (resp:any) => {
      this.offers = resp.data;
      this.totalPages = Array.from({length: resp.totalPages}, (_, i) => i + 1);
      this.hasPrevious = resp.previousPage ? true : false;
      this.hasNext = resp.nextPage ? true : false;
    });
  }

  onChagePage(page){
    this.getData(page);
  }

}
