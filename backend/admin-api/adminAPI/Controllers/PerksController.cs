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
public class PerksController : ControllerBase
{
    private readonly string _connectionString;

    public PerksController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }
    [Authorize]
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Perk>>> GetPerks()
    {
        List<Perk> perks = new List<Perk>();

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            using (SqlCommand command = new SqlCommand("GetAllPerks", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                await connection.OpenAsync();
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        Perk perk = new Perk
                        {
                            PerkID = (int)reader["PerkID"],
                            PerkType = (int)reader["PerkType"],
                            PerkName = reader["PerkName"].ToString(),
                            Description = reader["Description"].ToString(),
                            Value = (decimal)reader["Value"],
                            StartDate = reader["StartDate"] != DBNull.Value ? (DateTime?)reader["StartDate"] : null,
                            EndDate = reader["EndDate"] != DBNull.Value ? (DateTime?)reader["EndDate"] : null,
                            IsActive = (bool)reader["IsActive"],
                            MinPurchaseAmount = reader["MinPurchaseAmount"] != DBNull.Value ? (decimal?)reader["MinPurchaseAmount"] : null,
                            MaxDiscountAmount = reader["MaxDiscountAmount"] != DBNull.Value ? (decimal?)reader["MaxDiscountAmount"] : null,
                            CreatedBy = (int)reader["CreatedBy"],
                            CreatedAt = (DateTime)reader["CreatedAt"],
                            UpdatedBy = (int)reader["UpdatedBy"],
                            UpdatedAt = (DateTime)reader["UpdatedAt"]
                        };
                        perks.Add(perk);
                    }
                }
            }
        }

        return perks;
    }
    [Authorize]
    [HttpPost]
    public async Task<IActionResult> CreatePerk([FromBody] Perk perk)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("CreatePerk", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@PerkType", perk.PerkType);
                    command.Parameters.AddWithValue("@PerkName", perk.PerkName);
                    command.Parameters.AddWithValue("@Description", perk.Description);
                    command.Parameters.AddWithValue("@Value", perk.Value);
                    command.Parameters.AddWithValue("@StartDate", perk.StartDate ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@EndDate", perk.EndDate ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@IsActive", perk.IsActive);
                    command.Parameters.AddWithValue("@MinPurchaseAmount", perk.MinPurchaseAmount ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@MaxDiscountAmount", perk.MaxDiscountAmount ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@CreatedBy", perk.CreatedBy);
                    command.Parameters.AddWithValue("@CreatedAt", perk.CreatedAt);
                    command.Parameters.AddWithValue("@UpdatedBy", perk.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", perk.UpdatedAt);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Perk created successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdatePerk(int id, [FromBody] Perk perk)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("UpdatePerk", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@PerkID", id);
                    command.Parameters.AddWithValue("@PerkType", perk.PerkType);
                    command.Parameters.AddWithValue("@PerkName", perk.PerkName);
                    command.Parameters.AddWithValue("@Description", perk.Description);
                    command.Parameters.AddWithValue("@Value", perk.Value);
                    command.Parameters.AddWithValue("@StartDate", perk.StartDate ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@EndDate", perk.EndDate ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@IsActive", perk.IsActive);
                    command.Parameters.AddWithValue("@MinPurchaseAmount", perk.MinPurchaseAmount ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@MaxDiscountAmount", perk.MaxDiscountAmount ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@UpdatedBy", perk.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", perk.UpdatedAt);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Perk updated successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [Authorize] 
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeletePerk(int id)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("DeletePerk", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@PerkID", id);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Perk deleted successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }
    [Authorize]
    [HttpGet("{id}")]
    public async Task<IActionResult> GetPerkById(int id)
    {
        try
        {
            Perk perk;
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("GetPerkById", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@PerkID", id);

                    await connection.OpenAsync();
                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            perk = new Perk
                            {
                                PerkID = Convert.ToInt32(reader["PerkID"]),
                                PerkType = (int)reader["PerkType"],
                                PerkName = reader["PerkName"].ToString(),
                                Description = reader["Description"].ToString(),
                                Value = (decimal)reader["Value"],
                                StartDate = reader["StartDate"] != DBNull.Value ? (DateTime?)reader["StartDate"] : null,
                                EndDate = reader["EndDate"] != DBNull.Value ? (DateTime?)reader["EndDate"] : null,
                                IsActive = (bool)reader["IsActive"],
                                MinPurchaseAmount = reader["MinPurchaseAmount"] != DBNull.Value ? (decimal?)reader["MinPurchaseAmount"] : null,
                                MaxDiscountAmount = reader["MaxDiscountAmount"] != DBNull.Value ? (decimal?)reader["MaxDiscountAmount"] : null,
                                CreatedBy = (int)reader["CreatedBy"],
                                CreatedAt = (DateTime)reader["CreatedAt"],
                                UpdatedBy = (int)reader["UpdatedBy"],
                                UpdatedAt = (DateTime)reader["UpdatedAt"]
                            };

                            return Ok(perk);
                        }
                        else
                        {
                            return NotFound("Perk not found.");
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
    [Authorize]
    [HttpGet("GetPerksByPerkType/{perkType}")]
    public async Task<IActionResult> GetPerksByPerkType(int perkType)
    {
        try
        {
            List<Perk> perks = new List<Perk>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("GetPerksByPerkType", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@PerkType", perkType);

                    await connection.OpenAsync();
                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            Perk perk = new Perk
                            {
                                PerkID = Convert.ToInt32(reader["PerkID"]),
                                PerkType = Convert.ToInt32(reader["PerkType"]), // Ensure this is integer
                                PerkName = reader["PerkName"].ToString(),
                                Description = reader["Description"].ToString(),
                                Value = (decimal)reader["Value"],
                                StartDate = reader["StartDate"] != DBNull.Value ? (DateTime?)reader["StartDate"] : null,
                                EndDate = reader["EndDate"] != DBNull.Value ? (DateTime?)reader["EndDate"] : null,
                                IsActive = (bool)reader["IsActive"],
                                MinPurchaseAmount = reader["MinPurchaseAmount"] != DBNull.Value ? (decimal?)reader["MinPurchaseAmount"] : null,
                                MaxDiscountAmount = reader["MaxDiscountAmount"] != DBNull.Value ? (decimal?)reader["MaxDiscountAmount"] : null,
                                CreatedBy = (int)reader["CreatedBy"],
                                CreatedAt = (DateTime)reader["CreatedAt"],
                                UpdatedBy = (int)reader["UpdatedBy"],
                                UpdatedAt = (DateTime)reader["UpdatedAt"]
                            };

                            perks.Add(perk);
                        }
                    }
                }
            }

            if (perks.Count == 0)
            {
                return NotFound($"No perks found for the type ID: {perkType}");
            }

            return Ok(perks);
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }



}
