using System.ComponentModel.DataAnnotations;

public class Address
{
    [Key]
    public int AddressID { get; set; }

    public string? Street { get; set; }

    public string? City { get; set; }

    public string? State { get; set; }

    public string? PostalCode { get; set; }

    public string? Country { get; set; }

    public decimal? Latitude { get; set; }

    public decimal? Longitude { get; set; }

    // Universal fields
    public int CreatedBy { get; set; }
    public DateTime? CreatedAt { get; set; }
    public int UpdatedBy { get; set; }
    public DateTime? UpdatedAt { get; set; }
}
