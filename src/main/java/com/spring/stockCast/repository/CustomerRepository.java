package com.spring.stockCast.repository;

import com.spring.stockCast.dto.CustomerDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class CustomerRepository {
    private final SqlSessionTemplate sql;
    // 구매자 전부를 가져오기
    public List<CustomerDTO> findAll(String storeId) {
        return sql.selectList("Customer.findAll",storeId);
    }
}
