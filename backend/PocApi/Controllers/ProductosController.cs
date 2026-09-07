using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PocApi.Models;
using PocApi.Repositories;

namespace PocApi.Controllers;

[ApiController]
[Route("api/productos")]
[Authorize]
public class ProductosController(InMemoryRepository<Producto> repo) : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll() => Ok(repo.GetAll());

    [HttpGet("{id:int}")]
    public IActionResult GetById(int id) =>
        repo.GetById(id) is { } producto ? Ok(producto) : NotFound();

    [HttpPost]
    public IActionResult Create(ProductoDto dto)
    {
        var producto = new Producto
        {
            Nombre = dto.Nombre,
            Descripcion = dto.Descripcion,
            Precio = dto.Precio,
            Stock = dto.Stock
        };
        repo.Add(producto);
        return Created($"/api/productos/{producto.Id}", producto);
    }

    [HttpPut("{id:int}")]
    public IActionResult Update(int id, ProductoDto dto)
    {
        var producto = new Producto
        {
            Nombre = dto.Nombre,
            Descripcion = dto.Descripcion,
            Precio = dto.Precio,
            Stock = dto.Stock
        };
        return repo.Update(id, producto) ? Ok(producto) : NotFound();
    }

    [HttpDelete("{id:int}")]
    public IActionResult Delete(int id) => repo.Delete(id) ? NoContent() : NotFound();
}
