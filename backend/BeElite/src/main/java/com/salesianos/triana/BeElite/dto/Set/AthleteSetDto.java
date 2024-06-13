package com.salesianos.triana.BeElite.dto.Set;

import com.salesianos.triana.BeElite.model.Composite_Ids.SetId;
import com.salesianos.triana.BeElite.model.Set;
import lombok.Builder;

import java.util.List;

@Builder
public record AthleteSetDto(
        int numberOfSets,
        int numberOfReps,
        double percentage
) {
    public static AthleteSetDto of(Set s){
        return AthleteSetDto.builder()
                .numberOfSets(s.getNumber_of_sets())
                .numberOfReps(s.getNumber_of_reps())
                .percentage(s.getPercentage())
                .build();
    }
}
