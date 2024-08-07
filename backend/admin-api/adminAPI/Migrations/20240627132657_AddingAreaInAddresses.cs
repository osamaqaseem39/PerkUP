using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace adminAPI.Migrations
{
    public partial class AddingAreaInAddresses : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Area",
                table: "Addresses",
                type: "nvarchar(max)",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Area",
                table: "Addresses");
        }
    }
}
