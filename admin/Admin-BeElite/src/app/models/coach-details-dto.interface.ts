import { UserDto } from "./user-dto.intercace";

export interface CoachDetails {
    id: string;
    username: string;
    name: string;
    email: string;
    profilePicUrl: string;
    createdAt: Date;
    athletes: UserDto[];
    programs: ProgramDto[];
}

export interface ProgramDto {
    coachName: string;
    coachUsername: string;
    programName: string;
    programDescription: string;
    programPicUrl: string;
    createdAt: Date;
    numberOfSessions: number;
    numberOfAthletes: number;
}

