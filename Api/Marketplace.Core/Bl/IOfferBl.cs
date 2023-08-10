// <copyright company="ROSEN Swiss AG">
//  Copyright (c) ROSEN Swiss AG
//  This computer program includes confidential, proprietary
//  information and is a trade secret of ROSEN. All use,
//  disclosure, or reproduction is prohibited unless authorized in
//  writing by an officer of ROSEN. All Rights Reserved.
// </copyright>

namespace Marketplace.Core.Bl
{
    using System.Collections.Generic;
    using System.Threading.Tasks;
    using Marketplace.Core.Model;
    using Marketplace.Core.Filter;

    /// <summary>
    /// Contract for the Offer logic
    /// </summary>
    public interface IOfferBl
    {
        #region Methods

        /// <summary>
        /// Gets the Offers.
        /// </summary>
        /// <returns>LIst of offer</returns>
        Task<IEnumerable<Offer>> GetOffersAsync();

        /// <summary>
        /// Gets pagination the Offers.
        /// </summary>
        /// <param name="start">page to star.</param>
        /// <param name="size">size page.</param>
        /// <returns>LIst of offer</returns>
        Task<List<Offer>> GetPaginationOffersAsync(int page, int size);

        /// <summary>
        /// CreateOffer
        /// </summary>
        /// <param name="offer">offer new.</param> 
        /// <returns>new offer</returns>
        Task<Offer> CreateOffer(Offer offer);

        Task<int> CountOffers();

        #endregion
    }
}