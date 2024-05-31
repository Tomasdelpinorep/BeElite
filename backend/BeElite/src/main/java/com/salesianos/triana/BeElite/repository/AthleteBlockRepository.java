package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.AthleteBlock;
import com.salesianos.triana.BeElite.model.AthleteSession;
import com.salesianos.triana.BeElite.model.Block;
import com.salesianos.triana.BeElite.model.Composite_Ids.AthleteBlockId;
import com.salesianos.triana.BeElite.model.Composite_Ids.SessionId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import java.util.UUID;

public interface AthleteBlockRepository extends JpaRepository<AthleteBlock, AthleteBlockId> {
    void deleteByBlock(Block block);

    @Query(value = "SELECT COUNT(*) FROM athlete_session a WHERE athlete_id = :athlete_id AND athlete_session_number = :athlete_session_number", nativeQuery = true)
    Long countNumberOfBlocksPerAthleteSession(UUID athlete_id, Long athlete_session_number);

    @Modifying
    @Query(value = "DELETE FROM athlete_block a WHERE " +
            "a.session_number = :#{#sessionId.session_number} " +
            "AND a.week_number = :#{#sessionId.week_id.week_number} " +
            "AND a.week_name = :#{#sessionId.week_id.week_name} " +
            "AND a.program_id = :#{#sessionId.week_id.program_id}", nativeQuery = true)
    void deleteBySessionId(SessionId sessionId);
}