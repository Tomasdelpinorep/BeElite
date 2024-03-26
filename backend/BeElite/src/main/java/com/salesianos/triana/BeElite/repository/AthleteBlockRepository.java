package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.AthleteBlock;
import com.salesianos.triana.BeElite.model.Composite_Ids.AthleteBlockId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.UUID;

public interface AthleteBlockRepository extends JpaRepository<AthleteBlock, AthleteBlockId> {

    @Query(value = "SELECT COUNT(*) FROM athlete_session a WHERE athlete_id = :athlete_id AND athlete_session_number = :athlete_session_number", nativeQuery = true)
    Long countNumberOfBlocksPerAthleteSession(UUID athlete_id, Long athlete_session_number);
}