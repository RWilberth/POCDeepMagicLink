using PocApi.Repositories;

namespace PocApi.Models;

public class Cliente : IEntity
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Telefono { get; set; } = string.Empty;
    public string Direccion { get; set; } = string.Empty;
}

public record ClienteDto(string Nombre, string Email, string Telefono, string Direccion);
