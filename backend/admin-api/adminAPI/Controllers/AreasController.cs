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
    public class AreaController : ControllerBase
    {
        private readonly string _connectionString;

        public AreaController(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        [Authorize]
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Area>>> GetAreas()
        {
            List<Area> areas = new List<Area>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("GetAllAreas", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    await connection.OpenAsync();
                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            Area area = new Area
                            {
                                AreaID = (int)reader["AreaID"],
                                AreaName = reader["AreaName"].ToString(),
                                CityId = (int)reader["CityId"],
                                CreatedBy = (int)reader["CreatedBy"],
                                CreatedAt = (DateTime)reader["CreatedAt"],
                                UpdatedBy = (int)reader["UpdatedBy"],
                                UpdatedAt = (DateTime)reader["UpdatedAt"]
                            };
                            areas.Add(area);
                        }
                    }
                }
            }

            return areas;
        }

        [Authorize]
        [HttpPost]
        public async Task<IActionResult> CreateArea([FromBody] Area area)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand command = new SqlCommand("CreateArea", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@AreaName", area.AreaName);
                        command.Parameters.AddWithValue("@CityId", area.CityId);
                        command.Parameters.AddWithValue("@CreatedBy", area.CreatedBy);
                        command.Parameters.AddWithValue("@CreatedAt", area.CreatedAt);
                        command.Parameters.AddWithValue("@UpdatedBy", area.UpdatedBy);
                        command.Parameters.AddWithValue("@UpdatedAt", area.UpdatedAt);

                        await connection.OpenAsync();
                        await command.ExecuteNonQueryAsync();
                    }
                }

                return Ok("Area created successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred: {ex.Message}");
            }
        }

        [Authorize]
        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateArea(int id, [FromBody] Area area)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand command = new SqlCommand("UpdateArea", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@AreaID", id);
                        command.Parameters.AddWithValue("@AreaName", area.AreaName);
                        command.Parameters.AddWithValue("@CityId", area.CityId);
                        command.Parameters.AddWithValue("@UpdatedBy", area.UpdatedBy);
                        command.Parameters.AddWithValue("@UpdatedAt", area.UpdatedAt);

                        await connection.OpenAsync();
                        await command.ExecuteNonQueryAsync();
                    }
                }

                return Ok("Area updated successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred: {ex.Message}");
            }
        }

        [Authorize]
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteArea(int id)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand command = new SqlCommand("DeleteArea", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@AreaID", id);

                        await connection.OpenAsync();
                        await command.ExecuteNonQueryAsync();
                    }
                }

                return Ok("Area deleted successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred: {ex.Message}");
            }
        }

        [Authorize]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetAreaById(int id)
        {
            try
            {
                Area area;
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand command = new SqlCommand("GetAreaById", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@AreaId", id);

                        await connection.OpenAsync();
                        using (SqlDataReader reader = await command.ExecuteReaderAsync())
                        {
                            if (await reader.ReadAsync())
                            {
                                area = new Area
                                {
                                    AreaID = Convert.ToInt32(reader["AreaID"]),
                                    AreaName = reader["AreaName"].ToString(),
                                    CityId = Convert.ToInt32(reader["CityId"]),
                                    CreatedBy = Convert.ToInt32(reader["CreatedBy"]),
                                    CreatedAt = Convert.ToDateTime(reader["CreatedAt"]),
                                    UpdatedBy = Convert.ToInt32(reader["UpdatedBy"]),
                                    UpdatedAt = Convert.ToDateTime(reader["UpdatedAt"])
                                };

                                return Ok(area);
                            }
                            else
                            {
                                return NotFound("Area not found.");
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
