package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Week;
import com.salesianos.triana.BeElite.model.WeekId;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface WeekRepository extends JpaRepository<Week, WeekId> {

    @Query(value = "SELECT * FROM week w WHERE program_id = :programId",nativeQuery = true)
    Page<Week> findPageByProgram(Pageable sortedPage, UUID programId);

    @Query(value = "SELECT DISTINCT week_name FROM week w WHERE program_id = :programId" , nativeQuery = true)
    List<String> findWeekNamesByProgram(UUID programId);

    @Query(value = "SELECT * FROM week w WHERE program_id = :program_id AND week_name = :week_name AND id = :week_number", nativeQuery = true)
    Optional<Week> findByWeekNumber_Name_And_Program(Long week_number, String week_name, UUID program_id );

    @Query(value = "SELECT COUNT(*) FROM week w WHERE program_id = :program_id AND week_name = :week_name", nativeQuery = true)
    int countWeeksByNameAndProgram(String week_name, UUID program_id);
}