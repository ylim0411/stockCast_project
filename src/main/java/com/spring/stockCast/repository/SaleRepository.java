package com.spring.stockCast.repository;

import com.spring.stockCast.dto.SaleDTO;
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
public class SaleRepository {
    private final SqlSessionTemplate sql;

    // 전체 판매내역 불러오기
    public List<SaleDTO> findAll() {
        return sql.selectList("Sale.findAll");
    }

    // 해당 년도에 해당하는 판매내역 불러오기
    public List<SaleDTO> findByYear(String year) {
        return sql.selectList("Sale.findByYear",year);
    }
    // 기간 판매내역 불러오기
    public List<SaleDTO> findByDate(LocalDate startDate, LocalDate endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        return sql.selectList("Sale.findByDateBetween", param);
    }
}
