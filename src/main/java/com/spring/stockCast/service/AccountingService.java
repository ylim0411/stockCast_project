package com.spring.stockCast.service;

import com.spring.stockCast.dto.AccountingDTO;
import com.spring.stockCast.repository.AccountingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AccountingService {
    private final AccountingRepository accountingRepository;

    public List<AccountingDTO> findAll() {
        return accountingRepository.findAll();
    }
}
