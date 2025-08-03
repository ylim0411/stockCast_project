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

    public List<OrderStmtDTO> findAll() {
        List<OrderStmtDTO> list = orderStmtRepository.findAll();
        setOrderStatus(list);
        return list;
    }

    public List<OrderStmtDTO> findByDate(LocalDate startDate, LocalDate endDate) {
        List<OrderStmtDTO> list = orderStmtRepository.findByDateBetween(startDate, endDate);
        setOrderStatus(list);
        return list;
    }

    public List<OrderStmtDTO> findByNo(String orderStmtId) {
        List<OrderStmtDTO> list = orderStmtRepository.findByNo(orderStmtId);
        setOrderStatus(list);
        return list;
    }

    // 상태 계산 (10일 기준)
    private void setOrderStatus(List<OrderStmtDTO> list) {
        LocalDate today = LocalDate.now();

        for (OrderStmtDTO dto : list) {
            LocalDate orderDate = dto.getOrderDate().toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDate();

            // 3일 안 지났으면 진행중
            if (!orderDate.plusDays(3).isBefore(today)) {
                dto.setStatus(OrderStatus.진행중);
            } else {
                dto.setStatus(OrderStatus.완료);
            }
        }
    }
}
