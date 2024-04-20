package com.salesianos.triana.BeElite.controller;

import com.salesianos.triana.BeElite.dto.User.AthleteDetailsDto;
import com.salesianos.triana.BeElite.dto.User.UserDto;
import com.salesianos.triana.BeElite.model.Athlete;
import com.salesianos.triana.BeElite.service.AthleteService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@Tag(name = "Athlete Controller", description = "Handles registration and all endpoints for athletes.")
public class AthleteController {

    private final AthleteService athleteService;

    @GetMapping("/athlete/{athleteUsername}")
    @Operation(summary = "Get athlete details by username")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved athlete details",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = AthleteDetailsDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                "username": "john_doe",
                                                "name": "John Doe",
                                                "profilePicUrl": "https://example.com/profile.jpg",
                                                "email": "john.doe@example.com",
                                                "program": {
                                                    "program_name": "Training Program",
                                                    "image": "https://example.com/program.jpg"
                                                },
                                                "coach": {
                                                    "username": "coach1",
                                                    "name": "Coach Smith",
                                                    "profilePicUrl": "https://example.com/coach.jpg",
                                                    "email": "coach.smith@example.com"
                                                },
                                                "completed_sessions": 10,
                                                "invites": [
                                                    {
                                                        "programId": "123e4567-e89b-12d3-a456-556642440000",
                                                        "athleteId": "456e1234-e89b-12d3-a456-556642440000"
                                                    }
                                                ]
                                            }
                                            """
                            )}
                    )}
            ),
            @ApiResponse(responseCode = "404", description = "Athlete not found",
                    content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error",
                    content = @Content)
    })
    public AthleteDetailsDto getAthleteDetails(@PathVariable String athleteUsername) {
        return AthleteDetailsDto.of(athleteService.findByName(athleteUsername));
    }

    @GetMapping("/{coachUsername}/{programName}/athletes")
    @Operation(summary = "Get athletes for a specific program")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved athletes",
                    content = {@Content(mediaType = "application/json",
                            array = @ArraySchema(schema = @Schema(implementation = UserDto.class)),
                            examples = {@ExampleObject(
                                    value = """
                                            [
                                                {
                                                    "username": "john_doe",
                                                    "name": "John Doe",
                                                    "profilePicUrl": "https://example.com/profile.jpg",
                                                    "email": "john.doe@example.com"
                                                },
                                                {
                                                    "username": "jane_smith",
                                                    "name": "Jane Smith",
                                                    "profilePicUrl": "https://example.com/jane.jpg",
                                                    "email": "jane.smith@example.com"
                                                }
                                            ]
                                            """
                            )}
                    )}
            ),
            @ApiResponse(responseCode = "404", description = "No athletes found for the program",
                    content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error",
                    content = @Content)
    })
    public ResponseEntity<List<UserDto>> getAthletesByProgram(@PathVariable String coachUsername, @PathVariable String programName) {
        List<UserDto> athletes = athleteService.findAthletesByProgram(coachUsername, programName).stream().map(UserDto::of).toList();

        if (athletes.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        } else {
            return ResponseEntity.status(HttpStatus.OK).body(athletes);
        }

    }

    @GetMapping("/{coachUsername}/oldestAthlete")
    public UserDto getOldestAthleteInAllPrograms(@PathVariable String coachUsername) {
        Athlete a = athleteService.findOldestAthleteInProgram(coachUsername);
        return UserDto.of(a, a.getJoinedProgramDate());
    }
}
