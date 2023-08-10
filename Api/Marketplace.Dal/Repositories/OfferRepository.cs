// <copyright company="ROSEN Swiss AG">
//  Copyright (c) ROSEN Swiss AG
//  This computer program includes confidential, proprietary
//  information and is a trade secret of ROSEN. All use,
//  disclosure, or reproduction is prohibited unless authorized in
//  writing by an officer of ROSEN. All Rights Reserved.
// </copyright>

namespace Marketplace.Dal.Repositories
{
    using System.Threading.Tasks;
    using Marketplace.Core.Dal;
    using Marketplace.Core.Model;
    using Marketplace.Core.Filter;
    using Microsoft.EntityFrameworkCore;
    using System.Linq;
    using System.Collections.Generic;

    public class OfferRepository : IOfferRepository
    {
        #region Fields

        private readonly MarketplaceDb _context;

        #endregion

        #region Constructors

        public OfferRepository()
        {
            _context = new MarketplaceDb();
        }

        #endregion

        #region Methods

        /// <inheritdoc />
        public async Task<Offer[]> GetAllOffersAsync()
        {
            //return await _context.Offers.ToArrayAsync();
            return null;
        }

        /// <inheritdoc />
        public async Task<List<Offer>> GetPageOffersAsync(int page, int size)
        {
            return await _context.GetPageOffersAsync(page, size);
        }

        /// <inheritdoc />
        public async Task<Offer> CreateOffer(Offer offer)
        {
            return await _context.InsertOffer(offer);
        }

        /// <inheritdoc />
        public async Task<int> CountOffers()
        {
            return await _context.CountOffers();
        }       
        #endregion
    }
}