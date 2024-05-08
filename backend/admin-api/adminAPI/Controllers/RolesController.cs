using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Threading.Tasks;

[ApiController]
[Route("api/[controller]")]
public class RolesController : ControllerBase
{
    private readonly string _connectionString;

    public RolesController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Role>>> GetRoles()
    {
        List<Role> roles = new List<Role>();

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            using (SqlCommand command = new SqlCommand("GetAllRoles", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                connection.Open();
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (reader.Read())
                    {
                        Role role = new Role
                        {
                            RoleID = (int)reader["RoleID"],
                            RoleName = reader["RoleName"].ToString(),
                            Description = reader["Description"].ToString(),
                            CreatedBy = (int)reader["CreatedBy"],
                            CreatedAt = (DateTime)reader["CreatedAt"],
                            UpdatedBy = (int)reader["UpdatedBy"],
                            UpdatedAt = (DateTime)reader["UpdatedAt"]
                        };
                        roles.Add(role);
                    }
                }
            }

            foreach (var role in roles)
            {
                role.RolePermissions = await GetRolePermissions(role.RoleID);
            }
        }

        return roles;
    }
    [HttpGet]
    public async Task<List<RolePermission>> GetRolePermissions(int roleId)
    {
        List<RolePermission> rolePermissions = new List<RolePermission>();

        using (SqlConnection connection = new SqlConnection(_connectionString))
        {
            using (SqlCommand command = new SqlCommand("GetRolePermissions", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.AddWithValue("@RoleId", roleId);
                connection.Open();
                using (SqlDataReader reader = await command.ExecuteReaderAsync())
                {
                    while (reader.Read())
                    {
                        RolePermission rolePermission = new RolePermission
                        {
                            RolePermissionID = (int)reader["RolePermissionID"],
                            PermissionID = (int)reader["PermissionID"],
                            RoleID = (int)reader["RoleID"],
                            CreatedBy = (int)reader["CreatedBy"],
                            CreatedAt = (DateTime)reader["CreatedAt"],
                            UpdatedBy = (int)reader["UpdatedBy"],
                            UpdatedAt = (DateTime)reader["UpdatedAt"]
                        };
                        rolePermissions.Add(rolePermission);
                    }
                }
            }
        }

        return rolePermissions;
    }



    [HttpPost]
    public IActionResult CreateRole([FromBody] Role role)
    {
        try
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("CreateRole", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@RoleName", role.RoleName);
                    command.Parameters.AddWithValue("@Description", role.Description);
                    command.Parameters.AddWithValue("@CreatedBy", role.CreatedBy);
                    command.Parameters.AddWithValue("@CreatedAt", role.CreatedAt);
                    command.Parameters.AddWithValue("@UpdatedBy", role.UpdatedBy);
                    command.Parameters.AddWithValue("@UpdatedAt", role.UpdatedAt);

                    connection.Open();
                    command.ExecuteNonQuery();
                }
            }

            return Ok("Role created successfully.");
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }
    [HttpGet("{id}")]
    public IActionResult GetRoleById(int id)
    {
        try
        {
            Role role;
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("GetRoleById", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@RoleId", id);

                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            role = new Role
                            {
                                RoleID = Convert.ToInt32(reader["RoleID"]),
                                RoleName = reader["RoleName"].ToString(),
                                Description = reader["Description"].ToString(),
                                CreatedBy = Convert.ToInt32(reader["CreatedBy"]),
                                CreatedAt = Convert.ToDateTime(reader["CreatedAt"]),
                                UpdatedBy = Convert.ToInt32(reader["UpdatedBy"]),
                                UpdatedAt = Convert.ToDateTime(reader["UpdatedAt"])
                            };

                            return Ok(role);
                        }
                        else
                        {
                            return NotFound("Role not found.");
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

