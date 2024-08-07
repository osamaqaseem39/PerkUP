using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace adminAPI.Migrations
{
    public partial class UpdateTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "CityId",
                table: "Areas",
                newName: "CityID");

            migrationBuilder.AlterColumn<string>(
                name: "AreaName",
                table: "Areas",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "CityID",
                table: "Areas",
                newName: "CityId");

            migrationBuilder.AlterColumn<string>(
                name: "AreaName",
                table: "Areas",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "",
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);
        }
    }
}
