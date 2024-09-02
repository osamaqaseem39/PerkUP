using System;

using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

public class Menu
{
    public int MenuID { get; set; }
    public string? MenuName { get; set; }
    public string? Description { get; set; } // Nullable
    public string? Image { get; set; } // Nullable
    public bool IsActive { get; set; }
    public int CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int UpdatedBy { get; set; }
    public DateTime UpdatedAt { get; set; }
    public List<MenuItem>? MenuItems { get; set; } // Nullable
}