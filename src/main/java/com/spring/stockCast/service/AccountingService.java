package com.spring.stockCast.service;

import com.spring.stockCast.dto.SaleListDTO;
import com.spring.stockCast.repository.AccountingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
public class AccountingService {
    private final AccountingRepository accountingRepository;

    // 거래명세서 리스트 뽑아오기
    public List<SaleListDTO> findAll() {
        return accountingRepository.findAll();
    }

    public List<SaleListDTO> findByNo(String orderNumber) {
        return accountingRepository.findByNo(orderNumber);
    }

    public List<SaleListDTO> findByDate(LocalDate startDate, LocalDate endDate) {
        return accountingRepository.findByDate(startDate,endDate);
    }
}
