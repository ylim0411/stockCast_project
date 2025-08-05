package com.spring.stockCast.repository;

import com.spring.stockCast.dto.AccountItemDTO;
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
public class AccountingRepository {
    private final SqlSessionTemplate sql;
    // 판매발주 목록 전체가져오기
    public List<AccountItemDTO> findAll() {
        return sql.selectList("Accounting.findAll");
    }
}
