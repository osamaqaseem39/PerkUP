using System;

using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

public class Menu
{
    [Key]
    public int MenuID { get; set; }

    [Required]
    public string? MenuName { get; set; }

    public string? Description { get; set; }

    public string? Image { get; set; }

    public bool IsActive { get; set; }

    public int CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int UpdatedBy { get; set; }
    public DateTime UpdatedAt { get; set; }


    // Navigation property - this should be a collection
    public List<MenuItem>? MenuItems { get; set; }
}
