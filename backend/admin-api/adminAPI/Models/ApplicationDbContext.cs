using adminAPI.Models;
using Microsoft.EntityFrameworkCore;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
       : base(options)
    {
    }

    // DbSet properties for your models
    public DbSet<Role> Roles { get; set; }
    public DbSet<RolePermission> RolePermissions { get; set; }
    public DbSet<Permission> Permissions { get; set; }
    public DbSet<Module> Modules { get; set; }
    public DbSet<ModulePermission> ModulePermissions { get; set; }
    public DbSet<PerkType> PerkTypes { get; set; }
    public DbSet<Perk> Perks { get; set; }
    public DbSet<User> Users { get; set; }
    public DbSet<Address> Addresses { get; set; }
    public DbSet<Country> Countries { get; set; }
    public DbSet<City> Cities { get; set; }
    public DbSet<Area> Areas { get; set; }

    public DbSet<Menu> Menus { get; set; }
    public DbSet<MenuItem> MenuItems { get; set; }
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // Configure your model relationships or constraints here

        // Role - RolePermission relationship
        modelBuilder.Entity<RolePermission>()
            .HasKey(rp => rp.RolePermissionID);

        modelBuilder.Entity<RolePermission>()
            .HasOne(rp => rp.Role)
            .WithMany(r => r.RolePermissions)
            .HasForeignKey(rp => rp.RoleID);

        modelBuilder.Entity<RolePermission>()
            .HasOne(rp => rp.Permission)
            .WithMany(p => p.RolePermissions) // Assuming Permission has a navigation property pointing back to RolePermission
            .HasForeignKey(rp => rp.PermissionID)
            .OnDelete(DeleteBehavior.Cascade); // Example of cascading delete behavior

        // Module - ModulePermission relationship
        modelBuilder.Entity<ModulePermission>()
            .HasKey(mp => mp.ModulePermissionID);

        modelBuilder.Entity<ModulePermission>()
            .HasOne(mp => mp.Module)
            .WithMany(m => m.ModulePermissions)
            .HasForeignKey(mp => mp.ModuleID);

        modelBuilder.Entity<ModulePermission>()
            .HasOne(mp => mp.Permission)
            .WithMany() // Assuming Permission has a navigation property pointing back to ModulePermission
            .HasForeignKey(mp => mp.PermissionID)
            .OnDelete(DeleteBehavior.Cascade); // Example of cascading delete behavior

        // User - Address relationship
        modelBuilder.Entity<User>()
            .HasOne(u => u.Address)
            .WithOne()
            .HasForeignKey<User>(u => u.AddressID) // Assuming AddressID is the foreign key property
            .OnDelete(DeleteBehavior.Cascade); // Example of cascading delete behavior

        // User - Role relationship
        modelBuilder.Entity<User>()
            .HasOne(u => u.Role)
            .WithMany()
            .HasForeignKey(u => u.RoleID) // Assuming RoleID is the foreign key property
            .OnDelete(DeleteBehavior.Cascade); // Example of cascading delete behavior

        // Role - RolePermission relationship (inverse)
        modelBuilder.Entity<Role>()
            .HasMany(r => r.RolePermissions)
            .WithOne(rp => rp.Role)
            .HasForeignKey(rp => rp.RoleID);
        modelBuilder.Entity<Menu>()
           .HasMany(m => m.MenuItems)
           .WithOne(mi => mi.Menu)
           .HasForeignKey(mi => mi.MenuID);

        modelBuilder.Entity<MenuItem>()
            .HasOne(mi => mi.Menu)
            .WithMany(m => m.MenuItems)
            .HasForeignKey(mi => mi.MenuID);
    }


    public override int SaveChanges()
    {
        // Custom logic here, if needed
        return base.SaveChanges();
    }
}
