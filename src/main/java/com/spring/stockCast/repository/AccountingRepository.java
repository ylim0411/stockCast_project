package com.spring.stockCast.repository;

import com.spring.stockCast.dto.AccountingDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class AccountingRepository {
    private final SqlSessionTemplate sql;

    public List<AccountingDTO> findAll() {
        return sql.selectList("Accounting.findAll");
    }
}
