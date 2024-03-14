package com.salesianos.triana.BeElite.dto.Block;

import com.salesianos.triana.BeElite.model.Block;
import lombok.Builder;

@Builder
public record BlockDto(String movement, boolean is_completed) {

    public static BlockDto of(Block b){
        return BlockDto.builder()
                .movement(b.getMovement())
                .is_completed(b.is_completed())
                .build();
    }
}
