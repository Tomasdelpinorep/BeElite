package com.salesianos.triana.appbike.repository;

import com.salesianos.triana.appbike.model.Athlete;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface AthleteRepository extends JpaRepository<Athlete, UUID> {
}
