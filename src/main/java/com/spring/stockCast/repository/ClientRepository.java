package com.spring.stockCast.repository;

import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class ClientRepository {
    private final SqlSessionTemplate sql;

    // 특정 거래처의 상품 목록 조회
    public List<Map<String, Object>> findProductsByClientId(int clientId) {
        return sql.selectList("Product.findByClientId", clientId);
    }

    // 거래처 + 상품명 같이 조회
    public List<Map<String, Object>> findClientsWithProducts() {
        return sql.selectList("Client.findClientsWithProducts");
    }

    // 거래처만 전체 조회
    public List<Map<String, Object>> findAll() {
        return sql.selectList("Client.selectAllClients");
    }
}
