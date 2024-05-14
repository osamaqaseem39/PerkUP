namespace adminAPI.Models
{
    public class Area
    {
        public int AreaID { get; set; }
        public string AreaName { get; set; }
        public int CityId { get; set; }
        public City City { get; set; } = new City();
        public int CreatedBy { get; set; }
        public DateTime CreatedAt { get; set; }
        public int UpdatedBy { get; set; }
        public DateTime UpdatedAt { get; set; }
    }
}
