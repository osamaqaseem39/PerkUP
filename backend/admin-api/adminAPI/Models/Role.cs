using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

public class Role
{
    [Key]
    public int RoleID { get; set; }

    [Required]
    public string? RoleName { get; set; }

    public string? Description { get; set; }

    // Universal fields
    public int CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int UpdatedBy { get; set; }
    public DateTime UpdatedAt { get; set; }

    public ICollection<RolePermission> RolePermissions { get; set; }
}
