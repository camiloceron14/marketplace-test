import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-offer-list',
  templateUrl: './offer-list.component.html',
  styleUrls: ['./offer-list.component.scss']
})
export class OfferListComponent implements OnInit {

  pageSize = 4;

  constructor() { }

  ngOnInit(): void {
  }

}
