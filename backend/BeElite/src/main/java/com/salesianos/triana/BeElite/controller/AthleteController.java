package com.salesianos.triana.BeElite.controller;

import com.salesianos.triana.BeElite.dto.User.AthleteDetailsDto;
import com.salesianos.triana.BeElite.dto.User.UserDto;
import com.salesianos.triana.BeElite.service.AthleteService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.util.List;

@RestController
@RequiredArgsConstructor
@Tag(name = "Athlete Controller", description = "Handles registration and all endpoints for athletes.")
public class AthleteController {

    private final AthleteService athleteService;

    @GetMapping("/athlete/{athleteUsername}")
    public AthleteDetailsDto getAthleteDetails(@PathVariable String athleteUsername){
        return AthleteDetailsDto.of(athleteService.findByName(athleteUsername));
    }

    @GetMapping("/{coachUsername}/{programName}/athletes")
    public ResponseEntity<List<UserDto>> getAthletesByProgram(@PathVariable String coachUsername, @PathVariable String programName){
        List<UserDto> athletes = athleteService.findAthletesByProgram(coachUsername, programName).stream().map(UserDto::of).toList();

        if (athletes.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        } else {
            return ResponseEntity.status(HttpStatus.OK).body(athletes);
        }

    }


}
