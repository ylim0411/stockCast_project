package com.spring.stockCast.repository;

import com.spring.stockCast.dto.OrderStmtDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class OrderStmtRepository {
    private final SqlSessionTemplate sql;

    public List<OrderStmtDTO> findAll() {
        return sql.selectList("Orders.findAll");
    }

    public List<OrderStmtDTO> findByDateBetween(LocalDate startDate, LocalDate endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        return sql.selectList("Orders.findByDateBetween", param);
    }

    public List<OrderStmtDTO> findByNo(String orderStmtId) {
        return sql.selectList("Orders.findByNo",orderStmtId);
    }

}
