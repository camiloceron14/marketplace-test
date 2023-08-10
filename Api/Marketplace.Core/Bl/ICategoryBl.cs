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

    /// <summary>
    /// Contract for the Category logic
    /// </summary>
    public interface ICategoryBl
    {
        #region Methods

        /// <summary>
        /// Gets the categories.
        /// </summary>
        /// <returns>LIst of categories</returns>
        Task<IEnumerable<Category>> GetCategoriesAsync();

        #endregion
    }
}