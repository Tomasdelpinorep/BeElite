package com.salesianos.triana.BeElite.controller;

import com.salesianos.triana.BeElite.dto.Session.PostSessionDto;
import com.salesianos.triana.BeElite.dto.Session.SessionCardDto;
import com.salesianos.triana.BeElite.dto.Session.SessionDto;
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

    @GetMapping("/{coachUsername}/{programName}/{weekName}/{weekNumber}/sessions/{sessionNumber}")
    public Page<SessionCardDto> getSessionCardData(@PageableDefault(page = 0, size = 10) Pageable page,
                                                  @PathVariable String coachUsername,
                                                  @PathVariable String programName,
                                                  @PathVariable String weekName,
                                                  @PathVariable Long weekNumber){
        Page<Session> pagedResult = sessionService.findCardPageById(page, coachUsername, programName, weekName, weekNumber);

        return pagedResult.map(SessionCardDto::of);
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

}
