using System.ComponentModel.DataAnnotations.Schema;

namespace adminAPI.Models
{
    public class Country
    {
        public int CountryID { get; set; }
        public string? CountryName { get; set; }  
        public int CreatedBy { get; set; }
        public DateTime CreatedAt { get; set; }
        public int UpdatedBy { get; set; }
        public DateTime UpdatedAt { get; set; } 
    }
}
