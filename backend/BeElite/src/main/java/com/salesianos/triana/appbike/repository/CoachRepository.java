package com.salesianos.triana.appbike.repository;

import com.salesianos.triana.appbike.model.Coach;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;
@Repository
public interface CoachRepository extends JpaRepository<Coach, UUID> {

    Optional<Coach> findByNombre(String nombre);
}
