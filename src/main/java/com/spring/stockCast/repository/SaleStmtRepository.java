package com.spring.stockCast.repository;

import com.spring.stockCast.dto.AccoListDTO;
import com.spring.stockCast.dto.SaleListDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class SaleStmtRepository {
    private final SqlSessionTemplate sql;

    // 리스트 불러오기(발주번호, 발주일자, 거래처명, 카테고리, 총금액)
    public List<SaleListDTO> findAll() {
        return sql.selectList("SaleStmt.findAll");
    }

    // 거래명세서 상세보기
    public List<AccoListDTO> findBySaleId(int id) {
        return sql.selectList("SaleStmt.findBySaleId", id);
    }
    // 전체 수
    public int saleCount() {
        return sql.selectOne("SaleStmt.saleCount");
    }
    // 발주번호 검색 + 페이징
    public List<SaleListDTO> findByNoPaging(Map<String, Object> param) {
        return sql.selectList("SaleStmt.findByNoPaging", param);
    }
    // 날짜 검색 수
    public int countByDate(Map<String, Object> param) {
        return sql.selectOne("SaleStmt.countByDate", param);
    }
    // 발주 번호 검색
    public int countByNo(String orderNumber) {
        return sql.selectOne("SaleStmt.countByNo", orderNumber);
    }
    // 날짜 검색 + 페이징
    public List<SaleListDTO> findByDatePaging(Map<String, Object> param) {
        return sql.selectList("SaleStmt.findByDatePaging", param);
    }

    public List<SaleListDTO> pagingList(Map<String, Integer> pagingParams) {
        return sql.selectList("SaleStmt.pagingList", pagingParams);
    }
}
