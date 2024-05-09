using System;
using System.Security.Cryptography;

public class PasswordHasher
{
    private const int SaltSize = 16; // 16 bytes salt
    private const int HashSize = 20; // 20 bytes hash
    private const int Iterations = 10000; // Number of iterations for PBKDF2

    public static string HashPassword(string password)
    {
        // Generate a random salt
        byte[] salt;
        new RNGCryptoServiceProvider().GetBytes(salt = new byte[SaltSize]);

        // Create a new instance of Rfc2898DeriveBytes with the provided password and salt
        var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations);

        // Get the hash value
        byte[] has  h = pbkdf2.GetBytes(HashSize);

        // Combine the salt and hash together in one byte array
        byte[] hashBytes = new byte[SaltSize + HashSize];
        Array.Copy(salt, 0, hashBytes, 0, SaltSize);
        Array.Copy(hash, 0, hashBytes, SaltSize, HashSize);

        // Convert the byte array to a base64-encoded string and return it
        return Convert.ToBase64String(hashBytes);
    }

    public static bool VerifyPassword(string password, string hashedPassword)
    {
        // Convert the base64-encoded string back to a byte array
        byte[] hashBytes = Convert.FromBase64String(hashedPassword);

        // Extract the salt from the hashBytes
        byte[] salt = new byte[SaltSize];
        Array.Copy(hashBytes, 0, salt, 0, SaltSize);

        // Compute the hash with the provided password and the extracted salt
        var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations);
        byte[] hash = pbkdf2.GetBytes(HashSize);

        // Compare the computed hash with the stored hash
        for (int i = 0; i < HashSize; i++)
        {
            if (hashBytes[i + SaltSize] != hash[i])
                return false;
        }
        return true;
    }
}
