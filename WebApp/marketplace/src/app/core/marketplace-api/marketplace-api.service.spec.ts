import { TestBed } from '@angular/core/testing';

import { MarketplaceApiService } from './marketplace-api.service';

describe('MarketplaceApiService', () => {
  let service: MarketplaceApiService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(MarketplaceApiService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
