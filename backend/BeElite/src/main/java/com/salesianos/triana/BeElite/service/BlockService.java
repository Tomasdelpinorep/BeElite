package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.dto.Block.PostBlockDto;
import com.salesianos.triana.BeElite.dto.Set.PostSetDto;
import com.salesianos.triana.BeElite.exception.NotFoundException;
import com.salesianos.triana.BeElite.model.Block;
import com.salesianos.triana.BeElite.model.Composite_Ids.BlockId;
import com.salesianos.triana.BeElite.model.Composite_Ids.SessionId;
import com.salesianos.triana.BeElite.model.Session;
import com.salesianos.triana.BeElite.repository.SessionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class BlockService {

    public static Block toEntity(PostBlockDto postBlock, SessionId sessionId, Session newSession){
        BlockId blockId = BlockId.of(sessionId, postBlock.block_number());

        return Block.builder()
                .block_id(blockId)
                .movement(postBlock.movement())
                .instructions(postBlock.block_instructions())
                .rest_between_sets(postBlock.rest_between_sets())
                .sets(postBlock.sets().stream().map(set ->
                        PostSetDto.toEntity(set, blockId)).toList())
                .session(newSession)
                .build();
    }
}
