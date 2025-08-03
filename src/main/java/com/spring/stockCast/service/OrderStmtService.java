package com.spring.stockCast.service;

import com.spring.stockCast.dto.OrderStmtDTO;
import com.spring.stockCast.enums.OrderStatus;
import com.spring.stockCast.repository.OrderStmtRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderStmtService {
    private final OrderStmtRepository orderStmtRepository;

    // 전체 발주 조회
    public List<OrderStmtDTO> findAll() {
        List<OrderStmtDTO> list = orderStmtRepository.findAll();
        setOrderStatus(list);
        return list;
    }

    // 날짜 범위로 발주 조회
    public List<OrderStmtDTO> findByDate(LocalDate startDate, LocalDate endDate) {
        List<OrderStmtDTO> list = orderStmtRepository.findByDateBetween(startDate, endDate);
        setOrderStatus(list);
        return list;
    }

    // 발주번호로 발주 조회
    public List<OrderStmtDTO> findByNo(String orderStmtId) {
        List<OrderStmtDTO> list = orderStmtRepository.findByNo(orderStmtId);
        setOrderStatus(list);
        return list;
    }

    // 발주 상태(진행중 / 완료) 설정, -> 취소는 아직...
    private void setOrderStatus(List<OrderStmtDTO> list) {
        LocalDate today = LocalDate.now();

        for (OrderStmtDTO dto : list) {
            LocalDate orderDate = dto.getOrderDate().toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDate();
            if (!orderDate.plusDays(3).isBefore(today)) {
                dto.setStatus(OrderStatus.진행중);
            } else {
                dto.setStatus(OrderStatus.완료);
            }
        }
    }

    // 마지막 발주 ID 조회
    public int getLastOrderId() {
        Integer lastId = orderStmtRepository.getLastOrderId();
        return (lastId != null) ? lastId : 0;
    }

}
