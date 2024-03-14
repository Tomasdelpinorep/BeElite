package com.salesianos.triana.BeElite.model.Composite_Ids;

import com.salesianos.triana.BeElite.model.Week;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.io.Serializable;

@Embeddable
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class SessionId implements Serializable {

    @Column(name = "session_number")
    private Long session_number;

    @Embedded
    private WeekId weekId;

    public static SessionId of(Long session_number, WeekId weekId){
        return new SessionId(session_number, weekId);
    }
}
