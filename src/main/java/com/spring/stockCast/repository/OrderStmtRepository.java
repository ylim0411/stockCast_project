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

    // 전체 발주 조회
    public List<OrderStmtDTO> findAll() {
        return sql.selectList("Orders.findAll");
    }

    // 날짜 범위로 발주 조회
    public List<OrderStmtDTO> findByDateBetween(LocalDate startDate, LocalDate endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("startDate", java.sql.Date.valueOf(startDate));
        param.put("endDate", java.sql.Date.valueOf(endDate.plusDays(1)));
        return sql.selectList("Orders.findByDateBetween", param);
    }

    // 발주번호로 발주 조회
    public List<OrderStmtDTO> findByNo(String orderStmtId) {
        return sql.selectList("Orders.findByNo", orderStmtId);
    }

    // 마지막 발주 ID 조회
    public int getLastOrderId() {
        return sql.selectOne("Orders.getLastOrderId");
    }

    // 발주서 저장
    public void insertOrder(Map<String, Object> param) {
        sql.insert("Orders.insertOrder", param);
    }

    // 발주 상세 조회
    public OrderStmtDTO findById(int orderId) {
        return sql.selectOne("Orders.findById", orderId);
    }
}