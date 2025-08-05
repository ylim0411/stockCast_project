package com.spring.stockCast.service;


import com.spring.stockCast.dto.SaleListDTO;
import com.spring.stockCast.repository.SaleStmtRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class SaleStmtService {
    private final SaleStmtRepository saleStmtRepository;
    // 거래명세서 리스트 뽑아오기
    public List<SaleListDTO> findAll() {
        return saleStmtRepository.findAll();
    }

    public List<SaleListDTO> findByNo(String orderNumber) {
        return saleStmtRepository.findByNo(orderNumber);
    }

    public List<SaleListDTO> findByDate(LocalDate startDate, LocalDate endDate) {
        return saleStmtRepository.findByDate(startDate,endDate);
    }
}
