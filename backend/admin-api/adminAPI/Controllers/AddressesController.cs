using adminAPI.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

[ApiController]
[Route("api/[controller]")]
public class AddressesController : ControllerBase
{
    private readonly string _connectionString;

    public AddressesController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }
    [Authorize]
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Address>>> GetAddresses()
    {
        var addresses = new List<Address>();
        var cities = new List<City>();
        var countries = new List<Country>();
        var areas = new List<Area>();

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            await connection.OpenAsync();

            // Get Addresses
            using (SqlCommand command = new SqlCommand("GetAllAddresses", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        addresses.Add(new Address
                        {
                            AddressID = (int)reader["AddressID"],
                            Name = reader["Name"].ToString(),
                            Street = reader["Street"].ToString(),
                            AreaID = reader["AreaID"] != DBNull.Value ? (int)reader["AreaID"] : (int?)null,
                            CityID = reader["CityID"] != DBNull.Value ? (int)reader["CityID"] : (int?)null,
                            State = reader["State"].ToString(),
                            PostalCode = reader["PostalCode"].ToString(),
                            CountryID = reader["CountryID"] != DBNull.Value ? (int)reader["CountryID"] : (int?)null,
                            Latitude = reader["Latitude"] != DBNull.Value ? (decimal)reader["Latitude"] : (decimal?)null,
                            Longitude = reader["Longitude"] != DBNull.Value ? (decimal)reader["Longitude"] : (decimal?)null,
                            CreatedBy = Convert.ToInt32(reader["CreatedBy"]),
                            CreatedAt = Convert.ToDateTime(reader["CreatedAt"]),
                            UpdatedBy = Convert.ToInt32(reader["UpdatedBy"]),
                            UpdatedAt = Convert.ToDateTime(reader["UpdatedAt"]),
                            City = string.Empty, // Placeholder for City
                            Country = string.Empty, // Placeholder for Country
                            Area = string.Empty // Placeholder for Area
                        });
                    }
                }
            }

            // Get Cities
            using (SqlCommand command = new SqlCommand("GetAllCities", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        cities.Add(new City
                        {
                            CityID = (int)reader["CityID"],
                            CityName = reader["CityName"].ToString()
                        });
                    }
                }
            }

            // Get Countries
            using (SqlCommand command = new SqlCommand("GetAllCountries", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        countries.Add(new Country
                        {
                            CountryID = (int)reader["CountryID"],
                            CountryName = reader["CountryName"].ToString()
                        });
                    }
                }
            }

            // Get Areas
            using (SqlCommand command = new SqlCommand("GetAllAreas", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        areas.Add(new Area
                        {
                            AreaID = (int)reader["AreaID"],
                            AreaName = reader["AreaName"].ToString()
                        });
                    }
                }
            }

            // Map City, Country, and Area to Address
            foreach (var address in addresses)
            {
                var city = cities.FirstOrDefault(c => c.CityID == address.CityID);
                var country = countries.FirstOrDefault(c => c.CountryID == address.CountryID);
                var area = areas.FirstOrDefault(a => a.AreaID == address.AreaID);

                if (city != null) address.City = city.CityName;
                if (country != null) address.Country = country.CountryName;
                if (area != null) address.Area = area.AreaName;
            }
        }

        return addresses;
    }


    [Authorize]
    [HttpPost]
    public async Task<IActionResult> CreateAddress([FromBody] Address address)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("CreateAddress", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    
                    command.Parameters.AddWithValue("@Street", address.Street);
                 
                    command.Parameters.AddWithValue("@CityID", address.CityID);
                    command.Parameters.AddWithValue("@State", address.State);
                    command.Parameters.AddWithValue("@PostalCode", address.PostalCode);
                    command.Parameters.AddWithValue("@CountryID", address.CountryID);
                    command.Parameters.AddWithValue("@Latitude", address.Latitude ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@Longitude", address.Longitude ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@CreatedBy", address.CreatedBy);
                    command.Parameters.AddWithValue("@CreatedAt", address.CreatedAt);
                    command.Parameters.AddWithValue("@UpdatedBy", address.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", address.UpdatedAt);
                    command.Parameters.AddWithValue("@Name", address.Name);
                    command.Parameters.AddWithValue("@AreaID", address.AreaID);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Address created successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }
    [Authorize]
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateAddress(int id, [FromBody] Address address)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("UpdateAddress", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@AddressID", id);

                    command.Parameters.AddWithValue("@Name", address.Name);
                    command.Parameters.AddWithValue("@Street", address.Street);
                    command.Parameters.AddWithValue("@AreaID", address.AreaID);
                    command.Parameters.AddWithValue("@CityID", address.CityID);
                    command.Parameters.AddWithValue("@State", address.State);
                    command.Parameters.AddWithValue("@PostalCode", address.PostalCode);
                    command.Parameters.AddWithValue("@CountryID", address.CountryID);
                    command.Parameters.AddWithValue("@Latitude", address.Latitude ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@Longitude", address.Longitude ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@UpdatedBy", address.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", address.UpdatedAt);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Address updated successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }


    [Authorize]
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteAddress(int id)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("DeleteAddress", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@AddressID", id);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Address deleted successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }
    [Authorize]
    [HttpGet("{id}")]
    public async Task<IActionResult> GetAddressById(int id)
    {
        try
        {
            Address address;
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("GetAddressById", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@AddressId", id);

                    await connection.OpenAsync();
                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            address = new Address
                            {
                                AddressID = Convert.ToInt32(reader["AddressID"]),
                                Name = reader["Name"].ToString(),
                                Street = reader["Street"].ToString(),
                                AreaID = (int)reader["AreaID"],
                                CityID = (int)reader["CityID"],
                                State = reader["State"].ToString(),
                                PostalCode = reader["PostalCode"].ToString(),
                                CountryID = (int)reader["CountryID"],
                                Latitude = reader["Latitude"] != DBNull.Value ? (decimal)reader["Latitude"] : (decimal?)null,
                                Longitude = reader["Longitude"] != DBNull.Value ? (decimal)reader["Longitude"] : (decimal?)null,
                                CreatedBy = Convert.ToInt32(reader["CreatedBy"]),
                                CreatedAt = Convert.ToDateTime(reader["CreatedAt"]),
                                UpdatedBy = Convert.ToInt32(reader["UpdatedBy"]),
                                UpdatedAt = Convert.ToDateTime(reader["UpdatedAt"])
                            };

                            return Ok(address);
                        }
                        else
                        {
                            return NotFound("Address not found.");
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

}
