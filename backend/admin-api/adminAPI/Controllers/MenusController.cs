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
public class MenuController : ControllerBase
{
    private readonly string _connectionString;

    public MenuController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    [Authorize]
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Menu>>> GetMenus()
    {
        List<Menu> menus = new List<Menu>();

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            using (SqlCommand command = new SqlCommand("GetAllMenus", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                await connection.OpenAsync();
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        Menu menu = new Menu
                        {
                            MenuID = (int)reader["MenuID"],
                            MenuName = reader["MenuName"].ToString(),
                            Description = reader["Description"].ToString(),
                            Image = reader["Image"].ToString(),
                            IsActive = (bool)reader["IsActive"],
                            CreatedBy = (int)reader["CreatedBy"],
                            CreatedAt = (DateTime)reader["CreatedAt"],
                            UpdatedBy = (int)reader["UpdatedBy"],
                            UpdatedAt = (DateTime)reader["UpdatedAt"]
                        };
                        menus.Add(menu);
                    }
                }
            }
        }

        return menus;
    }

    [Authorize]
    [HttpPost]
    public async Task<IActionResult> CreateMenu([FromBody] Menu menu)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("CreateMenu", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@MenuName", menu.MenuName);
                    command.Parameters.AddWithValue("@Description", menu.Description);
                    command.Parameters.AddWithValue("@Image", menu.Image ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@IsActive", menu.IsActive);
                    command.Parameters.AddWithValue("@CreatedBy", menu.CreatedBy);
                    command.Parameters.AddWithValue("@CreatedAt", menu.CreatedAt);
                    command.Parameters.AddWithValue("@UpdatedBy", menu.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", menu.UpdatedAt);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Menu created successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [Authorize]
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateMenu(int id, [FromBody] Menu menu)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("UpdateMenuAndItems", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@MenuID", id);
                    command.Parameters.AddWithValue("@MenuName", menu.MenuName);
                    command.Parameters.AddWithValue("@Description", menu.Description);
                    command.Parameters.AddWithValue("@Image", menu.Image ?? (object)DBNull.Value);
                    command.Parameters.AddWithValue("@IsActive", menu.IsActive);
                    command.Parameters.AddWithValue("@UpdatedBy", menu.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", menu.UpdatedAt);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Menu and associated items updated successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [Authorize]
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteMenu(int id)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("DeleteMenuAndItems", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@MenuID", id);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Menu and associated items deleted successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<IActionResult> GetMenuById(int id)
    {
        try
        {
            Menu menu;
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("GetMenuById", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@MenuID", id);

                    await connection.OpenAsync();
                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            menu = new Menu
                            {
                                MenuID = Convert.ToInt32(reader["MenuID"]),
                                MenuName = reader["MenuName"].ToString(),
                                Description = reader["Description"].ToString(),
                                Image = reader["Image"].ToString(),
                                IsActive = (bool)reader["IsActive"],
                                CreatedBy = (int)reader["CreatedBy"],
                                CreatedAt = (DateTime)reader["CreatedAt"],
                                UpdatedBy = (int)reader["UpdatedBy"],
                                UpdatedAt = (DateTime)reader["UpdatedAt"]
                            };

                            return Ok(menu);
                        }
                        else
                        {
                            return NotFound("Menu not found.");
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
