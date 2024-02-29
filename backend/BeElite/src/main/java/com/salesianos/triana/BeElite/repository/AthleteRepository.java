package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Athlete;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface AthleteRepository extends JpaRepository<Athlete, UUID> {
    Optional<Athlete> findByUsername(String AthleteUsername);
}
