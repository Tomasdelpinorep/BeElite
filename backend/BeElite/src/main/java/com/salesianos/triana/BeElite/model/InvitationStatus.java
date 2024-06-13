package com.salesianos.triana.BeElite.model;

public class InvitationStatus {
    public static String ACCEPTED = "ACCEPTED";
    public static String PENDING = "PENDING";
    public static String REJECTED = "REJECTED";

    public static String valueOf(String status) {
        switch (status) {
            case "PENDING":
                return InvitationStatus.PENDING;
            case "ACCEPTED":
                return InvitationStatus.ACCEPTED;
            case "REJECTED":
                return InvitationStatus.REJECTED;
            default:
                return InvitationStatus.PENDING;
        }
    }
}
