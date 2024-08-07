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
        List<Address> addresses = new List<Address>();

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            using (SqlCommand command = new SqlCommand("GetAllAddresses", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                await connection.OpenAsync();
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        Address address = new Address
                        {

                            AddressID = (int)reader["AddressID"],

                            Name = reader["Name"].ToString(),
                            Street = reader["Street"].ToString(),
                            Area = reader["Area"].ToString(),
                            City = reader["City"].ToString(),
                            State = reader["State"].ToString(),
                            PostalCode = reader["PostalCode"].ToString(),
                            Country = reader["Country"].ToString(),
                            Latitude = reader["Latitude"] != DBNull.Value ? (decimal)reader["Latitude"] : (decimal?)null,
                            Longitude = reader["Longitude"] != DBNull.Value ? (decimal)reader["Longitude"] : (decimal?)null,
                            CreatedBy = (int)reader["CreatedBy"],
                            CreatedAt = (DateTime)reader["CreatedAt"],
                            UpdatedBy = (int)reader["UpdatedBy"],
                            UpdatedAt = (DateTime)reader["UpdatedAt"]
                        };
                        addresses.Add(address);
                    }
                }
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
                 
                    command.Parameters.AddWithValue("@City", address.City);
                    command.Parameters.AddWithValue("@State", address.State);
                    command.Parameters.AddWithValue("@PostalCode", address.PostalCode);
                    command.Parameters.AddWithValue("@Country", address.Country);
                    command.Parameters.AddWithValue("@Latitude", address.Latitude ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@Longitude", address.Longitude ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@CreatedBy", address.CreatedBy);
                    command.Parameters.AddWithValue("@CreatedAt", address.CreatedAt);
                    command.Parameters.AddWithValue("@UpdatedBy", address.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", address.UpdatedAt);
                    command.Parameters.AddWithValue("@Name", address.Name);
                    command.Parameters.AddWithValue("@Area", address.Area);

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
                    command.Parameters.AddWithValue("@Area", address.Area);
                    command.Parameters.AddWithValue("@City", address.City);
                    command.Parameters.AddWithValue("@State", address.State);
                    command.Parameters.AddWithValue("@PostalCode", address.PostalCode);
                    command.Parameters.AddWithValue("@Country", address.Country);
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
                                Name = reader["Street"].ToString(),
                                Street = reader["Street"].ToString(),
                                Area = reader["Area"].ToString(),
                                City = reader["City"].ToString(),
                                State = reader["State"].ToString(),
                                PostalCode = reader["PostalCode"].ToString(),
                                Country = reader["Country"].ToString(),
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
