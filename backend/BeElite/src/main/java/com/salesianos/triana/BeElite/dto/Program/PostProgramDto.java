package com.salesianos.triana.BeElite.dto.Program;

import com.salesianos.triana.BeElite.model.Coach;
import com.salesianos.triana.BeElite.model.Program;
import com.salesianos.triana.BeElite.utils.ImageUtility;
import com.salesianos.triana.BeElite.validation.annotation.UniqueProgramName;
import jakarta.transaction.Transactional;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.Builder;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.util.UUID;

@Builder
public record PostProgramDto(
        @NotEmpty(message = "Program name cannot be empty.")
        @UniqueProgramName(message = "Program name must be unique.")
        String programName,
        @NotEmpty(message = "Program description cannot be empty.")
        String description,
        String image,
        LocalDate createdAt,
        @NotNull(message = "A program must be linked to a valid coach id.")
        UUID coach_id,
        MultipartFile programPic,
        String coachUsername

) {
        @Transactional
        public static Program toEntity(PostProgramDto newProgram, Coach c) throws IOException {
                if (newProgram.programPic() != null && !newProgram.programPic().isEmpty()) {
                        byte[] compressedImage = ImageUtility.compressImage(newProgram.programPic().getBytes());

                        return Program.builder()
                                .coach(c)
                                .createdAt(newProgram.createdAt())
                                .programName(newProgram.programName())
                                .description(newProgram.description())
                                .programPic(compressedImage)
                                .programPicFileName(newProgram.programPic.getOriginalFilename())
                                .image(newProgram.image())
                                .createdAt(LocalDate.now())
                                .isVisible(true)
                                .build();
                }else{
                        return Program.builder()
                                .coach(c)
                                .createdAt(newProgram.createdAt())
                                .programName(newProgram.programName())
                                .description(newProgram.description())
                                .image(newProgram.image())
                                .build();
                }
        }
}
