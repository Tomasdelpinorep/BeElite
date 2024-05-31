package com.salesianos.triana.BeElite.controller;

import com.salesianos.triana.BeElite.dto.Program.InviteDto;
import com.salesianos.triana.BeElite.dto.User.AddUser;
import com.salesianos.triana.BeElite.dto.User.CoachDetailsDto;
import com.salesianos.triana.BeElite.dto.User.UserDto;
import com.salesianos.triana.BeElite.model.Athlete;
import com.salesianos.triana.BeElite.model.Coach;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.security.jwt.JwtProvider;
import com.salesianos.triana.BeElite.security.jwt.JwtUserResponse;
import com.salesianos.triana.BeElite.service.AthleteService;
import com.salesianos.triana.BeElite.service.CoachService;
import com.salesianos.triana.BeElite.service.ProgramService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@RequestMapping("/coach")
@Tag(name = "Coach Controller", description = "Handles registration and all endpoints for coaches.")
public class CoachController {

    private final CoachService coachService;

    @GetMapping("/{coachUsername}")
    @Transactional
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    @Operation(summary = "Get coach details")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved coach details",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = CoachDetailsDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                "id": "123e4567-e89b-12d3-a456-426614174001",
                                                "username": "coach_john",
                                                "name": "John Smith",
                                                "email": "john.smith@example.com",
                                                "profilePicUrl": "https://example.com/profile.jpg",
                                                "createdAt": "2024-03-31T08:00:00",
                                                "athletes": [
                                                    {
                                                        "username": "john_doe",
                                                        "name": "John Doe",
                                                        "profilePicUrl": "https://example.com/john.jpg",
                                                        "email": "john.doe@example.com"
                                                    },
                                                    {
                                                        "username": "jane_smith",
                                                        "name": "Jane Smith",
                                                        "profilePicUrl": "https://example.com/jane.jpg",
                                                        "email": "jane.smith@example.com"
                                                    }
                                                ],
                                                "programs": [
                                                    {
                                                        "programName": "Weightlifting Program",
                                                        "image": "https://example.com/weightlifting.jpg"
                                                    },
                                                    {
                                                        "programName": "Running Program",
                                                        "image": "https://example.com/running.jpg"
                                                    }
                                                ]
                                            }
                                            """
                            )}
                    )}
            ),
            @ApiResponse(responseCode = "404", description = "Coach not found",
                    content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error",
                    content = @Content)
    })
    public ResponseEntity<CoachDetailsDto> getCoachDetails(@AuthenticationPrincipal Coach coach , @PathVariable String coachUsername){
        return ResponseEntity.ok(CoachDetailsDto.of(coachService.findByUsername(coachUsername)));
    }

    @GetMapping("/{coachUsername}/totalSessionsCompleted")
    public int getTotalSessionsCompleted(@PathVariable String coachUsername){
        return coachService.getTotalSessionsCompleted(coachUsername);
    }

    @GetMapping("/all")
    public Page<UserDto> getAllCoaches(@PageableDefault(page = 0, size = 10) Pageable page){
        Page<Coach> coaches = coachService.getAllCoaches(page);
        return coaches.map(UserDto::of);
    }

    @GetMapping("/allNamesAndIds")
    public ResponseEntity<Map<String, UUID>> getAllNamesAndIds(){
        Map<String, UUID> map = coachService.getAllNamesAndIdsMap();
        return map.isEmpty() ? ResponseEntity.notFound().build() : ResponseEntity.ok(map);

    }
}
