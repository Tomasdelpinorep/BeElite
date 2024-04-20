package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Athlete;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface AthleteRepository extends JpaRepository<Athlete, UUID> {
    Optional<Athlete> findByUsername(String AthleteUsername);

    @Query(value = "SELECT * FROM Athlete a JOIN Usuario u ON a.id = u.id " +
            "WHERE a.program_id = :programId ORDER BY u.name ASC", nativeQuery = true)
    List<Athlete> findAthletesByProgram(UUID programId);

    @Query(value = "SELECT * FROM athlete a " +
            "JOIN program p ON a.program_id = p.id " +
            "JOIN Usuario u ON a.id = u.id " +
            "WHERE p.coach_id = :coachId " +
            "ORDER BY a.joined_program_date ASC " +
            "LIMIT 1 ",
            nativeQuery = true)
    Athlete findOldestAthlete(UUID coachId);
}
