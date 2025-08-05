package com.spring.stockCast.service;

import com.spring.stockCast.dto.AccountItemDTO;
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

    // 판매발주 목록 전체가져오기
    public List<AccountItemDTO> findAll() {
        return accountingRepository.findAll();
    }
}
