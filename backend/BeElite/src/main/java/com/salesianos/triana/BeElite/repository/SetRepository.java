package com.salesianos.triana.BeElite.repository;

import com.salesianos.triana.BeElite.model.Composite_Ids.SetId;
import com.salesianos.triana.BeElite.model.Set;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SetRepository extends JpaRepository<Set, SetId> {
}