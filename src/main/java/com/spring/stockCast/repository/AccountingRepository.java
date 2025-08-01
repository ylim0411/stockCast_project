package com.spring.stockCast.repository;

import com.spring.stockCast.dto.SaleListDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class AccountingRepository {
    private final SqlSessionTemplate sql;

    public List<SaleListDTO> findAll() {
        return sql.selectList("Accounting.findAll");
    }
}
