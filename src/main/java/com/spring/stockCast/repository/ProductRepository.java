package com.spring.stockCast.repository;

import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class ProductRepository {
    private final SqlSessionTemplate sql;

    public List<Map<String, Object>> findAll() {
        return sql.selectList("Product.selectAllProducts");
    }

    public Map<String, Object> findById(int id) {
        return sql.selectOne("Product.selectProductById",id);
    }

    public List<Map<String, Object>> findByClientId(int clientId) {
        return sql.selectList("Product.findByClientId", clientId);
    }

    public List<Map<String, Object>> findByCategoryId(int categoryId) {
        return sql.selectList("Product.findByCategoryId", categoryId);
    }

    public List<Map<String, Object>> findProductsByClientId(int clientId) {
        return sql.selectList("Product.findByClientId", clientId);
    }
}
