using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

public class RoleDTO
{
    public int RoleID { get; set; }
    public string RoleName { get; set; }
    public string Description { get; set; }
    public int CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int UpdatedBy { get; set; }
    public DateTime UpdatedAt { get; set; }
    public List<RolePermissionDTO> RolePermissions { get; set; }
}
