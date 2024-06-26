package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.dto.Program.InviteDto;
import com.salesianos.triana.BeElite.model.Invite;
import com.salesianos.triana.BeElite.model.Program;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ProgramRepository extends JpaRepository<Program, UUID> {

    boolean existsByProgramNameIgnoreCase(String programName);

    Optional<Program> findFirstByProgramName(String programName);

    @Query(value = "SELECT * FROM program p WHERE p.coach_id = :coach_id AND p.program_name = :programName AND p.is_visible = true", nativeQuery = true)
    Optional<Program> findByCoachAndProgramName(UUID coach_id, String programName);

    @Query(value = "SELECT * FROM program p WHERE p.coach_id = :coachId AND p.is_visible = true", nativeQuery = true)
    List<Program> findByCoach(@Param("coachId") UUID coachId);

    @Query(value = "SELECT * FROM program p WHERE p.is_visible = true", nativeQuery = true)
    Page<Program> findPage(Pageable page);

}