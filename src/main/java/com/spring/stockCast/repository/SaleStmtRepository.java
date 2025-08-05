package com.spring.stockCast.repository;

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

    public List<SaleListDTO> findByNo(String orderNumber) {
        return sql.selectList("SaleStmt.findByNo",orderNumber);
    }

    public List<SaleListDTO> findByDate(LocalDate startDate, LocalDate endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        return sql.selectList("SaleStmt.findByDateBetween", param);
    }
}
