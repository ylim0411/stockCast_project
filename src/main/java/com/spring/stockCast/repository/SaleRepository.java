package com.spring.stockCast.repository;

import com.spring.stockCast.dto.SaleDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class SaleRepository {
    private final SqlSessionTemplate sql;

    // 전체 판매내역 불러오기
    public List<SaleDTO> findAll() {
        return sql.selectList("Sale.findAll");
    }
}
