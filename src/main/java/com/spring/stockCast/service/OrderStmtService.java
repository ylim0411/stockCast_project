package com.spring.stockCast.service;


import com.spring.stockCast.dto.OrderStmtDTO;
import com.spring.stockCast.repository.OrderStmtRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class OrderStmtService {
    private final OrderStmtRepository orderStmtRepository;

    public List<OrderStmtDTO> findAll() {
        return orderStmtRepository.findAll();
    }
}
