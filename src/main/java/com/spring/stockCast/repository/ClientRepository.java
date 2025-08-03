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

    // 거래처만 전체 조회
    public List<Map<String, Object>> findAll() {
        return sql.selectList("Client.selectAllClients");
    }
}
