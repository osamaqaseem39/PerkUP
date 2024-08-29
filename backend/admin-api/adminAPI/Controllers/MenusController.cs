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
public class MenusController : ControllerBase
{
    private readonly string _connectionString;

    public MenusController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    // GET: api/menus
    [Authorize]
    [HttpGet]
    public async Task<IActionResult> GetAllMenus()
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("GetAllMenus", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        var menus = new List<Menu>();
                        while (await reader.ReadAsync())
                        {
                            menus.Add(new Menu
                            {
                                MenuID = reader.GetInt32(reader.GetOrdinal("MenuID")),
                                MenuName = reader.GetString(reader.GetOrdinal("MenuName")),
                                Description = reader.IsDBNull(reader.GetOrdinal("Description")) ? null : reader.GetString(reader.GetOrdinal("Description")),
                                Image = reader.IsDBNull(reader.GetOrdinal("Image")) ? null : reader.GetString(reader.GetOrdinal("Image")),
                                IsActive = reader.GetBoolean(reader.GetOrdinal("IsActive")),
                                CreatedBy = reader.GetInt32(reader.GetOrdinal("CreatedBy")),
                                CreatedAt = reader.GetDateTime(reader.GetOrdinal("CreatedAt")),
                                UpdatedBy = reader.GetInt32(reader.GetOrdinal("UpdatedBy")),
                                UpdatedAt = reader.GetDateTime(reader.GetOrdinal("UpdatedAt")),
                            });
                        }

                        return Ok(menus);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    // GET: api/menus/{id}
    [Authorize]
    [HttpGet("{id}")]
    public async Task<IActionResult> GetMenuById(int id)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("GetMenuById", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@MenuID", id);

                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (!await reader.ReadAsync())
                        {
                            return NotFound("Menu not found.");
                        }

                        var menu = new Menu
                        {
                            MenuID = reader.GetInt32(reader.GetOrdinal("MenuID")),
                            MenuName = reader.GetString(reader.GetOrdinal("MenuName")),
                            Description = reader.IsDBNull(reader.GetOrdinal("Description")) ? null : reader.GetString(reader.GetOrdinal("Description")),
                            Image = reader.IsDBNull(reader.GetOrdinal("Image")) ? null : reader.GetString(reader.GetOrdinal("Image")),
                            IsActive = reader.GetBoolean(reader.GetOrdinal("IsActive")),
                            CreatedBy = reader.GetInt32(reader.GetOrdinal("CreatedBy")),
                            CreatedAt = reader.GetDateTime(reader.GetOrdinal("CreatedAt")),
                            UpdatedBy = reader.GetInt32(reader.GetOrdinal("UpdatedBy")),
                            UpdatedAt = reader.GetDateTime(reader.GetOrdinal("UpdatedAt")),
                        };

                        // Read MenuItems
                        reader.NextResult(); // Move to the next result set
                        var menuItems = new List<MenuItem>();
                        while (await reader.ReadAsync())
                        {
                            menuItems.Add(new MenuItem
                            {
                                MenuItemID = reader.GetInt32(reader.GetOrdinal("MenuItemID")),
                                MenuID = reader.GetInt32(reader.GetOrdinal("MenuID")),
                                ItemName = reader.GetString(reader.GetOrdinal("ItemName")),
                                Description = reader.IsDBNull(reader.GetOrdinal("Description")) ? null : reader.GetString(reader.GetOrdinal("Description")),
                                Image = reader.IsDBNull(reader.GetOrdinal("Image")) ? null : reader.GetString(reader.GetOrdinal("Image")),
                                Price = reader.GetDecimal(reader.GetOrdinal("Price")),
                                Discount = reader.GetDecimal(reader.GetOrdinal("Discount")),
                                IsPercentageDiscount = reader.GetBoolean(reader.GetOrdinal("IsPercentageDiscount")),
                                IsActive = reader.GetBoolean(reader.GetOrdinal("IsActive")),
                                CreatedBy = reader.GetInt32(reader.GetOrdinal("CreatedBy")),
                                CreatedAt = reader.GetDateTime(reader.GetOrdinal("CreatedAt")),
                                UpdatedBy = reader.GetInt32(reader.GetOrdinal("UpdatedBy")),
                                UpdatedAt = reader.GetDateTime(reader.GetOrdinal("UpdatedAt")),
                            });
                        }

                        menu.MenuItems = menuItems;
                        return Ok(menu);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    // POST: api/menus
    [Authorize]
    [HttpPost]
    public async Task<IActionResult> CreateMenu([FromBody] Menu menu)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                // Create DataTable for Menu
                DataTable menuTable = new DataTable();
                menuTable.Columns.Add("MenuID", typeof(int));
                menuTable.Columns.Add("MenuName", typeof(string));
                menuTable.Columns.Add("Description", typeof(string));
                menuTable.Columns.Add("Image", typeof(string));
                menuTable.Columns.Add("IsActive", typeof(bool));
                menuTable.Columns.Add("CreatedBy", typeof(int));
                menuTable.Columns.Add("CreatedAt", typeof(DateTime));
                menuTable.Columns.Add("UpdatedBy", typeof(int));
                menuTable.Columns.Add("UpdatedAt", typeof(DateTime));

                menuTable.Rows.Add(menu.MenuID, menu.MenuName, menu.Description, menu.Image, menu.IsActive, menu.CreatedBy, menu.CreatedAt, menu.UpdatedBy, menu.UpdatedAt);

                // Create DataTable for MenuItems
                DataTable menuItemTable = new DataTable();
                menuItemTable.Columns.Add("MenuItemID", typeof(int));
                menuItemTable.Columns.Add("MenuID", typeof(int));
                menuItemTable.Columns.Add("ItemName", typeof(string));
                menuItemTable.Columns.Add("Description", typeof(string));
                menuItemTable.Columns.Add("Image", typeof(string));
                menuItemTable.Columns.Add("Price", typeof(decimal));
                menuItemTable.Columns.Add("Discount", typeof(decimal));
                menuItemTable.Columns.Add("IsPercentageDiscount", typeof(bool));
                menuItemTable.Columns.Add("IsActive", typeof(bool));
                menuItemTable.Columns.Add("Category", typeof(string));
                menuItemTable.Columns.Add("CreatedBy", typeof(int));
                menuItemTable.Columns.Add("CreatedAt", typeof(DateTime));
                menuItemTable.Columns.Add("UpdatedBy", typeof(int));
                menuItemTable.Columns.Add("UpdatedAt", typeof(DateTime));

                foreach (var item in menu.MenuItems)
                {
                    menuItemTable.Rows.Add(item.MenuItemID, item.MenuID, item.ItemName, item.Description, item.Image, item.Price, item.Discount, item.IsPercentageDiscount, item.IsActive, item.Category, item.CreatedBy, item.CreatedAt, item.UpdatedBy, item.UpdatedAt);
                }

                using (SqlCommand command = new SqlCommand("CreateMenu", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@MenuTable", menuTable).SqlDbType = SqlDbType.Structured;
                    command.Parameters.AddWithValue("@MenuItemTable", menuItemTable).SqlDbType = SqlDbType.Structured;

                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Menu and items created successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    // PUT: api/menus/{id}
    [Authorize]
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateMenu(int id, [FromBody] Menu menu)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                // Create DataTable for Menu
                DataTable menuTable = new DataTable();
                menuTable.Columns.Add("MenuID", typeof(int));
                menuTable.Columns.Add("MenuName", typeof(string));
                menuTable.Columns.Add("Description", typeof(string));
                menuTable.Columns.Add("Image", typeof(string));
                menuTable.Columns.Add("IsActive", typeof(bool));
                menuTable.Columns.Add("CreatedBy", typeof(int));
                menuTable.Columns.Add("CreatedAt", typeof(DateTime));
                menuTable.Columns.Add("UpdatedBy", typeof(int));
                menuTable.Columns.Add("UpdatedAt", typeof(DateTime));

                menuTable.Rows.Add(menu.MenuID, menu.MenuName, menu.Description, menu.Image, menu.IsActive, menu.CreatedBy, menu.CreatedAt, menu.UpdatedBy, menu.UpdatedAt);

                // Create DataTable for MenuItems
                DataTable menuItemTable = new DataTable();
                menuItemTable.Columns.Add("MenuItemID", typeof(int));
                menuItemTable.Columns.Add("MenuID", typeof(int));
                menuItemTable.Columns.Add("ItemName", typeof(string));
                menuItemTable.Columns.Add("Description", typeof(string));
                menuItemTable.Columns.Add("Image", typeof(string));
                menuItemTable.Columns.Add("Price", typeof(decimal));
                menuItemTable.Columns.Add("Discount", typeof(decimal));
                menuItemTable.Columns.Add("IsPercentageDiscount", typeof(bool));
                menuItemTable.Columns.Add("IsActive", typeof(bool));
                menuItemTable.Columns.Add("Category", typeof(string));
                menuItemTable.Columns.Add("CreatedBy", typeof(int));
                menuItemTable.Columns.Add("CreatedAt", typeof(DateTime));
                menuItemTable.Columns.Add("UpdatedBy", typeof(int));
                menuItemTable.Columns.Add("UpdatedAt", typeof(DateTime));

                foreach (var item in menu.MenuItems)
                {
                    menuItemTable.Rows.Add(item.MenuItemID, item.MenuID, item.ItemName, item.Description, item.Image, item.Price, item.Discount, item.IsPercentageDiscount, item.IsActive, item.Category, item.CreatedBy, item.CreatedAt, item.UpdatedBy, item.UpdatedAt);
                }

                using (SqlCommand command = new SqlCommand("UpdateMenu", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@MenuID", id);
                    command.Parameters.AddWithValue("@MenuTable", menuTable).SqlDbType = SqlDbType.Structured;
                    command.Parameters.AddWithValue("@MenuItemTable", menuItemTable).SqlDbType = SqlDbType.Structured;

                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("Menu and items updated successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    // DELETE: api/menus/{id}
    [Authorize]
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteMenu(int id)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();

                using (SqlCommand command = new SqlCommand("DeleteMenu", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@MenuID", id);

                    var rowsAffected = await command.ExecuteNonQueryAsync();
                    if (rowsAffected == 0)
                    {
                        return NotFound("Menu not found.");
                    }

                    return Ok("Menu deleted successfully.");
                }
            }
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }
}
