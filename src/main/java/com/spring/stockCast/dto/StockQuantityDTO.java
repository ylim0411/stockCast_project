package com.spring.stockCast.dto;

import lombok.Data;

@Data
public class StockQuantityDTO {
    private String productId;
    private String productName;
    private String topLevelCategoryName; // 최상위 카테고리 이름 (뷰에서 추가된 필드)
    private Integer categoryLevel;
    private String categoryName;
    private Double purchasePrice;
    private Integer purchaseQty;
    private Double salePrice;
    private Integer saleQty;
    private Double price;
    private Integer stockQuantity;
    private Double totalStockAmount;

}
