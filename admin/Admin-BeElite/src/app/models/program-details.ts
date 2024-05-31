import { UserDto } from "./user-dto.intercace";

export interface ProgramDetails {
    programName: string;
    weeks:       WeekDto[];
    description: string;
    image:       string;
    coach:       UserDto;
    athletes:    UserDto[];
    createdAt:   Date;
    invitesSent: any[];
}

export interface Coach {
    username:          string;
    name:              string;
    profilePicUrl:     string;
    email:             string;
    joinedProgramDate: null;
}

export interface WeekDto {
    weekName:    string;
    description: string;
    sessions:    Session[];
    weekNumber:  number;
    created_at:  Date;
    span:        Date[];
}

export interface Session {
    date:                 Date;
    sessionNumber:        number;
    sameDaySessionNumber: number;
}
