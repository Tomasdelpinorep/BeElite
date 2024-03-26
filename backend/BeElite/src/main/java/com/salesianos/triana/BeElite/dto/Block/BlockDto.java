package com.salesianos.triana.BeElite.dto.Block;

import com.salesianos.triana.BeElite.model.AthleteBlock;
import com.salesianos.triana.BeElite.model.Block;
import lombok.Builder;

@Builder
public record BlockDto(String movement, boolean isCompleted) {

    public static BlockDto of(AthleteBlock athleteBlock){
        return BlockDto.builder()
                .movement(athleteBlock.getBlock().getMovement())
                .isCompleted(athleteBlock.isCompleted())
                .build();
    }
}
