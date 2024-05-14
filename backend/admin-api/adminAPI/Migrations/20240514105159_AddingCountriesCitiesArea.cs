using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace adminAPI.Migrations
{
    public partial class AddingCountriesCitiesArea : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "PermissionID1",
                table: "ModulePermissions",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_ModulePermissions_PermissionID1",
                table: "ModulePermissions",
                column: "PermissionID1");

            migrationBuilder.AddForeignKey(
                name: "FK_ModulePermissions_Permissions_PermissionID1",
                table: "ModulePermissions",
                column: "PermissionID1",
                principalTable: "Permissions",
                principalColumn: "PermissionID");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_ModulePermissions_Permissions_PermissionID1",
                table: "ModulePermissions");

            migrationBuilder.DropIndex(
                name: "IX_ModulePermissions_PermissionID1",
                table: "ModulePermissions");

            migrationBuilder.DropColumn(
                name: "PermissionID1",
                table: "ModulePermissions");
        }
    }
}
