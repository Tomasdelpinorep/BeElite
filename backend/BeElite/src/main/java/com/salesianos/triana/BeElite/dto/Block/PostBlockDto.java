package com.salesianos.triana.BeElite.dto.Block;

import com.salesianos.triana.BeElite.dto.Set.PostSetDto;
import com.salesianos.triana.BeElite.model.Block;
import com.salesianos.triana.BeElite.model.Composite_Ids.BlockId;
import com.salesianos.triana.BeElite.model.Composite_Ids.SessionId;
import com.salesianos.triana.BeElite.model.Session;
import lombok.Builder;

import java.util.List;

@Builder
public record PostBlockDto(
        Long block_number,
        String movement,
        String block_instructions,
        Double rest_between_sets,
        List<PostSetDto> sets
) {
    public static Block toEntity(PostBlockDto postBlock, SessionId sessionId){
        BlockId blockId = BlockId.of(sessionId, postBlock.block_number);

        return Block.builder()
                .block_id(blockId)
                .movement(postBlock.movement)
                .instructions(postBlock.block_instructions)
                .rest_between_sets(postBlock.rest_between_sets)
                .sets(postBlock.sets.stream().map(set ->
                        PostSetDto.toEntity(set, blockId)).toList())
                .session(Session.builder().id(sessionId).build())
                .build();
    }

    public static PostBlockDto of(Block b){
        return PostBlockDto.builder()
                .block_number(b.getBlock_id().getBlock_number())
                .movement(b.getMovement())
                .block_instructions(b.getInstructions())
                .rest_between_sets(b.getRest_between_sets())
                .sets(b.getSets() != null ?
                        b.getSets().stream().map(PostSetDto::of).toList() :
                        List.of())
                .build();
    }
}
