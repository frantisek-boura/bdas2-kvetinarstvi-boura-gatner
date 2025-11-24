package kvetinarstvi.backend;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfiguration implements WebMvcConfigurer {

    @Override
    public void addCorsMappings(CorsRegistry registry) {
        // Allows all origins, methods, and headers for all endpoints
        registry.addMapping("/**") // Apply to all paths
                .allowedOrigins("*") // ⬅️ Allows all origins (e.g., http://localhost:3000)
                .allowedMethods("*") // ⬅️ Allows all methods (GET, POST, PUT, etc.)
                .allowedHeaders("*"); // ⬅️ Allows all headers
    }
}