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
public class CountriesController : ControllerBase
{
    private readonly string _connectionString;

    public CountriesController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    [Authorize]
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Country>>> GetCountries()
    {
        List<Country> countries = new List<Country>();

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            using (SqlCommand command = new SqlCommand("GetAllCountries", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                await connection.OpenAsync();
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        Country country = new Country
                        {
                            CountryID = (int)reader["CountryID"],
                            CountryName = reader["CountryName"].ToString(),
                            CreatedBy = (int)reader["CreatedBy"],
                            CreatedAt = (DateTime)reader["CreatedAt"],
                            UpdatedBy = (int)reader["UpdatedBy"],
                            UpdatedAt = (DateTime)reader["UpdatedAt"]
                        };
                        countries.Add(country);
                    }
                }
            }
        }

        return countries;
    }

    [Authorize]
    [HttpPost]
    public async Task<IActionResult> CreateCountry([FromBody] Country country)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("CreateCountry", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@CountryName", country.CountryName);
                    command.Parameters.AddWithValue("@CreatedBy", country.CreatedBy);
                    command.Parameters.AddWithValue("@CreatedAt", country.CreatedAt);
                    command.Parameters.AddWithValue("@UpdatedBy", country.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", country.UpdatedAt);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Country created successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [Authorize]
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateCountry(int id, [FromBody] Country country)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("UpdateCountry", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@CountryID", id);
                    command.Parameters.AddWithValue("@CountryName", country.CountryName);

                    command.Parameters.AddWithValue("@UpdatedBy", country.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", country.UpdatedAt);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Country updated successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [Authorize]
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteCountry(int id)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("DeleteCountry", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@CountryID", id);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Country deleted successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<IActionResult> GetCountryById(int id)
    {
        try
        {
            Country country;
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("GetCountryById", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@CountryId", id);

                    await connection.OpenAsync();
                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            country = new Country
                            {
                                CountryID = Convert.ToInt32(reader["CountryID"]),
                                CountryName = reader["CountryName"].ToString(),
                                CreatedBy = Convert.ToInt32(reader["CreatedBy"]),
                                CreatedAt = Convert.ToDateTime(reader["CreatedAt"]),
                                UpdatedBy = Convert.ToInt32(reader["UpdatedBy"]),
                                UpdatedAt = Convert.ToDateTime(reader["UpdatedAt"])
                            };

                            return Ok(country);
                        }
                        else
                        {
                            return NotFound("Country not found.");
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
