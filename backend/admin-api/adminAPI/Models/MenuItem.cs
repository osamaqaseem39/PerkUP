using System;
using System.ComponentModel.DataAnnotations;

public class MenuItem
{
    [Key]
    public int MenuItemID { get; set; }

    [Required]
    public int MenuID { get; set; }

    [Required]
    public string? ItemName { get; set; }

    public string? Description { get; set; }

    public string? Image { get; set; }

    public decimal Price { get; set; }

    public decimal? Discount { get; set; }  // Nullable to handle no discount

    public bool IsPercentageDiscount { get; set; }  // True if discount is percentage, false if fixed amount

    public bool IsActive { get; set; }


    // Universal fields
    public int CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int UpdatedBy { get; set; }
    public DateTime UpdatedAt { get; set; }
}
