package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Week;
import com.salesianos.triana.BeElite.model.WeekId;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.UUID;

public interface WeekRepository extends JpaRepository<Week, WeekId> {

    @Query(value = "SELECT * FROM week w WHERE program_id = :programId",nativeQuery = true)
    Page<Week> findPageByProgram(Pageable sortedPage, UUID programId);
}