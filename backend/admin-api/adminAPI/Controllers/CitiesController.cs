using adminAPI.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

namespace adminAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CitiesController : ControllerBase
    {
        private readonly string _connectionString;

        public CitiesController(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        [Authorize]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<City>>> GetCities()
        {
            List<City> cities = new List<City>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("GetAllCities", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    await connection.OpenAsync();
                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            City city = new City
                            {
                                CityID = (int)reader["CityID"],
                                CityName = reader["CityName"].ToString(),
                                CountryId = (int)reader["CountryId"],
                                CreatedBy = (int)reader["CreatedBy"],
                                CreatedAt = (DateTime)reader["CreatedAt"],
                                UpdatedBy = (int)reader["UpdatedBy"],
                                UpdatedAt = (DateTime)reader["UpdatedAt"]
                            };
                            cities.Add(city);
                        }
                    }
                }
            }

            return cities;
        }

        [Authorize]
        [HttpPost]
        public async Task<IActionResult> CreateCity([FromBody] City city)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand command = new SqlCommand("CreateCity", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@CityName", city.CityName);
                        command.Parameters.AddWithValue("@CountryId", city.CountryId);
                        command.Parameters.AddWithValue("@CreatedBy", city.CreatedBy);
                        command.Parameters.AddWithValue("@CreatedAt", city.CreatedAt);
                        command.Parameters.AddWithValue("@UpdatedBy", city.UpdatedBy);
                        command.Parameters.AddWithValue("@UpdatedAt", city.UpdatedAt);

                        await connection.OpenAsync();
                        await command.ExecuteNonQueryAsync();
                    }
                }

                return Ok("City created successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred: {ex.Message}");
            }
        }

        [Authorize]
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateCity(int id, [FromBody] City city)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand command = new SqlCommand("UpdateCity", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@CityID", id);
                        command.Parameters.AddWithValue("@CityName", city.CityName);
                        command.Parameters.AddWithValue("@CountryId", city.CountryId);
                        command.Parameters.AddWithValue("@UpdatedBy", city.UpdatedBy);
                        command.Parameters.AddWithValue("@UpdatedAt", city.UpdatedAt);

                        await connection.OpenAsync();
                        await command.ExecuteNonQueryAsync();
                    }
                }

                return Ok("City updated successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred: {ex.Message}");
            }
        }

        [Authorize]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteCity(int id)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand command = new SqlCommand("DeleteCity", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@CityID", id);

                        await connection.OpenAsync();
                        await command.ExecuteNonQueryAsync();
                    }
                }

                return Ok("City deleted successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred: {ex.Message}");
            }
        }

        [Authorize]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetCityById(int id)
        {
            try
            {
                City city;
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand command = new SqlCommand("GetCityById", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@CityId", id);

                        await connection.OpenAsync();
                        using (SqlDataReader reader = await command.ExecuteReaderAsync())
                        {
                            if (await reader.ReadAsync())
                            {
                                city = new City
                                {
                                    CityID = Convert.ToInt32(reader["CityID"]),
                                    CityName = reader["CityName"].ToString(),
                                    CountryId = Convert.ToInt32(reader["CountryId"]),
                                    CreatedBy = Convert.ToInt32(reader["CreatedBy"]),
                                    CreatedAt = Convert.ToDateTime(reader["CreatedAt"]),
                                    UpdatedBy = Convert.ToInt32(reader["UpdatedBy"]),
                                    UpdatedAt = Convert.ToDateTime(reader["UpdatedAt"])
                                };

                                return Ok(city);
                            }
                            else
                            {
                                return NotFound("City not found.");
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
}
