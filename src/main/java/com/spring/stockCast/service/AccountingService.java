package com.spring.stockCast.service;

import com.spring.stockCast.repository.AccountingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AccountingService {
    private final AccountingRepository accountingRepository;
}
