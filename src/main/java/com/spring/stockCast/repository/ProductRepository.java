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

    // 거래처 ID로 상품 목록 조회
    public List<Map<String, Object>> findProductsByClientId(int clientId) {
        return sql.selectList("Product.findByClientId", clientId);
    }
}
