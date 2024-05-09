using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

[ApiController]
[Route("api/[controller]")]
public class ModulesController : ControllerBase
{
    private readonly string _connectionString;

    public ModulesController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Module>>> GetModules()
    {
        List<Module> modules = new List<Module>();

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            using (SqlCommand command = new SqlCommand("GetAllModules", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                await connection.OpenAsync();
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        Module module = new Module
                        {
                            ModuleID = (int)reader["ModuleID"],
                            ModuleName = reader["ModuleName"].ToString(),
                            DescriptionSection = reader["DescriptionSection"].ToString(),
                            DisplayName = reader["DisplayName"].ToString(),
                            CreatedBy = (int)reader["CreatedBy"],
                            CreatedAt = (DateTime)reader["CreatedAt"],
                            UpdatedBy = (int)reader["UpdatedBy"],
                            UpdatedAt = (DateTime)reader["UpdatedAt"]
                        };
                        modules.Add(module);
                    }
                }
            }
        }

        return modules;
    }

    [HttpPost]
    public async Task<IActionResult> CreateModule([FromBody] Module module)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("CreateModule", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@ModuleName", module.ModuleName);
                    command.Parameters.AddWithValue("@DescriptionSection", module.DescriptionSection);
                    command.Parameters.AddWithValue("@DisplayName", module.DisplayName);
                    command.Parameters.AddWithValue("@CreatedBy", module.CreatedBy);
                    command.Parameters.AddWithValue("@CreatedAt", module.CreatedAt);
                    command.Parameters.AddWithValue("@UpdatedBy", module.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", module.UpdatedAt);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Module created successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateModule(int id, [FromBody] Module module)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("UpdateModule", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@ModuleID", id);
                    command.Parameters.AddWithValue("@ModuleName", module.ModuleName);
                    command.Parameters.AddWithValue("@DescriptionSection", module.DescriptionSection);
                    command.Parameters.AddWithValue("@DisplayName", module.DisplayName);
                    command.Parameters.AddWithValue("@UpdatedBy", module.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", module.UpdatedAt);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Module updated successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteModule(int id)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("DeleteModule", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@ModuleID", id);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Module deleted successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetModuleById(int id)
    {
        try
        {
            Module module;
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("GetModuleById", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@ModuleId", id);

                    await connection.OpenAsync();
                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            module = new Module
                            {
                                ModuleID = Convert.ToInt32(reader["ModuleID"]),
                                ModuleName = reader["ModuleName"].ToString(),
                                DescriptionSection = reader["DescriptionSection"].ToString(),
                                DisplayName = reader["DisplayName"].ToString(),
                                CreatedBy = Convert.ToInt32(reader["CreatedBy"]),
                                CreatedAt = Convert.ToDateTime(reader["CreatedAt"]),
                                UpdatedBy = Convert.ToInt32(reader["UpdatedBy"]),
                                UpdatedAt = Convert.ToDateTime(reader["UpdatedAt"])
                            };

                            return Ok(module);
                        }
                        else
                        {
                            return NotFound("Module not found.");
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
