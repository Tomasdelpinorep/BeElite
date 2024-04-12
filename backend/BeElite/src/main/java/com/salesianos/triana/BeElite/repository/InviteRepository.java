package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Invite;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.UUID;

public interface InviteRepository extends JpaRepository<Invite, UUID> {
    @Query(value = "SELECT * FROM Invite i WHERE i.program_id = :programId", nativeQuery = true)
    List<Invite> findInvitesByProgram(UUID programId);
}