package com.salesianos.triana.BeElite.dto.Block;

import com.salesianos.triana.BeElite.dto.Set.AthleteSetDto;
import com.salesianos.triana.BeElite.model.AthleteBlock;
import com.salesianos.triana.BeElite.model.Composite_Ids.AthleteBlockId;
import lombok.Builder;

import java.util.List;
@Builder
public record AthleteBlockDto(AthleteBlockId blockId,
                              String movement,
                              String instructions,
                              Double rest,
                              List<AthleteSetDto> sets,
                              String feedback,
                              boolean isCompleted) {

    public static AthleteBlockDto of(AthleteBlock a){
        return AthleteBlockDto.builder()
                .blockId(AthleteBlockId.of(a.getId().getAthlete_block_number(), a.getAthleteSession().getId()))
                .movement(a.getBlock().getMovement())
                .instructions(a.getBlock().getInstructions())
                .rest(a.getBlock().getRest_between_sets())
                .sets(a.getBlock().getSets() == null ? List.of() : a.getBlock().getSets().stream().map(AthleteSetDto::of).toList())
                .feedback(a.getFeedback())
                .isCompleted(a.isCompleted())
                .build();
    }
}
