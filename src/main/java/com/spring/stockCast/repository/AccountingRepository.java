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
    // 리스트 불러오기(발주번호, 발주일자, 거래처명, 상품명, 총금액)
    public List<SaleListDTO> findAll() {
        return sql.selectList("Accounting.findAll");
    }
}
