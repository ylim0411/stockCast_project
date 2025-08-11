package com.spring.stockCast.dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class StockQuantityDTO {
    // 상품 정보
    private Integer productId;
    private String productName;
    private int storeId;

    // 카테고리 정보
    private Integer parentId;
    private Integer categoryLevel;
    private String categoryName;
    private Integer topLevelCategoryId;
    private String topLevelCategoryName;

    private Timestamp categoryCreatedAt;
    private Timestamp productCreatedAt;

    // 입고 요약
    private Integer purchaseQty;
    private Integer purchasePrice;
    private Integer totalPurchase;

    // 출고 요약
    private Integer saleQty;
    private Integer salePrice;
    private Integer totalSale;

    // 기말 재고
    private Integer price;
    private Integer stockQuantity;
    private Long totalStockAmount;

    // 초기 재고
    private Integer initialStockQuantity;
    private Integer initialUnitPrice;
    private Long totalInitialStockAmount;
}
