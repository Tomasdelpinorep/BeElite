package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.AthleteSession;
import com.salesianos.triana.BeElite.model.Composite_Ids.AthleteSessionId;
import com.salesianos.triana.BeElite.model.Session;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.UUID;

public interface AthleteSessionRepository extends JpaRepository<AthleteSession, AthleteSessionId> {

    @Query(value = "SELECT COUNT(*) FROM athlete_session a WHERE athlete_id = :athlete_id", nativeQuery = true)
    Long countNumberOfSessionsPerAthlete(UUID athlete_id);

    @Query(value = "SELECT a_s.* FROM athlete_session a_s " +
            "JOIN session s ON a_s.session_number = s.session_number " +
            "    AND a_s.week_number = s.week_number " +
            "    AND a_s.program_id = s.program_id " +
            "JOIN week w ON s.week_number = w.week_number " +
            "    AND s.week_name = w.week_name " +
            "    AND s.program_id = w.program_id " +
            "JOIN program p ON w.program_id = p.id " +
            "JOIN usuario u ON a_s.athlete_id = u.id " +
            "WHERE u.username = :athleteUsername " +
            "    AND s.date <= CURRENT_DATE " +
            "ORDER BY s.date DESC ", nativeQuery = true)
    Page<AthleteSession> findByAthleteUsernameUpUntilTodayOrderedByDate(Pageable page, String athleteUsername);

}