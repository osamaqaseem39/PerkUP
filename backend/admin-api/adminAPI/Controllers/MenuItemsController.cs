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
public class MenuItemsController : ControllerBase
{
    private readonly string _connectionString;

    public MenuItemsController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    [Authorize]
    [HttpGet]
    public async Task<ActionResult<IEnumerable<MenuItem>>> GetMenuItems()
    {
        List<MenuItem> menuItems = new List<MenuItem>();

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            using (SqlCommand command = new SqlCommand("GetAllMenuItems", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                await connection.OpenAsync();
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        MenuItem menuItem = new MenuItem
                        {
                            MenuItemID = (int)reader["MenuItemID"],
                            MenuID = (int)reader["MenuID"],
                            ItemName = reader["ItemName"].ToString(),
                            Description = reader["Description"].ToString(),
                            Price = (decimal)reader["Price"],
                            IsActive = (bool)reader["IsActive"],
                            CreatedBy = (int)reader["CreatedBy"],
                            CreatedAt = (DateTime)reader["CreatedAt"],
                            UpdatedBy = (int)reader["UpdatedBy"],
                            UpdatedAt = (DateTime)reader["UpdatedAt"]
                        };
                        menuItems.Add(menuItem);
                    }
                }
            }
        }

        return menuItems;
    }

    [Authorize]
    [HttpPost]
    public async Task<IActionResult> CreateMenuItem([FromBody] MenuItem menuItem)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("CreateMenuItem", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@MenuID", menuItem.MenuID);
                    command.Parameters.AddWithValue("@ItemName", menuItem.ItemName);
                    command.Parameters.AddWithValue("@Description", menuItem.Description);
                    command.Parameters.AddWithValue("@Price", menuItem.Price);
                    command.Parameters.AddWithValue("@IsActive", menuItem.IsActive);
                    command.Parameters.AddWithValue("@CreatedBy", menuItem.CreatedBy);
                    command.Parameters.AddWithValue("@CreatedAt", menuItem.CreatedAt);
                    command.Parameters.AddWithValue("@UpdatedBy", menuItem.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", menuItem.UpdatedAt);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Menu item created successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [Authorize]
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateMenuItem(int id, [FromBody] MenuItem menuItem)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("UpdateMenuItem", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@MenuItemID", id);
                    command.Parameters.AddWithValue("@MenuID", menuItem.MenuID);
                    command.Parameters.AddWithValue("@ItemName", menuItem.ItemName);
                    command.Parameters.AddWithValue("@Description", menuItem.Description);
                    command.Parameters.AddWithValue("@Price", menuItem.Price);
                    command.Parameters.AddWithValue("@IsActive", menuItem.IsActive);
                    command.Parameters.AddWithValue("@UpdatedBy", menuItem.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", menuItem.UpdatedAt);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Menu item updated successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [Authorize]
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteMenuItem(int id)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("DeleteMenuItem", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@MenuItemID", id);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Menu item deleted successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [Authorize]
    [HttpGet("{id}")]
    public async Task<IActionResult> GetMenuItemById(int id)
    {
        try
        {
            MenuItem menuItem;
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("GetMenuItemById", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@MenuItemID", id);

                    await connection.OpenAsync();
                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            menuItem = new MenuItem
                            {
                                MenuItemID = Convert.ToInt32(reader["MenuItemID"]),
                                MenuID = Convert.ToInt32(reader["MenuID"]),
                                ItemName = reader["ItemName"].ToString(),
                                Description = reader["Description"].ToString(),
                                Price = (decimal)reader["Price"],
                                IsActive = (bool)reader["IsActive"],
                                CreatedBy = (int)reader["CreatedBy"],
                                CreatedAt = (DateTime)reader["CreatedAt"],
                                UpdatedBy = (int)reader["UpdatedBy"],
                                UpdatedAt = (DateTime)reader["UpdatedAt"]
                            };

                            return Ok(menuItem);
                        }
                        else
                        {
                            return NotFound("Menu item not found.");
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
