package com.salesianos.triana.BeElite.controller;

import com.salesianos.triana.BeElite.dto.Session.PostSessionDto;
import com.salesianos.triana.BeElite.dto.Session.SessionCardDto;
import com.salesianos.triana.BeElite.dto.Session.SessionDto;
import com.salesianos.triana.BeElite.model.AthleteSession;
import com.salesianos.triana.BeElite.model.Session;
import com.salesianos.triana.BeElite.service.SessionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.apache.coyote.Response;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;

@RestController
@RequiredArgsConstructor
public class SessionController {

    private final SessionService sessionService;

    @GetMapping("/{athleteUsername}/sessions")
    @Operation(summary = "Get session card data by athlete")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved session card data",
                    content = { @Content(mediaType = "application/json",
                            schema = @Schema(implementation = Page.class),
                            examples = {
                                    @ExampleObject(
                                            name = "Session Card Data",
                                            value = """
                                                                                    {
                                                                                       "content": [
                                                                                         {
                                                                                           "date": "2024-03-30",
                                                                                           "sessionNumber": 1,
                                                                                           "programId": "d4aaf793-b1f3-4bf0-b0d2-e65d5a07c152",
                                                                                           "weekName": "Week 1",
                                                                                           "weekNumber": 1,
                                                                                           "blocks": [
                                                                                             {
                                                                                               "movement": "Squats",
                                                                                               "isCompleted": false
                                                                                             }
                                                                                           ],
                                                                                           "title": "Leg Day",
                                                                                           "subtitle": "Focus on lower body strength",
                                                                                           "sameDaySessionNumber": 1
                                                                                         },
                                                                                         {
                                                                                           "date": "2024-04-01",
                                                                                           "sessionNumber": 2,
                                                                                           "programId": "d4aaf793-b1f3-4bf0-b0d2-e65d5a07c152",
                                                                                           "weekName": "Week 1",
                                                                                           "weekNumber": 1,
                                                                                           "blocks": [
                                                                                             {
                                                                                               "movement": "Bench Press",
                                                                                               "isCompleted": true
                                                                                             }
                                                                                           ],
                                                                                           "title": "Upper Body Strength",
                                                                                           "subtitle": "Focus on chest and arms",
                                                                                           "sameDaySessionNumber": 2
                                                                                         }
                                                                                       ],
                                                                                       "pageable": {
                                                                                         "sort": {
                                                                                           "sorted": true,
                                                                                           "unsorted": false,
                                                                                           "empty": false
                                                                                         },
                                                                                         "offset": 0,
                                                                                         "pageNumber": 0,
                                                                                         "pageSize": 20,
                                                                                         "paged": true,
                                                                                         "unpaged": false
                                                                                       },
                                                                                       "totalPages": 2,
                                                                                       "totalElements": 30,
                                                                                       "last": false,
                                                                                       "size": 20,
                                                                                       "number": 0,
                                                                                       "numberOfElements": 20,
                                                                                       "first": true,
                                                                                       "empty": false
                                                                                     }
                                                                                     
                                                    """
                                    )
                            }
                    )}
            ),
            @ApiResponse(responseCode = "404", description = "No session card data found for the athlete")
    })
    public Page<SessionCardDto> getSessionCardDataByAthlete(@PageableDefault(page = 0, size = 20) Pageable page,
                                                  @PathVariable String athleteUsername){
        Page<AthleteSession> pagedResult = sessionService.findSessionCardPageByIdAndAthleteUsername(page, athleteUsername);

        return pagedResult.map(SessionCardDto::of);
    }

    @GetMapping("/{coachUsername}/{programName}/{weekName}/{weekNumber}/sessions/{sessionNumber}")
    @Operation(summary = "Retrieve PostSessionDto by session number")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "PostSessionDto found",
                    content = @Content(schema = @Schema(implementation = PostSessionDto.class),
                            examples = @ExampleObject(
                                    value = """
                                            {
                                                "session_number": 123,
                                                "date": "2023-12-31",
                                                "title": "Session Title",
                                                "subtitle": "Session Subtitle",
                                                "blocks": [
                                                    {
                                                        "block_number": 1,
                                                        "movement": "Movement 1",
                                                        "block_instructions": "Instructions 1",
                                                        "rest_between_sets": 60.5,
                                                        "sets": [
                                                            {
                                                                "set_number": 1,
                                                                "number_of_sets": 3,
                                                                "number_of_reps": 12,
                                                                "percentage": 75.0
                                                            }
                                                        ]
                                                    }
                                                ],
                                                "same_day_session_number": 2
                                            }
                                        """
                            )
                    )
            ),
            @ApiResponse(responseCode = "404", description = "Session not found")
    })
    public PostSessionDto getPostSessionDto(@PathVariable String coachUsername,
                                                   @PathVariable String programName,
                                                   @PathVariable String weekName,
                                                   @PathVariable Long weekNumber,
                                            @PathVariable Long sessionNumber){
        Session s = sessionService.findPostDtoById(coachUsername, programName, weekName, weekNumber, sessionNumber);

        return PostSessionDto.of(s);
    }

    @PostMapping("/{coachUsername}/{programName}/{weekName}/{weekNumber}/sessions/new")
    @Operation(summary = "Create a new session")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Session created",
                    content = @Content(schema = @Schema(implementation = SessionDto.class),
                            examples = @ExampleObject(
                                    value = """
                                                {
                                                    "date": "2023-12-31",
                                                    "sessionNumber": 123,
                                                    "sameDaySessionNumber": 1
                                                }
                                            """
                            )
                    )
            ),
            @ApiResponse(responseCode = "400", description = "Invalid input")
    })
    public ResponseEntity<SessionDto> createNewSession(@PathVariable String coachUsername,
                                                       @PathVariable String programName,
                                                       @PathVariable String weekName,
                                                       @PathVariable Long weekNumber,
                                                       @Valid @RequestBody PostSessionDto postSession){
        Session s = sessionService.save(coachUsername, programName, weekName, weekNumber, postSession);

        URI createdUri = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .buildAndExpand(s.getId()).toUri();

        return ResponseEntity.created(createdUri).body(SessionDto.of(s));
    }

    @PutMapping("/{coachUsername}/{programName}/{weekName}/{weekNumber}/sessions/edit")
    @Operation(summary = "Edit an existing session")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Session edited",
                    content = @Content(schema = @Schema(implementation = SessionDto.class),
                            examples = @ExampleObject(
                                    value = """
                                                {
                                                    "date": "2023-12-31",
                                                    "sessionNumber": 123,
                                                    "sameDaySessionNumber": 1
                                                }
                                            """
                            )
                    )
            ),
            @ApiResponse(responseCode = "400", description = "Invalid input"),
            @ApiResponse(responseCode = "404", description = "Session not found")
    })
    public SessionDto editSession(@PathVariable String coachUsername,
                                  @PathVariable String programName,
                                  @PathVariable String weekName,
                                  @PathVariable Long weekNumber,
                                  @RequestBody @Valid PostSessionDto editedSession){
        Session s = sessionService.edit(editedSession, coachUsername, programName, weekName, weekNumber);
        return SessionDto.of(s);
    }

    @DeleteMapping("/{coachUsername}/{programName}/{weekName}/{weekNumber}/sessions/{sessionNumber}/delete")
    @Operation(summary = "Delete a session")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204", description = "Session deleted"),
            @ApiResponse(responseCode = "404", description = "Session not found")
    })
    public ResponseEntity<?> deleteSession(@PathVariable String coachUsername,
                                           @PathVariable String programName,
                                           @PathVariable String weekName,
                                           @PathVariable Long weekNumber,
                                           @PathVariable Long sessionNumber){
        sessionService.delete(coachUsername, programName, weekName, weekNumber, sessionNumber);
        return ResponseEntity.noContent().build();
    }

}
