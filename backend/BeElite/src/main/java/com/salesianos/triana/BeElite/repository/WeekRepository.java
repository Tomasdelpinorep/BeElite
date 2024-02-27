package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Week;
import com.salesianos.triana.BeElite.model.WeekId;
import org.springframework.data.jpa.repository.JpaRepository;

public interface WeekRepository extends JpaRepository<Week, WeekId> {
}