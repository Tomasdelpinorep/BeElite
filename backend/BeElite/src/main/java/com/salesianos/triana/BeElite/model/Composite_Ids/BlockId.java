package com.salesianos.triana.BeElite.model.Composite_Ids;

import com.salesianos.triana.BeElite.model.Session;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

@Embeddable
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class BlockId implements Serializable {

    @Column(name = "block_number")
    private Long block_number;

    @Embedded
    SessionId session_id;

    public static BlockId of(SessionId session_id, Long block_number){
        return new BlockId(block_number, session_id);
    }
}
