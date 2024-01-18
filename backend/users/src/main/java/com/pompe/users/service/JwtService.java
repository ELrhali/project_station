package com.pompe.users.service;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import java.security.Key;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Component
public class JwtService {

    public static final String SECRET = "5367566B59703373367639792F423F4528482B4D6251655468576D5A71347437";

  /*  public String generateToken(String userName, String roles) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("roles", roles);

        return createToken(claims, userName);
    }*/

    private String createToken(Map<String, Object> claims, String userName) {
        return Jwts.builder()
                .setClaims(claims)
                .setSubject(userName)
                .setIssuedAt(new Date(System.currentTimeMillis()))
                .setExpiration(new Date(System.currentTimeMillis() + 1000 * 60 * 60))
                .signWith(getSignKey(), SignatureAlgorithm.HS256).compact();
    }
    public Map<String, String> generateTokenAndMessage(String userName, String roles) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("roles", roles);

        String token = createToken(claims, userName);
        String message = getMessageFromRoles(roles);

        Map<String, String> tokenAndMessage = new HashMap<>();
        tokenAndMessage.put("token", token);
        tokenAndMessage.put("message", message);

        return tokenAndMessage;
    }

    private String getMessageFromRoles(String roles) {
        if (roles != null) {
            roles = roles.toLowerCase(); // Convertir la chaîne en minuscules pour comparer

            if (roles.contains("admin")) {
                return "Admin logged in";
            } else if (roles.contains("user")) {
                return "User logged in";
            }
        }
        return "Unknown role logged in";
    }

    private Key getSignKey() {
        byte[] keyBytes = Decoders.BASE64.decode(SECRET);
        return Keys.hmacShaKeyFor(keyBytes);
    }

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {
        return Jwts
                .parserBuilder()
                .setSigningKey(getSignKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    private Boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    public Boolean validateToken(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
    }

    public boolean validateToken(String token) {
        try {
            // Implement the logic to validate the JWT token
            // You may use a library like jjwt or any other JWT library
            // Example using jjwt library:
            Jwts.parser().setSigningKey(SECRET).parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            // Log or handle the exception as needed
            return false;
        }
    }
}
