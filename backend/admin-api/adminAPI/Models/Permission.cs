using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

public class Permission
{
    [Key]
    public int PermissionID { get; set; }

    [Required]
    public string? PermissionName { get; set; }

    public string? Description { get; set; }

    // Universal fields
    public int CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int UpdatedBy { get; set; }
    public DateTime UpdatedAt { get; set; }

    public ICollection<RolePermission>? RolePermissions { get; set; }
}
