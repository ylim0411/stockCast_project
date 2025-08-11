package com.spring.stockCast.dto;

import lombok.Data;

import java.sql.Timestamp;
import java.util.List;

@Data
public class ProductCategoryDTO {
    private int categoryId;
    private int storeId;
    private String categoryName;
    private Long parentId;
    private int categoryLevel;
    private Timestamp createdAt;

    private List<ProductCategoryDTO> categoryList;
    private List<ProductDTO> productList;
}
