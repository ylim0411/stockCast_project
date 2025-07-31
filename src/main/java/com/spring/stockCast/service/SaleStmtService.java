package com.spring.stockCast.service;


import com.spring.stockCast.repository.SaleStmtRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class SaleStmtService {
    private final SaleStmtRepository saleStmtRepository;
}
