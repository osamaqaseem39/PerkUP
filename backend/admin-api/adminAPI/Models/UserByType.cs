using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

public class UserByType
{
    [Key]
    public int UserID { get; set; }

    public string? UserType { get; set; }

    [Required]
    public string? Username { get; set; }

    public string? DisplayName { get; set; }

    public string? FirstName { get; set; }

    public string? LastName { get; set; }

    public string? UserEmail { get; set; }

    public string? UserContact { get; set; }

   
            
    public string? Images { get; set; }


 

    public string? Description { get; set; }

      public int CreatedBy { get; set; }

}
