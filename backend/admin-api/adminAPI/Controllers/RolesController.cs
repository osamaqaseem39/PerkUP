    using Microsoft.AspNetCore.Mvc;
    using Microsoft.Extensions.Configuration;
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
        public async Task<ActionResult<IEnumerable<RoleDTO>>> GetRoles()
        {
            List<RoleDTO> roles = new List<RoleDTO>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("GetRoles", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    await connection.OpenAsync();
                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            RoleDTO role = new RoleDTO
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

        private async Task<List<RolePermissionDTO>> GetRolePermissions(int roleId)
        {
            List<RolePermissionDTO> rolePermissions = new List<RolePermissionDTO>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                using (SqlCommand command = new SqlCommand("GetRolePermissions", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddWithValue("@RoleId", roleId);
                    await connection.OpenAsync();
                    using (SqlDataReader reader = await command.ExecuteReaderAsync())
                    {
                        while (await reader.ReadAsync())
                        {
                            RolePermissionDTO rolePermission = new RolePermissionDTO
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
        public async Task<IActionResult> CreateRole([FromBody] RoleDTO role)
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

                        await connection.OpenAsync();
                        await command.ExecuteNonQueryAsync();
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
        public async Task<IActionResult> GetRoleById(int id)
        {
            try
            {
                RoleDTO role;
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand command = new SqlCommand("GetRoleById", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@RoleId", id);

                        await connection.OpenAsync();
                        using (SqlDataReader reader = await command.ExecuteReaderAsync())
                        {
                            if (await reader.ReadAsync())
                            {
                                role = new RoleDTO
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

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateRole(int id, [FromBody] RoleDTO role)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand command = new SqlCommand("UpdateRole", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@RoleId", id);
                        command.Parameters.AddWithValue("@RoleName", role.RoleName);
                        command.Parameters.AddWithValue("@Description", role.Description);
                        command.Parameters.AddWithValue("@UpdatedBy", role.UpdatedBy);
                        command.Parameters.AddWithValue("@UpdatedAt", role.UpdatedAt);

                        await connection.OpenAsync();
                        await command.ExecuteNonQueryAsync();
                    }
                }

                return Ok("Role updated successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred: {ex.Message}");
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteRole(int id)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(_connectionString))
                {
                    using (SqlCommand command = new SqlCommand("DeleteRole", connection))
                    {
                        command.CommandType = CommandType.StoredProcedure;
                        command.Parameters.AddWithValue("@RoleId", id);

                        await connection.OpenAsync();
                        await command.ExecuteNonQueryAsync();
                    }
                }

                return Ok("Role deleted successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"An error occurred: {ex.Message}");
            }
        }
    }
