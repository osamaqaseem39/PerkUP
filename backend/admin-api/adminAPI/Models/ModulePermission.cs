using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

public class ModulePermission
{
    [Key]
    public int ModulePermissionID { get; set; }
    [Required]
    public string? ModulePermissionName { get; set; }
    public int ModuleID { get; set; }
    public int PermissionID { get; set; }
    public string? Description { get; set; }
    public int CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int UpdatedBy { get; set; }
    public DateTime UpdatedAt { get; set; }
    [NotMapped]
    public Module? Module { get; set; }
    [NotMapped]
    public Permission? Permission { get; set; }

}
