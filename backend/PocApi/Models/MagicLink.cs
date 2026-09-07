namespace PocApi.Models;

public record MagicLinkToken(string Token, string Email, DateTime ExpiresAt);

public record MagicLinkRequest(string Email);

public record MagicLinkRequestResponse(string DeepLink, string Token, DateTime ExpiresAt);

public record MagicLinkVerifyRequest(string Token);
