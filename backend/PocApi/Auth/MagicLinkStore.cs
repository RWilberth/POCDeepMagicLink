using System.Collections.Concurrent;
using System.Security.Cryptography;
using Microsoft.IdentityModel.Tokens;
using PocApi.Models;

namespace PocApi.Auth;

public class MagicLinkStore
{
    private static readonly TimeSpan Ttl = TimeSpan.FromMinutes(10);

    private readonly ConcurrentDictionary<string, MagicLinkToken> _tokens = new();

    public MagicLinkToken Create(string email)
    {
        var token = Base64UrlEncoder.Encode(RandomNumberGenerator.GetBytes(32));
        var entry = new MagicLinkToken(token, email, DateTime.UtcNow.Add(Ttl));
        _tokens[token] = entry;
        return entry;
    }

    public string? Consume(string token)
    {
        if (!_tokens.TryRemove(token, out var entry)) return null;
        return entry.ExpiresAt >= DateTime.UtcNow ? entry.Email : null;
    }
}
