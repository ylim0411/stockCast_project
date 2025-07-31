package com.spring.stockCast.dto;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class ProductCategoryDTO {
    private int categoryId;
    private String categoryName;
    private Long parentId;
    private int categoryLevel;
    private Timestamp createdAt;
}
