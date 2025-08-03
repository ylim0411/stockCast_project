package com.spring.stockCast.repository;

import com.spring.stockCast.dto.ProductDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
<<<<<<< HEAD
=======
import java.util.Map;
>>>>>>> e43a20ddd810cdea45e5ece2709ee52845370d3f

@Repository
@RequiredArgsConstructor
public class ProductRepository {
    private final SqlSessionTemplate sql;

<<<<<<< HEAD
    public List<ProductDTO> selectProductsByCategoryId(int categoryId) {
        return sql.selectList("Product.selectProductsByCategoryId", categoryId);
    }

    public List<ProductDTO> findProductList() {
        return sql.selectList("Product.findProductList");
    }

    public void delete(int productId) {
        sql.delete("Product.delete", productId);
=======
    // 거래처 ID로 상품 목록 조회
    public List<Map<String, Object>> findProductsByClientId(int clientId) {
        return sql.selectList("Product.findByClientId", clientId);
>>>>>>> e43a20ddd810cdea45e5ece2709ee52845370d3f
    }
}
