package com.spring.stockCast.repository;

import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.dto.StockQuantityDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class ProductRepository {
    private final SqlSessionTemplate sql;

    // 거래처 ID로 상품 목록 조회
    public List<Map<String, Object>> findProductsByClientId(int clientId) {
        return sql.selectList("Product.findByClientId", clientId);
    }

    public List<Map<String, Object>> getAllProducts() {
        return sql.selectList("Product.getAllProducts");
    }

    public List<ProductDTO> selectProductsByCategoryId(int categoryId, int storeId, String keyword) {
        java.util.Map<String, Object> paramMap = new java.util.HashMap<>();
        paramMap.put("categoryId", categoryId);
        paramMap.put("storeId", storeId);
        paramMap.put("keyword", keyword);
        return sql.selectList("Product.selectProductsByCategoryId", paramMap);
    }
    // ho
    public List<ProductDTO> findProductList() {
        return sql.selectList("Product.findProductList");
    }

    public void updateProduct(ProductDTO product) {
        sql.update("Product.update", product);
    }

    public void addProduct(ProductDTO product) {
        sql.update("Product.add", product);
    }

    public List<ProductDTO> findProductByName(String productName) {
        return sql.selectList("Product.findProductByName", productName);
    }


    // 발주 카테고리별 상품 조회 young
    public List<ProductDTO> findByCategoryId(int categoryId) {
        return sql.selectList("Product.findByCategoryId", categoryId);
    }
  
    public List<StockQuantityDTO> stockQuantityList(int storeId) {
        return sql.selectList("Product.stockQuantityList",storeId);
    }
    public List<StockQuantityDTO> findStockQuantityByKeyword(String keyword, int storeId) {
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        params.put("storeId", storeId);
        return sql.selectList("Product.findStockQuantityByKeyword", params);
    }
    public List<StockQuantityDTO> findStockQuantityByKeywordAndMonth(String keyword, int month, int storeId) {
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        params.put("month", month);
        params.put("storeId", storeId);

        return sql.selectList("Product.findStockQuantityByKeywordAndMonth", params);
    }
    public List<StockQuantityDTO> findStockQuantityByMonth(int month, int storeId) {
        Map<String, Object> params = new HashMap<>();
        params.put("month", month);
        params.put("storeId", storeId);

        return sql.selectList("Product.findStockQuantityByMonth", params);
    }

    public void addCategory(ProductDTO productDTO) {
        sql.insert("Product.addCategory", productDTO);
    }

    public List<ProductDTO> findProductsByCategoryId(int parentId) {
        return sql.selectList("Product.findProductsByCategoryId", parentId);
    }

    public void updateProductName(int productId, String newName) {
        Map<String, Object> param = new HashMap<>();
        param.put("productId", productId);
        param.put("newName", newName);
        sql.update("Product.updateProductName", param);
    }


    public List<ProductDTO> findProductSaleAll(String storeId) {
        return sql.selectList("Product.findProductSaleAll",storeId);
    }

}
