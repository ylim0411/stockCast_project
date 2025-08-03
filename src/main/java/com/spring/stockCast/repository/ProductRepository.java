package com.spring.stockCast.repository;

import com.spring.stockCast.dto.ProductDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class ProductRepository {
    private final SqlSessionTemplate sql;

    public List<ProductDTO> selectProductsByCategoryId(int categoryId) {
        return sql.selectList("Product.selectProductsByCategoryId", categoryId);
    }

    public List<ProductDTO> findProductList() {
        return sql.selectList("Product.findProductList");
    }

    public void delete(int productId) {
        sql.delete("Product.delete", productId);
    }
}
