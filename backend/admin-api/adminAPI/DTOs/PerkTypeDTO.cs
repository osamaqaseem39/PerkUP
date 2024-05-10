﻿using System;
using System.ComponentModel.DataAnnotations;

public class PerkTypeDTO
{
    [Key]
    public int PerkTypeID { get; set; }

    [Required]
    public string? TypeName { get; set; }

    public string? Description { get; set; }

    public bool IsActive { get; set; }

    public int CreatedBy { get; set; }

    public DateTime CreatedAt { get; set; }

    public int UpdatedBy { get; set; }

    public DateTime UpdatedAt { get; set; }

    
    public virtual PerkDTO? Perk { get; set; }
}
