package com.salesianos.triana.BeElite.model;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class ProfilePicture {
    private String fileName;
    private byte[] file;
}
