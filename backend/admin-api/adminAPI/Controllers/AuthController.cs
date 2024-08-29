using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Data;
using System.Data.SqlClient;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

[ApiController]
[Route("api/auth")]
public class AuthController : ControllerBase
{
    private readonly string _connectionString;
    private readonly IConfiguration _configuration;

    public AuthController(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection");
        _configuration = configuration;
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login(LoginRequestModel loginRequest)
    {
        try
        {
            string passwordHash;
            int roleId;
            int userId;
            string displayName;

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                SqlCommand command = new SqlCommand("SELECT UserId, Password, RoleId, DisplayName FROM Users WHERE Username = @Username", connection);
                command.Parameters.AddWithValue("@Username", loginRequest.Username);

                await connection.OpenAsync();
                SqlDataReader reader = await command.ExecuteReaderAsync();

                if (reader.Read())
                {
                    userId = Convert.ToInt32(reader["UserId"]);
                    passwordHash = reader["Password"].ToString();
                    roleId = Convert.ToInt32(reader["RoleId"]);
                    displayName = reader["DisplayName"].ToString();
                }
                else
                {
                    return Unauthorized("Invalid username or password");
                }
            }

            if (!PasswordHasher.VerifyPassword(loginRequest.Password, passwordHash))
            {
                return Unauthorized("Invalid username or password");
            }

            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_configuration["Jwt:Secret"]);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(new Claim[]
                {
                    new Claim(ClaimTypes.Name, loginRequest.Username),
                    new Claim(ClaimTypes.Role, roleId.ToString())
                }),
                Expires = DateTime.UtcNow.AddHours(1),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
            };
            var token = tokenHandler.CreateToken(tokenDescriptor);
            var bearerTokenString = "Bearer " + tokenHandler.WriteToken(token);
            var tokenString = tokenHandler.WriteToken(token);

            return Ok(new { UserId = userId, DisplayName = displayName, BearerToken = bearerTokenString, Token = tokenString });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }
}
