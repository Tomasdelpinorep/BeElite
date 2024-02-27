package com.salesianos.triana.BeElite.controller;

import com.salesianos.triana.BeElite.dto.Program.PostProgramDto;
import com.salesianos.triana.BeElite.dto.Program.ProgramDto;
import com.salesianos.triana.BeElite.model.Coach;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.service.ProgramService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.net.URI;
import java.util.List;

@RestController
@RequiredArgsConstructor
public class ProgramController {

    private final ProgramService programService;

    @GetMapping("/admin/program")
    public List<ProgramDto> getAll(){
        return programService.findAll();
    }

    @GetMapping("/coach/program")
    @PreAuthorize("#coach.id == principal.id")
    public List<ProgramDto> getAllByCoach(@AuthenticationPrincipal Coach coach){
        return programService.findByCoach(coach.getId()).stream()
                .map(ProgramDto::of)
                .toList();
    }

    @PostMapping("coach/program")
    public ResponseEntity<ProgramDto> addProgram(@Valid @RequestBody PostProgramDto newProgram){
        Program p = programService.save(newProgram);

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .buildAndExpand(p.getId()).toUri();

        return ResponseEntity.created(createdURI).body(ProgramDto.of(p));
    }

    @PutMapping("coach/program/{programName}")
    public ProgramDto editProgram(@Valid @RequestParam String programName, @RequestBody PostProgramDto editedProgram){
        return ProgramDto.of(programService.edit(programName, editedProgram));
    }
}
