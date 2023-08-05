// <copyright company="ROSEN Swiss AG">
//  Copyright (c) ROSEN Swiss AG
//  This computer program includes confidential, proprietary
//  information and is a trade secret of ROSEN. All use,
//  disclosure, or reproduction is prohibited unless authorized in
//  writing by an officer of ROSEN. All Rights Reserved.
// </copyright>

using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using Marketplace.Core.Model;
using Microsoft.Data.Sqlite;

namespace Marketplace.Dal
{
    internal class MarketplaceDb : IMarketplaceDb, IDisposable
    {
        private readonly SqliteConnection _connection;

        public MarketplaceDb()
        {
            var path = Path.GetFullPath(Path.Combine(Environment.CurrentDirectory, @".."));
            _connection = new SqliteConnection($@"Data Source={path}\Marketplace.Dal\marketplace.db");
            _connection.Open();
        }

        public void Dispose()
        {
            _connection.Dispose();
        }

        public async Task<User[]> GetUsersAsync()
        {
            await using var command = new SqliteCommand(
                "SELECT U.Id, U.Username, COUNT(O.Id) AS Offers\r\n" +
                "FROM User U LEFT JOIN Offer O ON U.Id = O.UserId\r\n" +
                "GROUP BY U.Id, U.Username;",
                _connection);

            try
            {
                await using var reader = await command.ExecuteReaderAsync();


                var results = new List<User>();

                while (await reader.ReadAsync())
                {
                    var user = new User
                    {
                        Id = reader.GetInt32(reader.GetOrdinal("Id")),
                        Username = reader.GetString(reader.GetOrdinal("Username"))
                    };

                    results.Add(user);
                }

                return results.ToArray();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }
    }
}
