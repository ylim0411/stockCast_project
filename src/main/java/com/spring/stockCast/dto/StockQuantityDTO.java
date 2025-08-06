package com.spring.stockCast.dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class StockQuantityDTO {
    private String productId;
    private String productName;
    private Integer parentId;
    private Integer categoryLevel;
    private String categoryName;
    private Integer topLevelCategoryId;
    private String topLevelCategoryName;

    private Timestamp categoryCreatedAt;
    private Timestamp productCreatedAt;

    private Integer purchaseQty;
    private Double purchasePrice;
    private Double totalPurchase;

    private Integer saleQty;
    private Double salePrice;
    private Double totalSale;

    private Double price;
    private Integer stockQuantity;
    private Double totalStockAmount;

}
