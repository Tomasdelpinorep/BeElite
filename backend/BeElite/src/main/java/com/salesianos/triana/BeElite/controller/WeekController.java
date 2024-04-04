package com.salesianos.triana.BeElite.controller;

import com.salesianos.triana.BeElite.dto.Week.EditWeekDto;
import com.salesianos.triana.BeElite.dto.Week.PostWeekDto;
import com.salesianos.triana.BeElite.dto.Week.WeekDto;
import com.salesianos.triana.BeElite.model.Coach;
import com.salesianos.triana.BeElite.model.Week;
import com.salesianos.triana.BeElite.service.WeekService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class WeekController {
    private final WeekService weekService;

    @GetMapping("/coach/{coachUsername}/{programName}/weeks")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    @Operation(summary = "Get weeks by program")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Weeks retrieved",
                    content = @Content(schema = @Schema(implementation = Page.class),
                            examples = @ExampleObject(
                                    value = """
                                           {
                                               "content": [
                                                   {
                                                       "weekName": "Week 1",
                                                       "description": "Description of Week 1",
                                                       "sessions": [
                                                           {
                                                               "date": "2023-01-01",
                                                               "sessionNumber": 1,
                                                               "sameDaySessionNumber": 1
                                                           },
                                                           {
                                                               "date": "2023-01-02",
                                                               "sessionNumber": 2,
                                                               "sameDaySessionNumber": 2
                                                           }
                                                       ],
                                                       "weekNumber": 1,
                                                       "created_at": "2023-01-01T00:00:00",
                                                       "span": ["2023-01-01", "2023-01-07"]
                                                   }
                                               ],
                                               "pageable": {
                                                   "pageNumber": 0,
                                                   "pageSize": 10
                                               },
                                               "totalElements": 1,
                                               "totalPages": 1,
                                               "last": true
                                           }
                                        """
                            )
                    )
            ),
            @ApiResponse(responseCode = "404", description = "Program not found")
    })
    public Page<WeekDto> getWeeksByProgram(@PageableDefault(page = 0, size = 10)Pageable page,
                                                     @AuthenticationPrincipal Coach coach,
                                                     @PathVariable String programName,
                                                     @PathVariable String coachUsername){
        Page<Week> pagedResult = weekService.findPageByProgram(page, programName, coachUsername);

        return pagedResult.map(WeekDto::of);
    }

    @GetMapping("/coach/{coachUsername}/{programName}/weeks/names")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    @Operation(summary = "Get week names by program")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Week names retrieved",
                    content = @Content(schema = @Schema(type = "array", implementation = String.class),
                            examples = @ExampleObject(
                                    value = "[\"Week 1\", \"Week 2\", \"Week 3\"]"
                            )
                    )
            ),
            @ApiResponse(responseCode = "404", description = "Program not found")
    })
    public List<String> getWeekNamesByProgram(@AuthenticationPrincipal Coach coach,
                                              @PathVariable String programName,
                                              @PathVariable String coachUsername){

        return weekService.findWeekNamesByProgram(programName, coachUsername);
    }

    @PostMapping("/coach/{coachUsername}/weeks/new")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    @Operation(summary = "Add a new week")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Week created",
                    content = @Content(schema = @Schema(implementation = WeekDto.class),
                            examples = @ExampleObject(
                                    value = """
                                        {
                                            "weekName": "New Week",
                                            "description": "Description of the new week",
                                            "sessions": [],
                                            "weekNumber": 1,
                                            "created_at": "2023-03-30T12:00:00",
                                            "span": ["2023-03-30"]
                                        }
                                    """
                            )
                    )
            ),
            @ApiResponse(responseCode = "400", description = "Invalid input")
    })
    ResponseEntity<WeekDto> addWeek(@PathVariable String coachUsername,
                                    @AuthenticationPrincipal Coach coach,
                                    @Valid @RequestBody PostWeekDto newWeek){
        Week w = weekService.save(newWeek, coachUsername);

        URI createdUri = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .buildAndExpand(w.getId()).toUri();

        return ResponseEntity.created(createdUri).body(WeekDto.of(w));
    }

    @PutMapping("/coach/{coachUsername}/weeks/edit")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    @Operation(summary = "Edit an existing week")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Week edited",
                    content = @Content(schema = @Schema(implementation = WeekDto.class),
                            examples = @ExampleObject(
                                    value = """
                                        {
                                            "weekName": "Edited Week",
                                            "description": "Updated description of the week",
                                            "sessions": [],
                                            "weekNumber": 1,
                                            "created_at": "2023-03-30T12:00:00",
                                            "span": ["2023-03-30"]
                                        }
                                    """
                            )
                    )
            ),
            @ApiResponse(responseCode = "400", description = "Invalid input"),
            @ApiResponse(responseCode = "404", description = "Week not found")
    })
    WeekDto editWeek(@PathVariable String coachUsername,
                                    @AuthenticationPrincipal Coach coach,
                                    @Valid @RequestBody EditWeekDto editedWeek){
        Week w = weekService.edit(editedWeek, coachUsername);

        return WeekDto.of(w);
    }

    @DeleteMapping("/coach/{coachUsername}/{programName}/weeks/{weekName}/{weekNumber}")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    @Operation(summary = "Delete an existing week")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204", description = "Week deleted"),
            @ApiResponse(responseCode = "404", description = "Week not found")
    })
    public ResponseEntity<?> deleteWeek(@PathVariable String coachUsername,
                                             @PathVariable String programName,
                                             @PathVariable String weekName,
                                             @PathVariable Long weekNumber,
                                             @AuthenticationPrincipal Coach coach){
        weekService.deleteWeek(coachUsername, programName, weekName, weekNumber);
        return ResponseEntity.noContent().build();
    }
}
