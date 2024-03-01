package com.salesianos.triana.BeElite.model;

import jakarta.persistence.Entity;
import lombok.*;
import lombok.experimental.SuperBuilder;

@Entity
@Getter
@Setter
@ToString
@RequiredArgsConstructor
@SuperBuilder
public class Admin extends Usuario{
}
