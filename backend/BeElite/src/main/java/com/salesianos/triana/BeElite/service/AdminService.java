package com.salesianos.triana.BeElite.service;

import com.salesianos.triana.BeElite.constants.Constants;
import com.salesianos.triana.BeElite.dto.User.AddUser;
import com.salesianos.triana.BeElite.dto.User.EditUserDto;
import com.salesianos.triana.BeElite.exception.NotFoundException;
import com.salesianos.triana.BeElite.model.*;
import com.salesianos.triana.BeElite.repository.AdminRepository;
import com.salesianos.triana.BeElite.repository.UserRepository;
import com.salesianos.triana.BeElite.utils.ImageUtility;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AdminService {

    private final PasswordEncoder passwordEncoder;
    private final AdminRepository adminRepository;
    private final UserRepository userRepository;

    public Admin createAdmin(AddUser addUser){
        Admin a = Admin.builder()
                .username(addUser.username())
                .name(addUser.name())
                .password(passwordEncoder.encode(addUser.password()))
                .email(addUser.email())
                .build();

        return adminRepository.save(a);
    }

    public boolean isUsernameAvailable(String username){
        List<String> usernames = userRepository.getAllUsernames();
        return !usernames.contains(username);
    }

    public Usuario editUser(EditUserDto e) throws IOException {
        Usuario old = userRepository.findFirstByUsername(e.username()).orElseThrow(() -> new NotFoundException("coach, athlete"));

        MultipartFile profilePic = e.profilePic();
        if (profilePic != null && !profilePic.isEmpty()) {
            byte[] compressedImage = ImageUtility.compressImage(profilePic.getBytes());
            old.setProfilePic(compressedImage);
            old.setProfilePicFileName(profilePic.getOriginalFilename());
        }
        old.setName(e.name());
        old.setEmail(e.email());

        return userRepository.save(old);
    }

    @Transactional
    public void deleteUser(String username){
        //Deal with associated data before deleting the user
        Usuario u = userRepository.findByUsername(username).orElseThrow(() -> new NotFoundException("user"));
        if(u instanceof Coach){
            for(Program program : ((Coach) u).getPrograms()){
                program.setProgramName(Constants.PROGRAM_NAME_WITHOUT_COACH);
                program.setCoach(null);
                program.setImage(Constants.PROGRAM_NAME_WITHOUT_COACH_IMAGE_URL);
            }

            ((Coach) u).getPrograms().clear();
        }

        userRepository.delete(u);
    }

    @Transactional
    public ProfilePicture getUserProfilePic(String username) {
        Usuario user = userRepository.findFirstByUsername(username).orElseThrow(() -> new NotFoundException("user"));

        if (user.getProfilePic() == null) {
            File defaultProfilePictureFile = new File("src/main/resources/images/defaultProfilePic.jpg");

            byte[] defaultProfilePictureData;
            try {
                defaultProfilePictureData = Files.readAllBytes(defaultProfilePictureFile.toPath());
            } catch (IOException e) {
                throw new RuntimeException("Failed to read default profile picture", e);
            }

            return ProfilePicture.builder()
                    .fileName(Constants.DEFAULT_PROFILE_PICTURE_FILENAME)
                    .file(defaultProfilePictureData)
                    .build();
        }

        return ProfilePicture.builder()
                .fileName(user.getProfilePicFileName())
                .file(ImageUtility.decompressImage(user.getProfilePic()))
                .build();
    }
}
