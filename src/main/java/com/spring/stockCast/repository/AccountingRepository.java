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
public class AccountingRepository {
    private final SqlSessionTemplate sql;

}
