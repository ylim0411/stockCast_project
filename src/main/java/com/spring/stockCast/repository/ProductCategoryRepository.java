package com.spring.stockCast.repository;

import com.spring.stockCast.dto.ProductCategoryDTO;
import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.dto.StockQuantityDTO;
import lombok.RequiredArgsConstructor;
import org.apache.ibatis.annotations.Param;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class ProductCategoryRepository {
    private final SqlSessionTemplate sql;

    public List<ProductCategoryDTO> categorySelect() {
        return sql.selectList("ProductCategory.categorySelect");
    }

    // 발주 대분류 (거래처별) young
    public List<ProductCategoryDTO> findTopCategoriesByClient(int clientId) {
        return sql.selectList("ProductCategory.findTopCategoriesByClientId", clientId);
    }

    // 발주 중분류 (대분류 + 거래처별)
    public List<ProductCategoryDTO> findSubCategoriesByParentIdAndClientId(int parentId, int clientId) {
        Map<String, Object> param = new HashMap<>();
        param.put("parentId", parentId);
        param.put("clientId", clientId);
        return sql.selectList("ProductCategory.findSubCategoriesByParentIdAndClientId", param);
    }

    // 발주 카테고리별 상품 조회
    public List<ProductDTO> findByCategoryId(int categoryId) {
        return sql.selectList("Product.findByCategoryId", categoryId);
    }

    public List<StockQuantityDTO> categoryList() {
        return sql.selectList("ProductCategory.list");
    }

    // 카테고리 저장 (추가)
    public void save(ProductCategoryDTO categoryDTO) {
        sql.insert("ProductCategory.save", categoryDTO);
    }

    // 모든 대분류 카테고리 조회 (추가)
    public List<ProductCategoryDTO> findTopLevelCategories() {
        return sql.selectList("ProductCategory.findTopLevelCategories");
    }

    // 특정 대분류의 중분류 카테고리 조회 (추가)
    public List<ProductCategoryDTO> findMiddleLevelCategoriesByParentId(int parentId) {
        return sql.selectList("ProductCategory.findMiddleLevelCategoriesByParentId", parentId);
    }
}
