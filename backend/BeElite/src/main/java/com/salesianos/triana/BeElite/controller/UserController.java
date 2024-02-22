package com.salesianos.triana.BeElite.controller;

import com.salesianos.triana.BeElite.dto.User.AddUser;
import com.salesianos.triana.BeElite.model.Usuario;
import com.salesianos.triana.BeElite.dto.User.LoginUser;
import com.salesianos.triana.BeElite.security.jwt.JwtProvider;
import com.salesianos.triana.BeElite.security.jwt.JwtUserResponse;
import com.salesianos.triana.BeElite.service.AthleteService;
import com.salesianos.triana.BeElite.service.CoachService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequiredArgsConstructor
@Tag(name = "User", description = "Handles login and registration for athletes and coaches")
public class UserController {

        private final AuthenticationManager authManager;
        private final JwtProvider jwtProvider;
        private final CoachService coachService;
        private final AthleteService athleteService;

        @Operation(summary = "Login for athletes and coaches")
        @ApiResponses(value = {
                @ApiResponse(responseCode = "201 Created", description = "Login was succesful", content = {
                        @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = JwtUserResponse.class)), examples = {
                                @ExampleObject(value = """
                                                                        {
                                                                            "id": "ba00362c-f808-4dfd-8d0c-386d6c1757a9",
                                                                            "username": "tomasdelpinorep",
                                                                            "email": "usuario@gmail.com",
                                                                            "name": "Tomás del Pino",
                                                                            "createdAt": "22/11/2023 10:27:44",
                                                                            "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJiYTAwMzYyYy1mODA4LTRkZmQtOGQwYy0zODZkNmMxNzU3YTkiLCJpYXQiOjE3MDA2NDUyNjQsImV4cCI6MTcwMDczMTY2NH0.2a62n6XejYfeInr-00ywKVfm5me6armBPHA7ehLMwyelHvnLUWRLGmLv6CUN6nZd8QvKMlueIRQEezAqmftcPw"
                                                                        }
                                                                        """) }) }),
                @ApiResponse(responseCode = "400 Bad Request", description = "Login was not successful", content = @Content),
        })
        @PostMapping("/auth/login")
        public ResponseEntity<JwtUserResponse> login(@RequestBody LoginUser loginUser) {

                Authentication authentication = authManager.authenticate(
                        new UsernamePasswordAuthenticationToken(
                                loginUser.username(),
                                loginUser.password()));
                SecurityContextHolder.getContext().setAuthentication(authentication);
                String token = jwtProvider.generateToken(authentication);

                Usuario usuario = (Usuario) authentication.getPrincipal();

                return ResponseEntity.status(HttpStatus.CREATED)
                        .body(JwtUserResponse.of(usuario, token));
        }

    @Operation(summary = "Register for coaches and athletes")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201 Created", description = "Register was successful", content = {
                    @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = JwtUserResponse.class)), examples = {
                            @ExampleObject(value = """
                                                                        {
                                                                            "id": "ba00362c-f808-4dfd-8d0c-386d6c1757a9",
                                                                            "username": "tomasdelpinorep",
                                                                            "email": "usuario@gmail.com",
                                                                            "nombre": "Tomás del Pino",
                                                                            "createdAt": "22/11/2023 10:27:44",
                                                                            "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJiYTAwMzYyYy1mODA4LTRkZmQtOGQwYy0zODZkNmMxNzU3YTkiLCJpYXQiOjE3MDA2NDUyNjQsImV4cCI6MTcwMDczMTY2NH0.2a62n6XejYfeInr-00ywKVfm5me6armBPHA7ehLMwyelHvnLUWRLGmLv6CUN6nZd8QvKMlueIRQEezAqmftcPw",
                                                                            "isCoach": false
                                                                        }
                                                                        """) }) }),
            @ApiResponse(responseCode = "400 Bad Request", description = "Register was not successful", content = @Content),
    })
    @PostMapping("/auth/register")
    public ResponseEntity<JwtUserResponse> createUser(@Valid @RequestBody AddUser addUser) {
        Usuario user;
        if (addUser.isCoach()) {
            user = coachService.createCoach(addUser);
        } else {
            user = athleteService.createAthlete(addUser);
        }

        Authentication authentication = authManager.authenticate(new UsernamePasswordAuthenticationToken(addUser.username(), addUser.password()));
        SecurityContextHolder.getContext().setAuthentication(authentication);
        String token = jwtProvider.generateToken(authentication);

        return ResponseEntity.status(HttpStatus.CREATED).body(JwtUserResponse.of(user, token));
    }


}
