import {Component, Input, OnInit} from '@angular/core';
import {FormBuilder, FormControl, FormGroup, Validators} from '@angular/forms';
import { Router } from '@angular/router';
import { MarketplaceApiService } from 'src/app/core/marketplace-api/marketplace-api.service';
import { CategoryModel } from 'src/app/core/marketplace-api/models/category.model';
import { OfferModel } from 'src/app/core/marketplace-api/models/offer.model';

@Component({
  selector: 'app-offer-creation',
  templateUrl: './offer-creation.component.html',
  styleUrls: ['./offer-creation.component.scss']
})
export class OfferCreationComponent implements OnInit {

  offerForm: FormGroup;

  categories: CategoryModel[] = [];

  offer: OfferModel = new OfferModel();

  constructor(private readonly marketplaceApiService: MarketplaceApiService,
    private readonly formBuilder: FormBuilder,
    private router: Router) {
   }

  ngOnInit(): void {
    this.marketplaceApiService.getCategories().subscribe((resp:CategoryModel[])=>{
      this.categories = resp;
    });
    this.offerForm = this.formBuilder.group({
      titleCtrl: new FormControl('', [Validators.required, Validators.maxLength(100)]),
      pictureUrlCtrl: new FormControl('', [Validators.required, Validators.maxLength(100)]),
      descriptionCtrl: new FormControl('', Validators.required),
      locationCtrl: new FormControl('', [Validators.required, Validators.maxLength(100)]),
      categoryCtrl: new FormControl('', Validators.required)
    });
  }

  offerSubmit() {
    if(this.offerForm.valid){
      this.marketplaceApiService.postOffer(this.offer).subscribe( (resp:any)=>{
        alert('post created successfully');
        this.router.navigate(['']);
      });
    }else{
      this.offerForm.markAsDirty();
      this.offerForm.markAllAsTouched();
    }
  }
}
