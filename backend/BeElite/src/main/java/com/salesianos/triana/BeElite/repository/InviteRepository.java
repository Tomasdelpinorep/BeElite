package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Invite;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface InviteRepository extends JpaRepository<Invite, UUID> {
}