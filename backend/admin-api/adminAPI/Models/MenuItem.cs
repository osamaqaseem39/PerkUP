using System;

using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

public class MenuItem
{
    public int MenuItemID { get; set; }
    public int MenuID { get; set; }
    public string? ItemName { get; set; }
    public string? Description { get; set; } // Nullable
    public string? Image { get; set; } // Nullable
    public decimal Price { get; set; }
    public decimal? Discount { get; set; } // Nullable
    public bool IsPercentageDiscount { get; set; }
    public bool IsActive { get; set; }
    public string? Category { get; set; } // Nullable
    public int CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int UpdatedBy { get; set; }
    public DateTime UpdatedAt { get; set; }
}