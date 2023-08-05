// <copyright company="ROSEN Swiss AG">
//  Copyright (c) ROSEN Swiss AG
//  This computer program includes confidential, proprietary
//  information and is a trade secret of ROSEN. All use,
//  disclosure, or reproduction is prohibited unless authorized in
//  writing by an officer of ROSEN. All Rights Reserved.
// </copyright>

using System.Collections.Generic;

namespace Marketplace.Core.Model;

public class User
{
    #region Properties

    /// <summary>
    ///     Gets or sets the identifier.
    /// </summary>
    /// <value>
    ///     The identifier.
    /// </value>
    public int Id { get; set; }

    /// <summary>
    ///     Gets or sets the offers.
    /// </summary>
    /// <value>
    ///     The offers.
    /// </value>
    public List<Offer> Offers { get; set; }

    /// <summary>
    ///     Gets or sets the username.
    /// </summary>
    /// <value>
    ///     The username.
    /// </value>
    public string Username { get; set; }

    #endregion
}