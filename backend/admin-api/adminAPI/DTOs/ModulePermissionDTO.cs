using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

public class ModulePermissionDTO
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
    [NotMapped]
    public ModuleDTO? Module { get; set; }
    [NotMapped]
    public PermissionDTO? Permission { get; set; }

}
