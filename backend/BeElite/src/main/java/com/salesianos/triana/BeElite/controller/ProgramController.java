package com.salesianos.triana.BeElite.controller;

import com.salesianos.triana.BeElite.dto.Program.InviteDto;
import com.salesianos.triana.BeElite.dto.Program.PostProgramDto;
import com.salesianos.triana.BeElite.dto.Program.ProgramDto;
import com.salesianos.triana.BeElite.model.Coach;
import com.salesianos.triana.BeElite.model.Invite;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.service.ProgramService;
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
public class ProgramController {

    private final ProgramService programService;

    @GetMapping("/admin/program")
    public Page<ProgramDto> getAll(@PageableDefault(page = 0, size = 20) Pageable page){
        Page<Program> pagedResult = programService.findPage(page);

        return pagedResult.map(ProgramDto::of);
    }

    @GetMapping("/coach/program")
    @PreAuthorize("#coach.id == principal.id")
    public List<ProgramDto> getAllByCoach(@AuthenticationPrincipal Coach coach){
        return programService.findByCoach(coach.getId()).stream()
                .map(ProgramDto::of)
                .toList();
    }

    @GetMapping("/coach/program/details/{programName}")
    @PreAuthorize("#coach.id == principal.id")
    public Program getProgramDetails(@AuthenticationPrincipal Coach coach, @PathVariable String programName){
        return programService.findByCoachAndProgramName(coach.getId(),programName);
    }

    @PostMapping("coach/program")
    public ResponseEntity<ProgramDto> addProgram(@Valid @RequestBody PostProgramDto newProgram){
        Program p = programService.save(newProgram);

        URI createdURI = ServletUriComponentsBuilder
                .fromCurrentRequest()
                .buildAndExpand(p.getId()).toUri();

        return ResponseEntity.created(createdURI).body(ProgramDto.of(p));
    }

    @PostMapping("/coach/invite")
    public ResponseEntity<InviteDto> sendInvite(@RequestBody InviteDto invite){
        Invite i = programService.saveInvite(invite);

        URI createdUri = ServletUriComponentsBuilder.fromCurrentRequest()
                .buildAndExpand(i.getId()).toUri();

        return ResponseEntity.created(createdUri).body(InviteDto.of(i));
    }

    @PutMapping("coach/program/{programName}")
    public ProgramDto editProgram(@RequestParam String programName,@Valid @RequestBody PostProgramDto editedProgram){
        return ProgramDto.of(programService.edit(programName, editedProgram));
    }

    @DeleteMapping("coach/program/{programName}")
    public ResponseEntity<?> deleteProgram(@AuthenticationPrincipal Coach coach,@RequestParam String programName){
        programService.deleteByCoachAndProgramName(coach.getId(), programName);

        return ResponseEntity.noContent().build();
    }
}
