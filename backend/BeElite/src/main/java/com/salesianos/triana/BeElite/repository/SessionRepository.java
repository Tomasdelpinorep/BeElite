package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Session;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SessionRepository extends JpaRepository<Session, Long> {
}