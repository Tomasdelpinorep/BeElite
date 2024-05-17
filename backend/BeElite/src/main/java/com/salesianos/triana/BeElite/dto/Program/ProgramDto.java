package com.salesianos.triana.BeElite.dto.Program;
import com.salesianos.triana.BeElite.model.Program;
import lombok.Builder;

@Builder
public record ProgramDto(
        String program_name,
        String program_description,
        String image,
        int numberOfSessions,
        int numberOfAthletes)
{


    public static ProgramDto of(Program p){
        return ProgramDto.builder()
                .program_name(p.getProgramName())
                .program_description(p.getDescription())
                .image(p.getImage())
                .numberOfSessions(p.getWeeks().stream().flatMap(week -> week.getSessions().stream()).mapToInt(session -> 1).sum())
                .numberOfAthletes(p.getAthletes().size())
                .build();
    }

    public static ProgramDto empty(){
        return ProgramDto.builder().build();
    }

    public Program toEntity(ProgramDto pDto){
        return Program.builder()

                .build();
    }
}
