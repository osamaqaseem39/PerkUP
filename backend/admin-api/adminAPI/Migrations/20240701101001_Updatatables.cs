using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace adminAPI.Migrations
{
    public partial class Updatatables : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "CountryId",
                table: "Cities",
                newName: "CountryID");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "CountryID",
                table: "Cities",
                newName: "CountryId");
        }
    }
}
