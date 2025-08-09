package com.spring.stockCast.repository;

import com.spring.stockCast.dto.SaleDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
@RequiredArgsConstructor
public class SaleRepository {
    private final SqlSessionTemplate sql;

    // 전체 판매내역 불러오기
    public List<SaleDTO> findAll() {
        return sql.selectList("Sale.findAll");
    }
    // 판매내역이 있는 년도 불러오기
    public List<String> findSaleYear() {
        return sql.selectList("Sale.findSaleYear");
    }
    // 해당 년도에 해당하는 판매내역 불러오기
    public List<SaleDTO> findByYear(String year) {
        return sql.selectList("Sale.findByYear",year);
    }
    // 기간 판매내역 불러오기
    public List<SaleDTO> findByDate(LocalDate startDate, LocalDate endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        return sql.selectList("Sale.findByDateBetween", param);
    }
    // 판매내역 중 제일 큰 id 가져오기(주문번호 표시용)
    public int findMaxSaleId() {
        return sql.selectOne("Sale.findMaxSaleId");
    }
    // 판매상품을 등록할 수 있는 목록 생성
    public void saleCreateStmt(String saleId, LocalDate today) {
        Map<String,Object> param = new HashMap<>();
        param.put("saleId",saleId);
        param.put("today",today);
        sql.insert("saleCreateStmt",param);
    }
    // 판매상품 DB에 저장
    public void saleSave(Map<String, Object> param) {
        sql.insert("Sale.saleSave",param);
    }
    @Transactional
    // 판매로 인한 재고, 회계 연동
    public void linkAccounting(Map<String,Object> param){
        sql.insert("Sale.insertOrder",param); // 판매완료시 accounting(회계거래) 추가 ho
        sql.insert("Sale.insertAccountOrderDebit",param); // 회계거래와 계정 연동 차변(외상매출금 추가) ho
        sql.insert("Sale.insertAccountOrderCredit",param); // 회계거래와 계정 연동 대변(상품매출 추가) ho
        sql.update("Sale.updateEntry",param); // 차변대변 입력된 테이블 구분 false -> true 전환 ho
        sql.update("Product.updateSale",param); // 발주시 상품 재고 증가 ho
    }
    // 상품 이름으로 상품아이디 찾기
    public int findProductId(String pName) {
        return sql.selectOne("Sale.findProductId",pName);
    }
    // 재고 적을시 수량 반환
    public int findProductStock(String storeId,String productName) {
        Map<String, Object> params = new HashMap<>();
        params.put("storeId", storeId);
        params.put("productName", productName);
        return sql.selectOne("Sale.findProductStock",params);
    }
    // 판매점포 이름 가져오기
    public String findStoreName(String storeId) {
        return sql.selectOne("Sale.findStoreName",storeId);
    }
}
