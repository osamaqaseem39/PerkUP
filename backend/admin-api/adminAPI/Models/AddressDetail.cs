using adminAPI.Models;
using System.ComponentModel.DataAnnotations;
public class AddressDetail
{
    public Address? Address { get; set; }
    public string? City { get; set; }
    public string? Country { get; set; }
    public string? Area { get; set; }
}

public class AddressResponse
{
    public IEnumerable<AddressDetail>? Addresses { get; set; }
    public IEnumerable<City>? Cities { get; set; }
    public IEnumerable<Country>? Countries { get; set; }
    public IEnumerable<Area>? Areas { get; set; }
}
