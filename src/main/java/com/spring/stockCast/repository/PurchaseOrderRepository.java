package com.spring.stockCast.repository;

import com.spring.stockCast.dto.AccoListDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class PurchaseOrderRepository {
    private final SqlSessionTemplate sql;
    // 거래명세서 내용 불러오기
    public List<AccoListDTO> findById(int id) {
        return sql.selectList("PurchaseOrder.findById",id);
    }
}
