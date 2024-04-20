package com.salesianos.triana.BeElite.dto.Program;
import com.salesianos.triana.BeElite.model.Program;
import lombok.Builder;

@Builder
public record ProgramDto(
        String program_name,
        String program_description,
        String image
                         )
{


    public static ProgramDto of(Program p){
        return new ProgramDto(p.getProgramName(), p.getDescription(), p.getImage());
    }

    public static ProgramDto empty(){
        return ProgramDto.builder().build();
    }

    public Program toEntity(ProgramDto pDto){
        return Program.builder()

                .build();
    }
}
