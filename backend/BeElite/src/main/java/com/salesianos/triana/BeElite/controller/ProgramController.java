package com.salesianos.triana.BeElite.controller;

import com.salesianos.triana.BeElite.dto.Program.InviteDto;
import com.salesianos.triana.BeElite.dto.Program.PostInviteDto;
import com.salesianos.triana.BeElite.dto.Program.PostProgramDto;
import com.salesianos.triana.BeElite.dto.Program.ProgramDetailsDto;
import com.salesianos.triana.BeElite.dto.Program.ProgramDto;
import com.salesianos.triana.BeElite.dto.User.EditUserDto;
import com.salesianos.triana.BeElite.dto.User.UserDto;
import com.salesianos.triana.BeElite.model.Coach;
import com.salesianos.triana.BeElite.model.Invite;
import com.salesianos.triana.BeElite.model.ProfilePicture;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.repository.CoachRepository;
import com.salesianos.triana.BeElite.service.ProgramService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import jakarta.transaction.Transactional;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.io.IOException;
import java.net.URI;
import java.net.URLConnection;
import java.util.List;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
public class ProgramController {

    private final ProgramService programService;
    private final CoachRepository coachRepository;


    @GetMapping("/admin/programs/all")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    @Operation(summary = "Get all programs in the database")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved programs",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = Page.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                "content": [
                                                    {
                                                        "programName": "Weightlifting Program",
                                                        "image": "https://example.com/weightlifting.jpg"
                                                    },
                                                    {
                                                        "programName": "Running Program",
                                                        "image": "https://example.com/running.jpg"
                                                    }
                                                ],
                                                "pageable": {
                                                    "sort": {
                                                        "sorted": false,
                                                        "unsorted": true,
                                                        "empty": true
                                                    },
                                                    "pageNumber": 0,
                                                    "pageSize": 20,
                                                    "offset": 0,
                                                    "paged": true,
                                                    "unpaged": false
                                                },
                                                "totalPages": 2,
                                                "totalElements": 30,
                                                "last": false,
                                                "size": 20,
                                                "number": 0,
                                                "sort": {
                                                    "sorted": false,
                                                    "unsorted": true,
                                                    "empty": true
                                                },
                                                "numberOfElements": 20,
                                                "first": true,
                                                "empty": false
                                            }
                                            """
                            )}
                    )}
            ),
            @ApiResponse(responseCode = "500", description = "Internal server error",
                    content = @Content)
    })
    public Page<ProgramDto> getAll(@PageableDefault(page = 0, size = 10) Pageable page) {
        Page<Program> pagedResult = programService.findPage(page);

        return pagedResult.map(ProgramDto::of);
    }

    @GetMapping("open/programPicture/{programName}")
    public ResponseEntity<ByteArrayResource> getProfilePicture(@PathVariable String programName) {
        ProfilePicture programPic;

        try { //In case program name search doesn't return any program
            programPic = programService.findProgramPic(programName);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        if (programPic == null || programPic.getFile() == null) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        }

        String mimeType = URLConnection.guessContentTypeFromName(programPic.getFileName());
        if (mimeType == null) {
            mimeType = MediaType.APPLICATION_OCTET_STREAM_VALUE;
        }

        ByteArrayResource resource = new ByteArrayResource(programPic.getFile());
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(mimeType))
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + programPic.getFileName() + "\"")
                .body(resource);
    }

    @GetMapping("/programs/{coachUsername}")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    @Operation(summary = "Get all programs for a specific coach")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved programs",
                    content = {@Content(mediaType = "application/json",
                            array = @ArraySchema(schema = @Schema(implementation = ProgramDto.class)),
                            examples = {@ExampleObject(
                                    value = """
                                            [
                                                {
                                                    "programName": "Weightlifting Program",
                                                    "image": "https://example.com/weightlifting.jpg"
                                                },
                                                {
                                                    "programName": "Running Program",
                                                    "image": "https://example.com/running.jpg"
                                                }
                                            ]
                                            """
                            )}
                    )}
            ),
            @ApiResponse(responseCode = "500", description = "Internal server error",
                    content = @Content)
    })
    public List<ProgramDto> getAllByCoach(@PathVariable String coachUsername, @AuthenticationPrincipal Coach coach) {
        return programService.findByCoach(coachUsername).stream()
                .map(ProgramDto::of)
                .toList();
    }

    @GetMapping("/coach/{coachUsername}/{programName}/details")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    @Operation(summary = "Get program details")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved program details",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProgramDetailsDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                "programName": "Weightlifting Program",
                                                "weeks": [
                                                    {
                                                        "weekName": "Week 1",
                                                        "sessions": [
                                                            {
                                                                "session_number": 1,
                                                                "date": "2024-03-25",
                                                                "title": "Strength Training",
                                                                "subtitle": "Upper Body",
                                                                "same_day_session_number": 1,
                                                                "blocks": [
                                                                    {
                                                                        "block_number": 1,
                                                                        "movement": "Bench Press",
                                                                        "instructions": "Perform 3 sets of 8 reps",
                                                                        "rest_between_sets": 60
                                                                    }
                                                                ]
                                                            }
                                                        ]
                                                    }
                                                ],
                                                "description": "A weightlifting program designed to build strength and muscle mass.",
                                                "image": "https://example.com/weightlifting.jpg",
                                                "coach": {
                                                    "username": "john_doe",
                                                    "name": "John Doe",
                                                    "profilePicUrl": "https://example.com/john_doe.jpg",
                                                    "email": "john@example.com"
                                                },
                                                "athletes": [
                                                    {
                                                        "username": "jane_smith",
                                                        "name": "Jane Smith",
                                                        "profilePicUrl": "https://example.com/jane_smith.jpg",
                                                        "email": "jane@example.com"
                                                    }
                                                ],
                                                "createdAt": "2024-03-01"
                                            }
                                            """
                            )}
                    )}
            ),
            @ApiResponse(responseCode = "404", description = "Program not found",
                    content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error",
                    content = @Content)
    })
    public ProgramDetailsDto getProgramDetails(@AuthenticationPrincipal Coach coach, @PathVariable String coachUsername, @PathVariable String programName) {
        return ProgramDetailsDto.of(programService.findByCoachAndProgramName(coachUsername, programName));
    }

    @GetMapping("/coach/{coachUsername}/{programName}/dto")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    @Operation(summary = "Get program DTO")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Successfully retrieved program DTO",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProgramDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                "programName": "Weightlifting Program",
                                                "image": "https://example.com/weightlifting.jpg"
                                            }
                                            """
                            )}
                    )}
            ),
            @ApiResponse(responseCode = "404", description = "Program not found",
                    content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error",
                    content = @Content)
    })
    public ProgramDto getProgramDto(@AuthenticationPrincipal Coach coach, @PathVariable String coachUsername, @PathVariable String programName) {
        return ProgramDto.of(programService.findByCoachAndProgramName(coachUsername, programName));
    }

    @GetMapping("/coach/{coachUsername}/{programName}/invites")
    public List<InviteDto> getProgramInvites(@PathVariable String coachUsername, @PathVariable String programName) {
        List<Invite> invites = programService.findInvites(coachUsername, programName);

        return invites.stream().map(InviteDto::of).toList();
    }

    @PostMapping("coach/program")
    @Operation(summary = "Create a new program")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Program successfully added",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProgramDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                "programName": "New Program",
                                                "image": null
                                            }
                                            """
                            )}
                    )}
            ),
            @ApiResponse(responseCode = "400", description = "Bad request",
                    content = @Content),
            @ApiResponse(responseCode = "401", description = "Unauthorized",
                    content = @Content),
            @ApiResponse(responseCode = "403", description = "Forbidden",
                    content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error",
                    content = @Content)
    })
    public ResponseEntity<ProgramDto> addProgram(@AuthenticationPrincipal Coach coach, @Valid @RequestBody PostProgramDto newProgram) throws IOException {
        Program p = programService.save(newProgram);

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .buildAndExpand(p.getId()).toUri();

        return ResponseEntity.created(createdURI).body(ProgramDto.of(p));
    }

    @PostMapping("admin/create/program")
    @Operation(summary = "Create a new program")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Program successfully added",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = ProgramDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                "programName": "New Program",
                                                "image": null
                                            }
                                            """
                            )}
                    )}
            ),
            @ApiResponse(responseCode = "400", description = "Bad request",
                    content = @Content),
            @ApiResponse(responseCode = "401", description = "Unauthorized",
                    content = @Content),
            @ApiResponse(responseCode = "403", description = "Forbidden",
                    content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error",
                    content = @Content)
    })
    public ResponseEntity<ProgramDto> adminAddProgram(@Valid @RequestPart("programName") String programName,
                                                      @Valid @RequestPart("programDescription") String programDescription,
                                                      @Valid @RequestPart("coachId") String coachId,
                                                      @RequestPart(value = "programPic", required = false) MultipartFile programPic) throws IOException {
        PostProgramDto newProgram = PostProgramDto.builder()
                .programName(programName)
                .description(programDescription)
                .programPic(programPic)
                .coach_id(UUID.fromString(coachId))
                .build();

        Program p = programService.save(newProgram);

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .buildAndExpand(p.getId()).toUri();

        return ResponseEntity.created(createdURI).body(ProgramDto.of(p));
    }

    @Operation(summary = "Send an invite to an athlete")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Invite successfully sent",
                    content = {@Content(mediaType = "application/json",
                            schema = @Schema(implementation = PostInviteDto.class),
                            examples = {@ExampleObject(
                                    value = """
                                            {
                                                "programId": "123e4567-e89b-12d3-a456-556642440000",
                                                "athleteId": "123e4567-e89b-12d3-a456-556642440001"
                                            }
                                            """
                            )}
                    )}
            ),
            @ApiResponse(responseCode = "400", description = "Bad request",
                    content = @Content),
            @ApiResponse(responseCode = "401", description = "Unauthorized",
                    content = @Content),
            @ApiResponse(responseCode = "403", description = "Forbidden",
                    content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error",
                    content = @Content)
    })
    @PostMapping("/coach/invite")
    public ResponseEntity<PostInviteDto> sendInvite(@RequestBody PostInviteDto invite) {
        Invite i = programService.saveInvite(invite);

        URI createdUri = ServletUriComponentsBuilder.fromCurrentRequest()
                .buildAndExpand(i.getId()).toUri();

        return ResponseEntity.created(createdUri).body(PostInviteDto.of(i));
    }

    @PutMapping("coach/program/{programName}")
    public ProgramDto editProgram(@RequestParam String programName, @Valid @RequestBody PostProgramDto editedProgram) throws IOException {
        return ProgramDto.of(programService.edit(programName, editedProgram));
    }

    @PutMapping("admin/program/edit")
    @Transactional
    public ResponseEntity<ProgramDto> adminEditProgram(
            @Valid @RequestPart("originalProgramName") String originalProgramName,
            @Valid @RequestPart("programName") String programName,
            @Valid @RequestPart("coachUsername") String coachUsername,
            @Valid @RequestPart("programDescription") String programDescription,
            @RequestPart(value = "programPic", required = false) MultipartFile programPic) throws IOException {

        PostProgramDto postProgramDto = PostProgramDto.builder()
                .programName(programName)
                .programPic(programPic)
                .coachUsername(coachUsername)
                .description(programDescription)
                .build();

        ProgramDto editedProgram = ProgramDto.of(programService.edit(originalProgramName, postProgramDto));

        return ResponseEntity.ok(editedProgram);
    }

    @DeleteMapping("coach/{coachUsername}/{programName}")
    @Operation(summary = "Delete a program")
    @PreAuthorize("hasRole('COACH') and #coach.id == principal.id or hasRole('ADMIN')")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204", description = "Program successfully deleted"),
            @ApiResponse(responseCode = "400", description = "Bad request",
                    content = @Content),
            @ApiResponse(responseCode = "401", description = "Unauthorized",
                    content = @Content),
            @ApiResponse(responseCode = "403", description = "Forbidden",
                    content = @Content),
            @ApiResponse(responseCode = "404", description = "Not found",
                    content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error",
                    content = @Content)
    })
    public ResponseEntity<?> deleteProgram(@AuthenticationPrincipal Coach coach, @PathVariable String coachUsername, @PathVariable String programName) {
        programService.deleteByCoachUsernameAndProgramName(coachUsername, programName);

        return ResponseEntity.noContent().build();
    }
}
