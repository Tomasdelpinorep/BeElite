package com.salesianos.triana.BeElite.model.Composite_Ids;

import com.salesianos.triana.BeElite.model.Block;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

@Embeddable
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class SetId implements Serializable {

    @Column(name = "set_number")
    private Long set_number;

    @Embedded
    BlockId block_id;

    public static SetId of(Long set_number, BlockId block_id){
        return new SetId(set_number, block_id);
    }
}
