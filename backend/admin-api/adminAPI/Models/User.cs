using System.ComponentModel.DataAnnotations;

public class User
{
    [Key]
    public int UserID { get; set; }

    public string? UserType { get; set; }

    [Required]
    public string? Username { get; set; }

    public string? DisplayName { get; set; }

    public string? FirstName { get; set; }

    public string? LastName { get; set; }

    public string? UserEmail { get; set; }

    public string? UserContact { get; set; }

    public string? Password { get; set; }

    public string? Images { get; set; }

    public int? RoleID { get; set; }

    public string? Description { get; set; }

    public int? AddressID { get; set; }

    // Universal fields
    public int CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int UpdatedBy { get; set; }
    public DateTime UpdatedAt { get; set; }

    public Role? Role { get; set; }
    public Address? Address { get; set; }
}
