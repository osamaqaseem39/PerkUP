﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

public class ModuleDTO
{
    [Key]
    public int ModuleID { get; set; }

    [Required]
    public string? ModuleName { get; set; }

    public string? DescriptionSection { get; set; }

    public string? DisplayName { get; set; }

    // Universal fields
    public int CreatedBy { get; set; }
    public DateTime CreatedAt { get; set; }
    public int UpdatedBy { get; set; }
    public DateTime UpdatedAt { get; set; }

    public ICollection<ModulePermissionDTO> ModulePermissions { get; set; } = new List<ModulePermissionDTO>();
}
