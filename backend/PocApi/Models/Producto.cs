using PocApi.Repositories;

namespace PocApi.Models;

public class Producto : IEntity
{
    public int Id { get; set; }
    public string Nombre { get; set; } = string.Empty;
    public string Descripcion { get; set; } = string.Empty;
    public decimal Precio { get; set; }
    public int Stock { get; set; }
}

public record ProductoDto(string Nombre, string Descripcion, decimal Precio, int Stock);
