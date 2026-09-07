using Microsoft.AspNetCore.Mvc;
using PocApi.Auth;
using PocApi.Models;

namespace PocApi.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController(IConfiguration config, TokenService tokenService, MagicLinkStore magicLinkStore) : ControllerBase
{
    [HttpPost("login")]
    public IActionResult Login(LoginRequest request)
    {
        var testEmail = config["TestUser:Email"];
        var testPassword = config["TestUser:Password"];

        if (!string.Equals(request.Email, testEmail, StringComparison.OrdinalIgnoreCase)
            || request.Password != testPassword)
        {
            return Unauthorized();
        }

        var (token, expiresAt) = tokenService.GenerateToken(request.Email);
        return Ok(new LoginResponse(token, request.Email, expiresAt));
    }

    [HttpPost("magic-link/request")]
    public IActionResult RequestMagicLink(MagicLinkRequest request)
    {
        var testEmail = config["TestUser:Email"];

        // No revelamos si el email existe o no: misma respuesta en ambos casos.
        if (!string.Equals(request.Email, testEmail, StringComparison.OrdinalIgnoreCase))
        {
            return Ok(new { message = "Si el correo existe, se envió un enlace de acceso." });
        }

        var entry = magicLinkStore.Create(request.Email);
        var deepLink = $"pocdeeplink://login?token={entry.Token}";
        return Ok(new MagicLinkRequestResponse(deepLink, entry.Token, entry.ExpiresAt));
    }

    [HttpPost("magic-link/verify")]
    public IActionResult VerifyMagicLink(MagicLinkVerifyRequest request)
    {
        var email = magicLinkStore.Consume(request.Token);
        if (email is null) return Unauthorized();

        var (token, expiresAt) = tokenService.GenerateToken(email);
        return Ok(new LoginResponse(token, email, expiresAt));
    }
}
