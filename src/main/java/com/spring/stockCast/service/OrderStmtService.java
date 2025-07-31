package com.spring.stockCast.service;


import com.spring.stockCast.dto.OrderStmtDTO;
import com.spring.stockCast.repository.OrderStmtRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderStmtService {
    private final OrderStmtRepository orderStmtRepository;

    public List<OrderStmtDTO> findAll() {
        return orderStmtRepository.findAll();
    }

    public List<OrderStmtDTO> findByDate(LocalDate startDate, LocalDate endDate) {
        return orderStmtRepository.findByDateBetween(startDate,endDate);
    }

    public List<OrderStmtDTO> findByNo(String orderStmtId) {
        return orderStmtRepository.findByNo(orderStmtId);
    }
}
