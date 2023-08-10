// <copyright company="ROSEN Swiss AG">
//  Copyright (c) ROSEN Swiss AG
//  This computer program includes confidential, proprietary
//  information and is a trade secret of ROSEN. All use,
//  disclosure, or reproduction is prohibited unless authorized in
//  writing by an officer of ROSEN. All Rights Reserved.
// </copyright>

namespace Marketplace.Core.Dal
{
    using System.Threading.Tasks;
    using Marketplace.Core.Model;
    using Marketplace.Core.Filter;
    using System.Collections.Generic;

    /// <summary>
    /// Contract for the Offer data access
    /// </summary>
    public interface IOfferRepository
    {
        #region Methods

        /// <summary>
        /// Gets all Offers asynchronous.
        /// </summary>
        /// <returns>Array of offers</returns>
        Task<Offer[]> GetAllOffersAsync();

        /// <summary>
        /// save offer.
        /// </summary>
        /// <param name="offer">offer new.</param> 
        /// <returns>new offer</returns>
        Task<Offer> CreateOffer(Offer offer);

        /// <summary>
        /// Gets pagination Offers asynchronous.
        /// </summary>
        /// <param name="paginationFilter">configuration pagination.</param>
        /// <returns>List of offers</returns>
        Task<List<Offer>> GetPageOffersAsync(int page, int size);

        Task<int> CountOffers();

        #endregion
    }
}