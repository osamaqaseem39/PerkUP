using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

[ApiController]
[Route("api/[controller]")]
public class UsersController : ControllerBase
{
    private readonly string _connectionString;

    public UsersController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }
    [Authorize]
    [HttpGet]
    public async Task<ActionResult<IEnumerable<User>>> GetUsers()
    {
        List<User> users = new List<User>();

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            using (SqlCommand command = new SqlCommand("GetAllUsers", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                await connection.OpenAsync();
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        User user = new User
                        {
                            UserID = (int)reader["UserID"],
                            UserType = reader["UserType"].ToString(),
                            Username = reader["Username"].ToString(),
                            DisplayName = reader["DisplayName"].ToString(),
                            FirstName = reader["FirstName"].ToString(),
                            LastName = reader["LastName"].ToString(),
                            UserEmail = reader["UserEmail"].ToString(),
                            UserContact = reader["UserContact"].ToString(),
                            Password = reader["Password"].ToString(),
                            Images = reader["Images"].ToString(),
                            RoleID = reader["RoleID"] != DBNull.Value ? (int?)reader["RoleID"] : null,
                            Description = reader["Description"].ToString(),
                            AddressID = reader["AddressID"] != DBNull.Value ? (int?)reader["AddressID"] : null,
                            CreatedBy = (int)reader["CreatedBy"],
                            CreatedAt = (DateTime)reader["CreatedAt"],
                            UpdatedBy = (int)reader["UpdatedBy"],
                            UpdatedAt = (DateTime)reader["UpdatedAt"]
                        };
                        users.Add(user);
                    }
                }
            }
        }

        return users;
    }
    [Authorize]
    [HttpPost]
    public async Task<IActionResult> CreateUser(User user)
    {
        try
        { 
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                SqlCommand command = new SqlCommand("CreateUser", connection);
                command.CommandType = CommandType.StoredProcedure;

                // Add parameters
                command.Parameters.AddWithValue("@UserType", user.UserType);
                command.Parameters.AddWithValue("@Username", user.Username);
                command.Parameters.AddWithValue("@DisplayName", user.DisplayName);
                command.Parameters.AddWithValue("@FirstName", user.FirstName);
                command.Parameters.AddWithValue("@LastName", user.LastName);
                command.Parameters.AddWithValue("@UserEmail", user.UserEmail);
                command.Parameters.AddWithValue("@UserContact", user.UserContact);
                command.Parameters.AddWithValue("@Password", PasswordHasher.HashPassword(user.Password)); // Hash password
                command.Parameters.AddWithValue("@Images", user.Images);
                command.Parameters.AddWithValue("@Description", user.Description);
                command.Parameters.AddWithValue("@CreatedBy", user.CreatedBy);
                command.Parameters.AddWithValue("@CreatedAt", user.CreatedAt);
                command.Parameters.AddWithValue("@UpdatedBy", user.UpdatedBy);
                command.Parameters.AddWithValue("@UpdatedAt", user.UpdatedAt);
                command.Parameters.AddWithValue("@RoleID", user.RoleID);
                command.Parameters.AddWithValue("@AddressID", user.AddressID);

                // Open connection and execute the command
                await connection.OpenAsync();
                int userId = Convert.ToInt32(await command.ExecuteScalarAsync());

                return Ok($"User created successfully with ID: {userId}");
            }
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    [Authorize]
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateUser(int id, User user)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                SqlCommand command = new SqlCommand("UpdateUser", connection);
                command.CommandType = CommandType.StoredProcedure;

                // Add parameters
                command.Parameters.AddWithValue("@UserID", id);
                command.Parameters.AddWithValue("@UserType", user.UserType);
                command.Parameters.AddWithValue("@Username", user.Username);
                command.Parameters.AddWithValue("@DisplayName", user.DisplayName);
                command.Parameters.AddWithValue("@FirstName", user.FirstName);
                command.Parameters.AddWithValue("@LastName", user.LastName);
                command.Parameters.AddWithValue("@UserEmail", user.UserEmail);
                command.Parameters.AddWithValue("@UserContact", user.UserContact);
                command.Parameters.AddWithValue("@Password", PasswordHasher.HashPassword(user.Password)); // Hash password
                command.Parameters.AddWithValue("@RoleID", user.RoleID);
                command.Parameters.AddWithValue("@AddressID", user.AddressID);

                // Open connection and execute the command
                await connection.OpenAsync();
                int rowsAffected = await command.ExecuteNonQueryAsync();

                if (rowsAffected > 0)
                    return Ok($"User with ID: {id} updated successfully.");
                else
                    return NotFound($"User with ID: {id} not found.");
            }
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }
    [Authorize] 
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteUser(int id)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("DeleteUser", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@UserID", id);

                    await connection.OpenAsync();
                    await command.ExecuteNonQueryAsync();
                }
            }

            return Ok("User deleted successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }
    [Authorize]
    [HttpGet("{id}")]
    public async Task<IActionResult> GetUserById(int id)
    {
        try
        {
            User user;
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("GetUserById", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@UserID", id);

                    await connection.OpenAsync();
                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        if (await reader.ReadAsync())
                        {
                            user = new User
                            {
                                UserID = Convert.ToInt32(reader["UserID"]),
                                UserType = reader["UserType"].ToString(),
                                Username = reader["Username"].ToString(),
                                DisplayName = reader["DisplayName"].ToString(),
                                FirstName = reader["FirstName"].ToString(),
                                LastName = reader["LastName"].ToString(),
                                UserEmail = reader["UserEmail"].ToString(),
                                UserContact = reader["UserContact"].ToString(),
                                Password = reader["Password"].ToString(),
                                Images = reader["Images"].ToString(),
                                RoleID = reader["RoleID"] != DBNull.Value ? (int?)reader["RoleID"] : null,
                                Description = reader["Description"].ToString(),
                                AddressID = reader["AddressID"] != DBNull.Value ? (int?)reader["AddressID"] : null,
                                CreatedBy = Convert.ToInt32(reader["CreatedBy"]),
                                CreatedAt = Convert.ToDateTime(reader["CreatedAt"]),
                                UpdatedBy = Convert.ToInt32(reader["UpdatedBy"]),
                                UpdatedAt = Convert.ToDateTime(reader["UpdatedAt"])
                            };

                            return Ok(user);
                        }
                        else
                        {
                            return NotFound("User not found.");
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
