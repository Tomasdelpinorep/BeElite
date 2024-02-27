package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Program;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface ProgramRepository extends JpaRepository<Program, UUID> {

    boolean existsByProgramNameIgnoreCase(String programName);

    @Query(value = "SELECT * FROM program p WHERE p.coach_id = :coach_id AND p.programName = :programName", nativeQuery = true)
    Optional<Program> findByCoachAndProgramName(UUID coach_id, String programName);

    @Query(value = "SELECT * FROM program p WHERE p.coach_id = :coach_id", nativeQuery=true)
    List<Program> findByCoach(UUID coach_id);

}