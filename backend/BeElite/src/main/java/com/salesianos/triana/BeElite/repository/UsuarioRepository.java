package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface UsuarioRepository extends JpaRepository<Usuario, UUID> {
}