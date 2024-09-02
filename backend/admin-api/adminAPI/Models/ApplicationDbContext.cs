using adminAPI.Models;
using Microsoft.EntityFrameworkCore;

public class ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : DbContext(options)
{

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
        // Role - RolePermission relationship
        modelBuilder.Entity<RolePermission>()
            .HasKey(rp => rp.RolePermissionID);

        modelBuilder.Entity<RolePermission>()
            .HasOne(rp => rp.Role)
            .WithMany(r => r.RolePermissions)
            .HasForeignKey(rp => rp.RoleID);

        modelBuilder.Entity<RolePermission>()
            .HasOne(rp => rp.Permission)
            .WithMany(p => p.RolePermissions)
            .HasForeignKey(rp => rp.PermissionID)
            .OnDelete(DeleteBehavior.Cascade);

        // Module - ModulePermission relationship
        modelBuilder.Entity<ModulePermission>()
            .HasKey(mp => mp.ModulePermissionID);

        modelBuilder.Entity<ModulePermission>()
            .HasOne(mp => mp.Module)
            .WithMany(m => m.ModulePermissions)
            .HasForeignKey(mp => mp.ModuleID);

        modelBuilder.Entity<ModulePermission>()
            .HasOne(mp => mp.Permission)
            .WithMany(p => p.ModulePermissions)
            .HasForeignKey(mp => mp.PermissionID)
            .OnDelete(DeleteBehavior.Cascade);

        // User - Address relationship
        modelBuilder.Entity<User>()
            .HasOne(u => u.Address)
            .WithOne()
            .HasForeignKey<User>(u => u.AddressID)
            .OnDelete(DeleteBehavior.Cascade);

        // User - Role relationship
        modelBuilder.Entity<User>()
            .HasOne(u => u.Role)
            .WithMany()
            .HasForeignKey(u => u.RoleID)
            .OnDelete(DeleteBehavior.Cascade);

        // Role - RolePermission relationship (inverse)
        modelBuilder.Entity<Role>()
            .HasMany(r => r.RolePermissions)
            .WithOne(rp => rp.Role)
            .HasForeignKey(rp => rp.RoleID);


        // Decimal precision and scale configuration
        modelBuilder.Entity<Address>()
            .Property(a => a.Latitude)
            .HasColumnType("decimal(18, 10)");

        modelBuilder.Entity<Address>()
            .Property(a => a.Longitude)
            .HasColumnType("decimal(18, 10)");

        modelBuilder.Entity<MenuItem>()
            .Property(mi => mi.Discount)
            .HasColumnType("decimal(18, 2)");

        modelBuilder.Entity<MenuItem>()
            .Property(mi => mi.Price)
            .HasColumnType("decimal(18, 2)");

        modelBuilder.Entity<Perk>()
            .Property(p => p.MaxDiscountAmount)
            .HasColumnType("decimal(18, 2)");

        modelBuilder.Entity<Perk>()
            .Property(p => p.MinPurchaseAmount)
            .HasColumnType("decimal(18, 2)");

        modelBuilder.Entity<Perk>()
            .Property(p => p.Value)
            .HasColumnType("decimal(18, 2)");


        // Configuration for Menu and MenuItem relationship
        modelBuilder.Entity<Menu>()
            .HasMany(m => m.MenuItems)
            .WithOne() // Removed .WithOne(mi => mi.Menu)
            .HasForeignKey(mi => mi.MenuID);
    }



    public override int SaveChanges()
    {
        // Custom logic here, if needed
        return base.SaveChanges();
    }
}
