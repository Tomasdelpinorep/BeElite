package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
@Repository

public interface UserRepository extends JpaRepository<Usuario, UUID> {

    Optional<Usuario> findFirstByUsername(String username);
    boolean existsByUsernameIgnoreCase(String username);
    boolean existsByEmailIgnoreCase(String username);

    @Query(value = "SELECT username FROM Usuario", nativeQuery = true)
    List<String> getAllUsernames();
}
