using System.ComponentModel.DataAnnotations;

public class RolePermission
{
    [Key]
    public int RolePermissionID { get; set; }

    [Required]
    public string? RolePermissionName { get; set; }

    public int RoleID { get; set; }
    public int PermissionID { get; set; }

    public int ModuleID { get; set; }

    public string? Description { get; set; }

    // Universal fields
    public int CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int UpdatedBy { get; set; }
    public DateTime UpdatedAt { get; set; }

    public Role? Role { get; set; }
    public Permission Permission { get; set; }

}
