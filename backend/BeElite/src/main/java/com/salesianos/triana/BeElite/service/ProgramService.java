package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.constants.Constants;
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
import com.salesianos.triana.BeElite.utils.ImageUtility;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
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

    public boolean programExists(String programName) {
        return programRepository.existsByProgramNameIgnoreCase(programName);
    }

    public Program save(PostProgramDto newProgram) throws IOException {
        Coach c = coachRepository.findById(newProgram.coach_id()).orElseThrow(() -> new NotFoundException("Coach"));

        return programRepository.save(PostProgramDto.toEntity(newProgram, c));
    }

    public Invite saveInvite(PostInviteDto i) {
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

    public Program edit(String originalProgramName, PostProgramDto editedProgram) throws IOException {
          UUID coachId;
//
        if (editedProgram.coach_id() == null) { //Must do this since I am reusing the method for the admin dashboard
            coachId = coachRepository.findByUsername(editedProgram.coachUsername())
                    .orElseThrow(() -> new NotFoundException("coach"))
                    .getId();
        } else {
            coachId = editedProgram.coach_id();
        }


        Optional<Program> existingProgramOpt = programRepository.findByCoachAndProgramName(coachId, originalProgramName);
        if (existingProgramOpt.isPresent()) {
            Program existingProgram = existingProgramOpt.get();

            existingProgram.setProgramName(editedProgram.programName());
            existingProgram.setImage(editedProgram.image());
            existingProgram.setDescription(editedProgram.description());

            MultipartFile programPic = editedProgram.programPic();
            if (programPic != null && !programPic.isEmpty()) {
                byte[] compressedImage = ImageUtility.compressImage(programPic.getBytes());
                existingProgram.setProgramPic(compressedImage);
                existingProgram.setProgramPicFileName(programPic.getOriginalFilename());
            }

            return programRepository.save(existingProgram);
        }
        throw new EntityNotFoundException("Unable to edit the program because it was not found.");

    }

    public List<Program> findByCoach(String coachUsername) {
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        List<Program> p = programRepository.findByCoach(c.getId());

        if (!p.isEmpty()) {
            return programRepository.findByCoach(c.getId());
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

    @Transactional
    public Program findByCoachAndProgramName(String coachUsername, String programName) {
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Optional<Program> p = programRepository.findByCoachAndProgramName(c.getId(), programName);

        if (p.isPresent())
            return p.get();

        throw new EntityNotFoundException("Unable to find any programs with said name and coach Id.");
    }

    @Transactional
    public Page<Program> findPage(Pageable page) {
        Page<Program> pagedResult = programRepository.findPage(page);

        if (pagedResult.isEmpty())
            throw new EntityNotFoundException("No programs found in this page.");

        return pagedResult;
    }

    public void deleteByCoachUsernameAndProgramName(String coachUsername, String programName) {
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Optional<Program> programOptional = programRepository.findByCoachAndProgramName(c.getId(), programName);

        programOptional.ifPresent(program -> {
            program.setVisible(false);
            program.getAthletes().forEach(athlete -> athlete.setProgram(null));
            programRepository.save(program);
        });
    }

    public List<Invite> findInvites(String coachUsername, String programName) {
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));

        return inviteRepository.findInvitesByProgram(p.getId());
    }

    @Transactional
    public ProfilePicture findProgramPic(String programName) {
        Program program = programRepository.findFirstByProgramName(programName).orElseThrow(() -> new NotFoundException("program"));

        if (program.getProgramPic() == null) {
            File defaultProfilePictureFile = new File("src/main/resources/images/defaultProgramPic.jpg");

            byte[] defaultProfilePictureData;
            try {
                defaultProfilePictureData = Files.readAllBytes(defaultProfilePictureFile.toPath());
            } catch (IOException e) {
                throw new RuntimeException("Failed to read default profile picture", e);
            }

            return ProfilePicture.builder()
                    .fileName(Constants.DEFAULT_PROFILE_PICTURE_FILENAME)
                    .file(defaultProfilePictureData)
                    .build();
        }

        return ProfilePicture.builder()
                .fileName(program.getProgramPicFileName())
                .file(ImageUtility.decompressImage(program.getProgramPic()))
                .build();
    }

    public void kickAthleteByUsername(String coachUsername, String programName, String athleteUsername){
        Coach c = coachRepository.findByUsername(coachUsername).orElseThrow(() -> new NotFoundException("coach"));
        Program p = programRepository.findByCoachAndProgramName(c.getId(), programName).orElseThrow(() -> new NotFoundException("program"));

        Athlete athleteToKick = p.getAthletes().stream().filter(athlete -> athlete.getUsername().equalsIgnoreCase(athleteUsername)).findFirst().get();
        athleteToKick.setProgram(null);
        p.getAthletes().remove(athleteToKick);
        programRepository.save(p);
        athleteRepository.save(athleteToKick);
    }
}
