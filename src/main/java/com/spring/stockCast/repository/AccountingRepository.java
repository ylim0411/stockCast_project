package com.spring.stockCast.repository;

import com.spring.stockCast.dto.AccoListDTO;
import com.spring.stockCast.dto.AccountItemDTO;
import com.spring.stockCast.dto.AccountingDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class AccountingRepository {
    private final SqlSessionTemplate sql;
    // 판매발주 목록 전체가져오기
    public List<AccountingDTO> findAll() {
        return sql.selectList("Accounting.findAll");
    }
    // 전체 계정과목 불러오기
    public List<AccountItemDTO> findAllItem() {
        return sql.selectList("Accounting.findAllItem");
    }
    // 날짜 검색
    public List<AccoListDTO> findByDate(Map<String, Object> param) {
        return sql.selectList("Accounting.findByDate",param);
    }
    // 해당 년도에 해당하는 거래내역 불러오기
    public List<AccoListDTO> findByYear(String year) {
        return sql.selectList("Accounting.findByYear",year);
    }
    // 회계내역이 있는 년도 불러오기
    public List<String> findAccountYear() {
        return sql.selectList("Accounting.findAccountYear");
    }
    // 불러오기 실행 메서드
    public List<Map<String, Object>> AccountLoad() {
        return sql.selectList("Accounting.load");
    }
}
