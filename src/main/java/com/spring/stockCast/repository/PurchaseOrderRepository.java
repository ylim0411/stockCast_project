package com.spring.stockCast.repository;


import com.spring.stockCast.dto.PurchaseOrderDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;


import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Repository
@RequiredArgsConstructor
public class PurchaseOrderRepository {

    private final SqlSessionTemplate sql;

    // 발주 상세 저장
    public void insertOrderDetail(int orderId, int productId, int purchasePrice, int purchaseQty) {
        Map<String, Object> param = new HashMap<>();
        param.put("orderId", orderId);
        param.put("productId", productId);
        param.put("purchasePrice", purchasePrice);
        param.put("purchaseQty", purchaseQty);

        sql.insert("PurchaseOrder.insertOrderDetail", param);
    }

    @Transactional
    // 상태 완료 변경시 발주로 인한 재고, 회계 연동
    public void linkAccounting(Map<String,Object> param){
        sql.insert("Accounting.insertOrder",param); // 발주완료시 accounting(회계거래) 추가 ho
        sql.insert("Accounting.insertAccountOrderDebit",param); // 회계거래와 계정 연동 차변(재고자산 추가) ho
        sql.insert("Accounting.insertAccountOrderCredit",param); // 회계거래와 계정 연동 대변(미지급금 추가) ho
        sql.update("Accounting.updateEntry",param); // 차변대변 입력된 테이블 구분 false -> true 전환 ho
        sql.update("Product.updateOrder",param); // 발주시 상품 재고 증가 ho
    }
    // 발주 상세 목록 조회
    public List<PurchaseOrderDTO> findByOrderId(int orderId) {
        return sql.selectList("PurchaseOrder.findByOrderId", orderId);

    }

    // 발주 상세 삭제
    public void deleteOrder(int orderId) {
        sql.delete("Orders.deleteOrder", orderId);
    }

    public void deleteByOrderId(int orderId) {
        sql.delete("PurchaseOrder.deleteByOrderId", orderId);
    }
}
