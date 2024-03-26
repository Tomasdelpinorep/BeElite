package com.salesianos.triana.BeElite.controller;

import com.salesianos.triana.BeElite.dto.Session.PostSessionDto;
import com.salesianos.triana.BeElite.dto.Session.SessionCardDto;
import com.salesianos.triana.BeElite.dto.Session.SessionDto;
import com.salesianos.triana.BeElite.model.AthleteSession;
import com.salesianos.triana.BeElite.model.Session;
import com.salesianos.triana.BeElite.service.SessionService;
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
    public Page<SessionCardDto> getSessionCardDataByAthlete(@PageableDefault(page = 0, size = 20) Pageable page,
                                                  @PathVariable String athleteUsername){
        Page<AthleteSession> pagedResult = sessionService.findSessionCardPageByIdAndAthleteUsername(page, athleteUsername);

        return pagedResult.map(SessionCardDto::of);
    }

    @GetMapping("/{coachUsername}/{programName}/{weekName}/{weekNumber}/sessions/{sessionNumber}")
    public PostSessionDto getPostSessionDto(@PathVariable String coachUsername,
                                                   @PathVariable String programName,
                                                   @PathVariable String weekName,
                                                   @PathVariable Long weekNumber,
                                            @PathVariable Long sessionNumber){
        Session s = sessionService.findPostDtoById(coachUsername, programName, weekName, weekNumber, sessionNumber);

        return PostSessionDto.of(s);
    }

    @PostMapping("/{coachUsername}/{programName}/{weekName}/{weekNumber}/sessions/new")
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
    public SessionDto editSession(@PathVariable String coachUsername,
                                  @PathVariable String programName,
                                  @PathVariable String weekName,
                                  @PathVariable Long weekNumber,
                                  @RequestBody @Valid PostSessionDto editedSession){
        Session s = sessionService.edit(editedSession, coachUsername, programName, weekName, weekNumber);
        return SessionDto.of(s);
    }

    @DeleteMapping("/{coachUsername}/{programName}/{weekName}/{weekNumber}/sessions/{sessionNumber}/delete")
    public ResponseEntity<?> deleteSession(@PathVariable String coachUsername,
                                           @PathVariable String programName,
                                           @PathVariable String weekName,
                                           @PathVariable Long weekNumber,
                                           @PathVariable Long sessionNumber){
        sessionService.delete(coachUsername, programName, weekName, weekNumber, sessionNumber);
        return ResponseEntity.noContent().build();
    }

}
