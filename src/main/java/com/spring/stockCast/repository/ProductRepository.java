package com.spring.stockCast.repository;

import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.dto.StockQuantityDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

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

    public List<ProductDTO> selectProductsByCategoryId(int categoryId) {
        return sql.selectList("Product.selectProductsByCategoryId", categoryId);
    }

    public List<ProductDTO> findProductList() {
        return sql.selectList("Product.findProductList");
    }

//    public void delete(int productId) {
//        sql.delete("Product.delete", productId);
//    }

    public void updateProduct(ProductDTO product) {
        sql.update("Product.update", product);
    }

    public void addProduct(ProductDTO product) {
        sql.update("Product.add", product);
    }

    public List<ProductDTO> findProductByName(String productName) {
        return sql.selectList("Product.findProductByName", productName);
    }

    public List<StockQuantityDTO> stockQuantityList() {
        return sql.selectList("Product.stockQuantityList");
    }
}
