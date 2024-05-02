import { UserDto } from "./user-dto.intercace";

export interface CoachDetails {
    id:            string;
    username:      string;
    name:          string;
    email:         string;
    profilePicUrl: string;
    createdAt:     Date;
    athletes:      UserDto[];
    programs:      ProgramDto[];
}

export interface ProgramDto {
    program_name:        string;
    program_description: string;
    image:               string;
}
