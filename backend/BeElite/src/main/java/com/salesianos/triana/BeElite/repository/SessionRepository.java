package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Composite_Ids.SessionId;
import com.salesianos.triana.BeElite.model.Composite_Ids.WeekId;
import com.salesianos.triana.BeElite.model.Session;
import com.salesianos.triana.BeElite.model.Week;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.UUID;

public interface SessionRepository extends JpaRepository<Session, SessionId> {
//Leaving this here in case the bottom option doesnt work
//    @Query(value = "SELECT * FROM session s WHERE s.week_name = :weekName " +
//            "AND s.week_number = :weekNumber " +
//            "AND s.program_id = :programId " +
//            "AND s.session_number = :sessionNumber", nativeQuery = true)
//    Page<Week> findCardPageById(Pageable page,
//                                @Param("weekName") String weekName,
//                                @Param("weekNumber") int weekNumber,
//                                @Param("programId") Long programId,
//                                @Param("sessionNumber") int sessionNumber);

    @Query(value = "SELECT * FROM session s WHERE " +
            "s.week_name = :#{#weekId.week_name} " +
            "AND s.week_number = :#{#weekId.week_number} " +
            "AND s.program_id = :#{#weekId.program_id} ", nativeQuery = true)
    Page<Session> findSessionCardPageById(Pageable page, @Param("weekId") WeekId weekId);


}