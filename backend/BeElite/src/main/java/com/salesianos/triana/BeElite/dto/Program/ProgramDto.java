package com.salesianos.triana.BeElite.dto.Program;
import com.salesianos.triana.BeElite.model.Program;
import lombok.Builder;

@Builder
public record ProgramDto(
        String program_name,
        String image
                         )
{


    public static ProgramDto of(Program p){
        return new ProgramDto(p.getProgramName(), p.getImage());
    }

    public static ProgramDto empty(){
        return ProgramDto.builder().build();
    }
}
