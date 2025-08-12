package com.spring.stockCast.dto;

import lombok.Data;

import java.sql.Timestamp;
@Data
public class ProductDTO {
    private int productId;
    private int storeId;
    private String productName;
    private int categoryId;
    private int price;
    private int stockQuantity;
    private String description;
    private Timestamp createdAt;
    private String clientId;
}
