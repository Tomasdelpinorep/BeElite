package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Coach;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;
@Repository
public interface CoachRepository extends JpaRepository<Coach, UUID> {

    Optional<Coach> findByUsername(String username);

    @Query(value = "SELECT SUM(a.completed_sessions) " +
            "FROM coach c " +
            "JOIN program p ON c.id = p.coach_id " +
            "JOIN athlete a ON p.id = a.program_id " +
            "WHERE c.id = :coachId",
            nativeQuery = true)
    int getTotalSessionsCompleted(UUID coachId);
}
