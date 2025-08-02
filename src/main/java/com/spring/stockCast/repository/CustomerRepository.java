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

    public List<CustomerDTO> findAll() {
        return sql.selectList("Customer.findAll");
    }
}
