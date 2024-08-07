namespace adminAPI.Models
{
    public class City
    {
        public int CityID { get; set; }
        public string? CityName { get; set; }
        public int CountryID { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedAt { get; set; }
        public int UpdatedBy { get; set; }
        public DateTime UpdatedAt { get; set; } = DateTime.Now;
    }
}
