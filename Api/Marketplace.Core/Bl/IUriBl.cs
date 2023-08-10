// <copyright company="ROSEN Swiss AG">
//  Copyright (c) ROSEN Swiss AG
//  This computer program includes confidential, proprietary
//  information and is a trade secret of ROSEN. All use,
//  disclosure, or reproduction is prohibited unless authorized in
//  writing by an officer of ROSEN. All Rights Reserved.
// </copyright>

namespace Marketplace.Core.Bl
{
    using System;
    using Marketplace.Core.Filter;
    public interface IUriBl
    {
        public Uri GetPageUri(PaginationFilter filter, string route);
    }
}