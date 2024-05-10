using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.Data;
using System.Data.SqlClient;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

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
            int roleId = 0;

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                SqlCommand command = new SqlCommand("AuthenticateUser", connection);
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.AddWithValue("@Username", loginRequest.Username);
                command.Parameters.AddWithValue("@Password", loginRequest.Password); // Pass the password directly

                await connection.OpenAsync();
                SqlDataReader reader = await command.ExecuteReaderAsync();

                if (reader.Read())
                {
                    roleId = reader["RoleID"] != DBNull.Value ? Convert.ToInt32(reader["RoleID"]) : 0;
                }
                else
                {
                    return Unauthorized("Invalid username or password");
                }
            }

            if (roleId == 0)
            {
                return Unauthorized("Role ID not found for the user");
            }

            // Generate JWT token
            var tokenString = GenerateJwtToken(loginRequest.Username, roleId);

            return Ok(new { Token = tokenString });
        }
        catch (Exception ex)
        {
            return StatusCode(500, $"An error occurred: {ex.Message}");
        }
    }

    private string GenerateJwtToken(string username, int roleId)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var key = Encoding.ASCII.GetBytes(_configuration["Jwt:Secret"]);
        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity(new Claim[]
            {
                new Claim(ClaimTypes.Name, username),
                new Claim(ClaimTypes.Role, roleId.ToString())
            }),
            Expires = DateTime.UtcNow.AddHours(1), // Token expiry time
            SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
        };
        var token = tokenHandler.CreateToken(tokenDescriptor);
        return tokenHandler.WriteToken(token);
    }
}
