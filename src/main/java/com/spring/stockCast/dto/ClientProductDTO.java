package com.spring.stockCast.dto;

import lombok.Data;

@Data
public class ClientProductDTO {
    private int clientId;
    private String clientName;
    private int productId;
    private String productName;  // 상품명
    private int price;           // 가격
}