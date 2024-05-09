using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

[ApiController]
[Route("api/[controller]")]
public class PerkTypesController : ControllerBase
{
    private readonly string _connectionString;

    public PerkTypesController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<PerkType>>> GetPerkTypes()
    {
        List<PerkType> perkTypes = new List<PerkType>();

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            using (SqlCommand command = new SqlCommand("GetAllPerkTypes", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                await connection.OpenAsync();
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        PerkType perkType = new PerkType
                        {
                            PerkTypeID = (int)reader["PerkTypeID"],
                            TypeName = reader["TypeName"].ToString(),
                            Description = reader["Description"].ToString(),
                            IsActive = (bool)reader["IsActive"],
                            CreatedBy = (int)reader["CreatedBy"],
                            CreatedAt = (DateTime)reader["CreatedAt"],
                            UpdatedBy = (int)reader["UpdatedBy"],
                            UpdatedAt = (DateTime)reader["UpdatedAt"]
                        };
                        perkTypes.Add(perkType);
                    }
                }
            }
        }

        return perkTypes;
    }

    [HttpPost]
    public async Task<IActionResult> CreatePerkType([FromBody] PerkType perkType)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("CreatePerkType", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@TypeName", perkType.TypeName);
                    command.Parameters.AddWithValue("@Description", perkType.Description);
                    command.Parameters.AddWithValue("@IsActive", perkType.IsActive);
                    command.Parameters.AddWithValue("@CreatedBy", perkType.CreatedBy);
                    command.Parameters.AddWithValue("@CreatedAt", perkType.CreatedAt);
                    command.Parameters.AddWithValue("@UpdatedBy", perkType.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", perkType.UpdatedAt);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("PerkType created successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdatePerkType(int id, [FromBody] PerkType perkType)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("UpdatePerkType", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@PerkTypeID", id);
                    command.Parameters.AddWithValue("@TypeName", perkType.TypeName);
                    command.Parameters.AddWithValue("@Description", perkType.Description);
                    command.Parameters.AddWithValue("@IsActive", perkType.IsActive);
                    command.Parameters.AddWithValue("@UpdatedBy", perkType.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", perkType.UpdatedAt);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("PerkType updated successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeletePerkType(int id)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("DeletePerkType", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@PerkTypeID", id);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("PerkType deleted successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetPerkTypeById(int id)
    {
        try
        {
            PerkType perkType;
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("GetPerkTypeById", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@PerkTypeID", id);

                    await connection.OpenAsync();
                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            perkType = new PerkType
                            {
                                PerkTypeID = Convert.ToInt32(reader["PerkTypeID"]),
                                TypeName = reader["TypeName"].ToString(),
                                Description = reader["Description"].ToString(),
                                IsActive = (bool)reader["IsActive"],
                                CreatedBy = (int)reader["CreatedBy"],
                                CreatedAt = (DateTime)reader["CreatedAt"],
                                UpdatedBy = (int)reader["UpdatedBy"],
                                UpdatedAt = (DateTime)reader["UpdatedAt"]
                            };

                            return Ok(perkType);
                        }
                        else
                        {
                            return NotFound("PerkType not found.");
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
