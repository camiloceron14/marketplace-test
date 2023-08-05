import {Component, Input, OnInit} from '@angular/core';
import {UntypedFormGroup} from '@angular/forms';

@Component({
  selector: 'app-offer-creation',
  templateUrl: './offer-creation.component.html',
  styleUrls: ['./offer-creation.component.scss']
})
export class OfferCreationComponent implements OnInit {

  offerForm: UntypedFormGroup;

  @Input()
  categories: string[];

  constructor() { }

  ngOnInit(): void {
  }

  offerSubmit() {
    // TODO: implement submit logic
  }
}
