package com.spring.stockCast.dto;

import com.spring.stockCast.enums.ClientStatus;
import lombok.Data;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Data
public class ClientDTO {
    private int clientId;
    private int productId;
    private int adminId;
    private int storeId;
    private String clientName;
    private String businessNumber;
    private String ceoName;
    private String address;
    private String contact;
    private String fax;
    private String email;
    private String managerName;
    private String managerContact;
    private String managerEmail;
    private ClientStatus status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime deletedAt;

    private List<Integer> productIds;    // productId 리스트
    private List<String> productNames;   // productName 리스트

    public String getCreatedAtFormatted() {
        return createdAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }

    public String getUpdatedAtFormatted() {
        return updatedAt != null
                ? updatedAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
                : "-";
    }

    public String getDeletedAtFormatted() {
        return deletedAt != null
                ? deletedAt.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
                : "-";
    }

}
