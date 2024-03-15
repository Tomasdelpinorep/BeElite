package com.salesianos.triana.BeElite.dto.Set;

import com.salesianos.triana.BeElite.dto.Block.PostBlockDto;
import com.salesianos.triana.BeElite.model.Block;
import com.salesianos.triana.BeElite.model.Composite_Ids.BlockId;
import com.salesianos.triana.BeElite.model.Composite_Ids.SetId;
import com.salesianos.triana.BeElite.model.Set;
import lombok.Builder;

public record PostSetDto(
        Long set_number,
        int number_of_sets,
        int number_of_reps,
        double percentage
) {
    public static Set toEntity(PostSetDto postSet, BlockId blockId){
        return Set.builder()
                .set_id(SetId.of(postSet.set_number, blockId))
                .number_of_sets(postSet.number_of_sets)
                .number_of_reps(postSet.number_of_reps)
                .percentage(postSet.percentage)
                .block(Block.builder().block_id(blockId).build())
                .build();
    }
}
