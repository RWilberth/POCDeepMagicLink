using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using PocApi.Models;
using PocApi.Repositories;

namespace PocApi.Controllers;

[ApiController]
[Route("api/clientes")]
[Authorize]
public class ClientesController(InMemoryRepository<Cliente> repo) : ControllerBase
{
    [HttpGet]
    public IActionResult GetAll() => Ok(repo.GetAll());

    [HttpGet("{id:int}")]
    public IActionResult GetById(int id) =>
        repo.GetById(id) is { } cliente ? Ok(cliente) : NotFound();

    [HttpPost]
    public IActionResult Create(ClienteDto dto)
    {
        var cliente = new Cliente
        {
            Nombre = dto.Nombre,
            Email = dto.Email,
            Telefono = dto.Telefono,
            Direccion = dto.Direccion
        };
        repo.Add(cliente);
        return Created($"/api/clientes/{cliente.Id}", cliente);
    }

    [HttpPut("{id:int}")]
    public IActionResult Update(int id, ClienteDto dto)
    {
        var cliente = new Cliente
        {
            Nombre = dto.Nombre,
            Email = dto.Email,
            Telefono = dto.Telefono,
            Direccion = dto.Direccion
        };
        return repo.Update(id, cliente) ? Ok(cliente) : NotFound();
    }

    [HttpDelete("{id:int}")]
    public IActionResult Delete(int id) => repo.Delete(id) ? NoContent() : NotFound();
}
