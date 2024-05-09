using System.ComponentModel.DataAnnotations;

public class ModulePermission
{
    [Key]
    public int ModulePermissionID { get; set; }

    [Required]
    public string? ModulePermissionName { get; set; }

    public int ModuleID { get; set; }
    public int PermissionID { get; set; }


    public string? Description { get; set; }

    // Universal fields
    public int CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int UpdatedBy { get; set; }
    public DateTime UpdatedAt { get; set; }

    public Module? Module { get; set; }
    public Permission? Permission { get; set; }

}
