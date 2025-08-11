package com.spring.stockCast.repository;

import com.spring.stockCast.dto.ProductCategoryDTO;
import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.dto.StockQuantityDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
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

    public List<ProductDTO> selectProductsByCategoryId(int categoryId, int storeId) {
        java.util.Map<String, Object> paramMap = new java.util.HashMap<>();
        paramMap.put("categoryId", categoryId);
        paramMap.put("storeId", storeId);
        return sql.selectList("Product.selectProductsByCategoryId", paramMap);
    }

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
  
    public List<StockQuantityDTO> stockQuantityList() {
        return sql.selectList("Product.stockQuantityList");
    }
    public List<StockQuantityDTO> findStockQuantityByKeyword(String keyword) {
        return sql.selectList("Product.findStockQuantityByKeyword", keyword);
    }
    public List<StockQuantityDTO> findStockQuantityByKeywordAndMonth(String keyword, int month) {
        Map<String, Object> params = new HashMap<>();
        params.put("keyword", keyword);
        params.put("month", month);

        return sql.selectList("Product.findStockQuantityByKeywordAndMonth", params);
    }
    public List<StockQuantityDTO> findStockQuantityByMonth(int month) {
        return sql.selectList("Product.findStockQuantityByMonth", month);
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


//    // 재고 20개 이하 알림창 you
//    public List<StockQuantityDTO> findLowStock() { // 추가
//        return sql.selectList("Product.findLowStock");
//    }

    public List<ProductDTO> findProductSaleAll(String storeId) {
        return sql.selectList("Product.findProductSaleAll",storeId);
    }


//    public List<StockQuantityDTO> stockList(LocalDate startDate, LocalDate endDate, String productName) {
//        Map<String, Object> param = new HashMap<>();
//        param.put("startDate", startDate);
//        param.put("endDate", endDate);
//        param.put("productName", productName);
//        return sql.selectList("Product.stockList", param); // 매퍼 ID에 맞게 "Product.stockList" 호출
//    }
//
//    /**
//     * 월말 마감 처리: 현재 `product` 테이블의 재고 정보를
//     * 지정된 `closeDate` (보통 다음달 1일)의 기초 재고로 `productinitstock`에 저장합니다.
//     *
//     * @param closeDate 마감 처리 기준 날짜 (다음달 1일)
//     */
//    public void closeStock(LocalDate closeDate) {
//        Map<String, Object> param = new HashMap<>();
//        param.put("closeDate", closeDate);
//        sql.insert("Product.closeStock", param);
//    }


}
