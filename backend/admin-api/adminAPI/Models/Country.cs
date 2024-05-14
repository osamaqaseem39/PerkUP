namespace adminAPI.Models
{
    public class Country
    {
        public int CountryID { get; set; }
        public string? CountryName { get; set; }
        public List<City> Cities { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedAt { get; set; }
        public int UpdatedBy { get; set; }
        public DateTime UpdatedAt { get; set; } 
    }
}
