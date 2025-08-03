package com.spring.stockCast.dto;

import com.spring.stockCast.enums.ClientStatus;
import lombok.Data;

import java.sql.Timestamp;
import java.util.List;

@Data
public class ClientDTO {
    private int clientId;
    private int productId;
    private int adminId;
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
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp deletedAt;

    private List<Integer> productIds;    // productId 리스트
    private List<String> productNames;   // productName 리스트
}
