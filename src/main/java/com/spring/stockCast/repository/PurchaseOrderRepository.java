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

    public void insertOrderDetail(Map<String, Object> param) {
        sql.insert("PurchaseOrder.insertOrderDetail", param);
    }

    @Transactional
    public void linkAccounting(Map<String,Object> param){
        sql.insert("Accounting.insertOrder",param);
        sql.insert("Accounting.insertAccountOrderDebit",param);
        sql.insert("Accounting.insertAccountOrderCredit",param);
        sql.update("Accounting.updateEntry",param);
        sql.update("Product.updateOrder",param);
    }

    public List<PurchaseOrderDTO> findByOrderId(Map<String, Object> param) {
        return sql.selectList("PurchaseOrder.findByOrderId", param);
    }

    public void deleteByOrderId(Map<String, Object> param) {
        sql.delete("PurchaseOrder.deleteByOrderId", param);
    }
}
