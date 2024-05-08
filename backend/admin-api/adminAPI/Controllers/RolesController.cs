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

    private async Task<List<RolePermission>> GetRolePermissions(int roleId)
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

}
