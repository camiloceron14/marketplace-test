// <copyright company="ROSEN Swiss AG">
//  Copyright (c) ROSEN Swiss AG
//  This computer program includes confidential, proprietary
//  information and is a trade secret of ROSEN. All use,
//  disclosure, or reproduction is prohibited unless authorized in
//  writing by an officer of ROSEN. All Rights Reserved.
// </copyright>

using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.Data;
using System.Data.SqlTypes;
using System.IO;
using System.Linq;
using System.Net.NetworkInformation;
using System.Threading.Tasks;
using Marketplace.Core.Model;
using Microsoft.Data.Sqlite;
using Microsoft.EntityFrameworkCore;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory.Database;

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

        public async Task<User> GetUserByUsername(string username)
        {
            await using var command = new SqliteCommand(
                "SELECT U.Id, U.Username\r\n" +
                "FROM User U\r\n" +
                "WHERE U.Username = @username", _connection);
            command.CommandType = CommandType.Text;
            command.Parameters.AddWithValue("@username", username);

            try
            {
                await using var reader = await command.ExecuteReaderAsync();
                User user = null;
                if (reader.Read()) // Don't assume we have any rows.
                {
                    user = new User
                    {
                        Id = reader.GetInt32(reader.GetOrdinal("Id")),
                        Username = reader.GetString(reader.GetOrdinal("Username"))
                    };
                    return user;
                }
                return null;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }

        public async Task<List<Offer>> GetPageOffersAsync(int page, int size)
        {
            await using var command = new SqliteCommand(
                @"SELECT O.Id, O.CategoryId, O.Description, O.Location, O.PictureUrl, 
                         O.PublishedOn, O.Title, O.UserId, C.Name, U.Username
                    FROM Offer O JOIN User U ON O.UserId = u.Id 
                    JOIN Category C ON C.Id = O.CategoryId
                   LIMIT @size
                  OFFSET @page;",
                _connection);
            
            command.CommandType = CommandType.Text;
            command.Parameters.AddWithValue("@size", size);
            command.Parameters.AddWithValue("@page", page);

            try
            {
                await using var reader = await command.ExecuteReaderAsync();


                var results = new List<Offer>();

                while (await reader.ReadAsync())
                {
                    var offer = new Offer
                    {
                        Id = reader.GetGuid(reader.GetOrdinal("Id")),
                        Category = new Category { 
                            Id = reader.GetByte(reader.GetOrdinal("CategoryId")),
                            Name = reader.GetString(reader.GetOrdinal("Name"))
                        },
                        Description = reader.GetString(reader.GetOrdinal("Description")),
                        Location = reader.GetString(reader.GetOrdinal("Location")),
                        PictureUrl = reader.GetString(reader.GetOrdinal("PictureUrl")),
                        PublishedOn = reader.GetDateTime(reader.GetOrdinal("PublishedOn")),
                        Title = reader.GetString(reader.GetOrdinal("Title")),
                        User = new User
                        {
                            Id = reader.GetInt32(reader.GetOrdinal("UserId")),
                            Username = reader.GetString(reader.GetOrdinal("Username"))
                        }
                    };

                    results.Add(offer);
                }

                return results;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }

        }

        public async Task<Offer> InsertOffer(Offer offer)
        {
            offer.Id = Guid.NewGuid();
            string idOfer = offer.Id.ToString();
            await using var command = new SqliteCommand(
                @"INSERT INTO Offer (Id, CategoryId, Description, Location, PictureUrl, PublishedOn, Title, UserId)
                  VALUES (@idOfer, @CategoryId, @Description, @Location, @PictureUrl, @PublishedOn, @Title, @UserId);", _connection);
            
            command.Parameters.AddWithValue("@idOfer", idOfer);
            command.Parameters.AddWithValue("@CategoryId", offer.CategoryId);
            command.Parameters.AddWithValue("@Description", offer.Description);
            command.Parameters.AddWithValue("@Location", offer.Location);
            command.Parameters.AddWithValue("@PictureUrl", offer.PictureUrl);
            command.Parameters.AddWithValue("@PublishedOn", offer.PublishedOn);
            command.Parameters.AddWithValue("@Title", offer.Title);
            command.Parameters.AddWithValue("@UserId", offer.UserId);
            try
            {
                command.ExecuteNonQuery();
                return offer;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }

        public async Task<Category[]> GetAllCategories()
        {
            await using var command = new SqliteCommand(
                @"SELECT C.Id, C.Name
                    FROM Category C;",
                _connection);

            try
            {
                await using var reader = await command.ExecuteReaderAsync();


                var results = new List<Category>();

                while (await reader.ReadAsync())
                {
                    var category = new Category
                    {
                        Id = reader.GetByte(reader.GetOrdinal("Id")),
                        Name = reader.GetString(reader.GetOrdinal("Name"))
                    };

                    results.Add(category);
                }

                return results.ToArray();
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }

        public async Task<int> CountOffers()
        {
            await using var command = new SqliteCommand(
                @"SELECT count(Id) AS Count
                    FROM Offer;", _connection);
            try
            {
                await using var reader = await command.ExecuteReaderAsync();
                int count = 0;
                if (reader.Read()) // Don't assume we have any rows.
                {
                    count = reader.GetInt32(reader.GetOrdinal("Count"));
                }
                return count;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }

        public async Task<User> InsertUser(string username)
        {            
            await using var command = new SqliteCommand(
                @"INSERT INTO User (Username)
                  VALUES (@Username);
                  select last_insert_rowid();", _connection);

            command.Parameters.AddWithValue("@Username", username);
            try
            {
                int lastId = Convert.ToInt32(command.ExecuteScalar());
                User user = new User
                {
                    Id = lastId,
                    Username = username
                };
                return user;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                throw;
            }
        }
    }
}
