package com.spring.stockCast.repository;

import com.spring.stockCast.dto.OrderStmtDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class OrderStmtRepository {
    private final SqlSessionTemplate sql;

    public List<OrderStmtDTO> findAll() {
        return sql.selectList("Orders.findAll");
    }
}
