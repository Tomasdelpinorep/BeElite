package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Admin;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface AdminRepository extends JpaRepository<Admin, UUID> {
}