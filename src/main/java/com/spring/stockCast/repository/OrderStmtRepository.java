package com.spring.stockCast.repository;

import com.spring.stockCast.dto.OrderStmtDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class OrderStmtRepository {
    private final SqlSessionTemplate sql;

    // 날짜 검색 + 페이징
    public List<OrderStmtDTO> findByDatePaging(Map<String, Object> param) {
        return sql.selectList("Orders.findByDatePaging", param);
    }

    // 발주번호 검색 + 페이징
    public List<OrderStmtDTO> findByNoPaging(Map<String, Object> param) {
        return sql.selectList("Orders.findByNoPaging", param);
    }

    // 전체 목록 페이징
    public List<OrderStmtDTO> pagingList(Map<String, Object> pagingParams) {
        return sql.selectList("Orders.pagingList", pagingParams);
    }

    // 달력 조회
    public int countByDate(Map<String, Object> param) {
        return sql.selectOne("Orders.countByDate", param);
    }

    // 발주 번호 검색
    public int countByNo(Map<String, Object> orderStmtId) {
        return sql.selectOne("Orders.countByNo", orderStmtId);
    }

    // 전체 수
    public int orderCount(Integer selectedStoreId) {
        return sql.selectOne("Orders.orderCount", selectedStoreId); // ★ storeId 전달
    }

    // 마지막 발주 id 조회
    public int getLastOrderId(Integer storeId) {
        Integer id = sql.selectOne("Orders.getLastOrderId",storeId);
        return id != null ? id : 0;
    }

    // 발주서 저장
    public void insertOrder(Map<String, Object> param) {
        sql.insert("Orders.insertOrder", param);
    }

    // 발주 상세 조회
    public OrderStmtDTO findById(Map<String, Object> orderId) {
        return sql.selectOne("Orders.findById", orderId);
    }

    // 발주 수정
    public void updateOrder(Map<String, Object> param) {
        sql.update("Orders.updateOrder", param);
    }

    // 발주 삭제
    public void deleteOrder(Map<String, Object> orderId) {
        sql.delete("Orders.deleteOrder", orderId);
    }

    // 발주서 status  수정 ho
    public void updateStatus(Map<String, Object> param) {
        sql.update("Orders.updateStatus", param);
    }

    // 이번달 발주내역 불러오기 ho
    public List<OrderStmtDTO> findByMonth(Map<String, Object> param) {
        return sql.selectList("Orders.findByMonth", param);
    }
    // orderId 최상위 불러오기
    public int findLastOrderId() {
        return sql.selectOne("Orders.findLastOrderId");
    }
}
