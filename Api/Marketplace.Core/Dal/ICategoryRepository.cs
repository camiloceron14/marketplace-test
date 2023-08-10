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

    /// <summary>
    /// Contract for the Category data access
    /// </summary>
    public interface ICategoryRepository
    {
        #region Methods

        /// <summary>
        /// Gets all Category asynchronous.
        /// </summary>
        /// <returns>Array of Categories</returns>
        Task<Category[]> GetAllCategoriesAsync();

        #endregion
    }
}