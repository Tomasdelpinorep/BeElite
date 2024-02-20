package com.salesianos.triana.BeElite;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Contact;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.info.License;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;



@SpringBootApplication
@OpenAPIDefinition(info =
@Info(description = "BeElite API.",
		version = "1.0",
		contact = @Contact(email = "tomasdelpino28@gmail.com", name = "Tomás del Pino"),
		license = @License(name = "Apache 2.0"),
		title = "BeElite"
)
)
public class BeEliteApplication {

	public static void main(String[] args) {
		SpringApplication.run(BeEliteApplication.class, args);
	}

}
