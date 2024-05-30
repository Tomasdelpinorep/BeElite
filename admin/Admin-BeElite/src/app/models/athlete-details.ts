import { ProgramDto } from "./coach-details-dto.interface";
import { UserDto } from "./user-dto.intercace";

export interface AthleteDetails {
    username:           string;
    name:               string;
    profilePicUrl:      string;
    email:              string;
    program:            ProgramDto;
    coach:              UserDto;
    completed_sessions: number;
    invites:            any[];
}

