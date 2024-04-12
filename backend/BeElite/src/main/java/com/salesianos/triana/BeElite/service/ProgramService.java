package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.dto.Program.InviteDto;
import com.salesianos.triana.BeElite.dto.Program.PostInviteDto;
import com.salesianos.triana.BeElite.dto.Program.PostProgramDto;
import com.salesianos.triana.BeElite.dto.Program.ProgramDto;
import com.salesianos.triana.BeElite.exception.NotFoundException;
import com.salesianos.triana.BeElite.exception.ProgramNameAlreadyInUseException;
import com.salesianos.triana.BeElite.model.*;
import com.salesianos.triana.BeElite.repository.AthleteRepository;
import com.salesianos.triana.BeElite.repository.CoachRepository;
import com.salesianos.triana.BeElite.repository.InviteRepository;
import com.salesianos.triana.BeElite.repository.ProgramRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ProgramService {

    private final ProgramRepository programRepository;
    private final CoachRepository coachRepository;
    private final InviteRepository inviteRepository;
    private final AthleteRepository athleteRepository;

    public boolean programExists(String program_name) {
        return programRepository.existsByProgramNameIgnoreCase(program_name);
    }

    public Program save(PostProgramDto newProgram) {
        Coach c = coachRepository.findById(newProgram.coach_id()).orElseThrow(() -> new NotFoundException("Coach"));

        return programRepository.save(PostProgramDto.toEntity(newProgram,c));
    }

    public Invite saveInvite(PostInviteDto i){
        Program p = programRepository.findByCoachAndProgramName(i.coachId(), i.programName()).orElseThrow(() -> new NotFoundException("Program"));

        Invite invite = Invite.builder()
                .athlete(athleteRepository.findByUsername(i.athleteUsername()).orElseThrow(() -> new NotFoundException("Athlete")))
                .program(p)
                .status(InvitationStatus.PENDING)
                .createdAt(LocalDateTime.now())
                .build();

        p.getInvitesSent().add(invite);

        return inviteRepository.save(invite);
    }

    public Program edit(String programName, PostProgramDto editedProgram){
       Optional<Program> programWithMatchingName = programRepository.findByCoachAndProgramName(editedProgram.coach_id(), editedProgram.programName());

       //If new name matches with current program list (possible if name isn't changed) and it isn't equal to original name,
        // only other option is that it's using a name of another program, therefore an exception is thrown.
       if(programWithMatchingName.isPresent() && !programWithMatchingName.get().getProgramName().equalsIgnoreCase(programName))
           throw new ProgramNameAlreadyInUseException("Program name is already in use.");

       //Original, non-edited program
       Optional<Program> existingProgramOpt = programRepository.findByCoachAndProgramName(editedProgram.coach_id(),programName);
       if(existingProgramOpt.isPresent()){
           Program existingProgram = existingProgramOpt.get();

           existingProgram.setProgramName(editedProgram.programName());
           existingProgram.setImage(editedProgram.image());
           existingProgram.setDescription(editedProgram.description());

           return programRepository.save(existingProgram);
       }
       throw new EntityNotFoundException("Unable to edit the program because it was not found.");

    }

    public List<Program> findByCoach(UUID coach_id) {
        List<Program> p = programRepository.findByCoach(coach_id);

        if (!p.isEmpty()) {
            return programRepository.findByCoach(coach_id);
        }

        throw new NotFoundException("programs linked to this coach id.");
    }

    public List<ProgramDto> findAll() {
        if (programRepository.findAll().isEmpty())
            throw new EntityNotFoundException("No programs have been found linking to your coach id.");

        return programRepository.findAll().stream()
                .map(ProgramDto::of)
                .toList();
    }

    public Program findByCoachAndProgramName(String coachUsername, String programName){
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Optional<Program> p = programRepository.findByCoachAndProgramName(c.getId(),programName);

        if(p.isPresent())
            return p.get();

        throw new EntityNotFoundException("Unable to find any programs with said name and coach Id.");
    }

    public Page<Program> findPage(Pageable page){
        Page<Program> pagedResult = programRepository.findPage(page);

        if(pagedResult.isEmpty())
            throw new EntityNotFoundException("No programs found in this page.");

        return pagedResult;
    }

    public void deleteByCoachAndProgramName(UUID coachId, String programName) {
        Optional<Program> programOptional = programRepository.findByCoachAndProgramName(coachId, programName);

        programOptional.ifPresent(program -> {
                program.removeAthletes();
                programRepository.delete(program);
        });
    }

    public List<Invite> findInvites(String coachUsername, String programName){
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));

        return inviteRepository.findInvitesByProgram(p.getId());
    }
}
