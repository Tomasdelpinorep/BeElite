import { Pageable, Sort } from "./all-coaches-response.interface";
import { ProgramDto } from "./coach-details-dto.interface";

export interface AllProgramsResponse {
    content:          ProgramDto[];
    pageable:         Pageable;
    totalPages:       number;
    totalElements:    number;
    last:             boolean;
    size:             number;
    number:           number;
    sort:             Sort;
    numberOfElements: number;
    first:            boolean;
    empty:            boolean;
}

