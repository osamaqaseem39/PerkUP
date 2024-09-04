using System;
using System.ComponentModel.DataAnnotations;

public class Perk
{
    [Key]
    public int PerkID { get; set; }

    public int PerkType { get; set; }

    [Required]
    public string? PerkName { get; set; }

    public string? Description { get; set; }

    public decimal Value { get; set; }

    public DateTime? StartDate { get; set; }

    public DateTime? EndDate { get; set; }

    public bool IsActive { get; set; }

    public decimal? MinPurchaseAmount { get; set; }

    public decimal? MaxDiscountAmount { get; set; }

    // Universal fields
    public int CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int UpdatedBy { get; set; }
    public DateTime UpdatedAt { get; set; }
   
}
