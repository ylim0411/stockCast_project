package com.spring.stockCast.service;

import com.spring.stockCast.dto.AccoListDTO;
import com.spring.stockCast.dto.AccountItemDTO;
import com.spring.stockCast.dto.AccountingDTO;
import com.spring.stockCast.dto.SaleListDTO;
import com.spring.stockCast.enums.AccountType;
import com.spring.stockCast.repository.AccountingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AccountingService {
    private final AccountingRepository accountingRepository;

    // 판매발주 목록 전체가져오기
    public List<AccountingDTO> findAll() {
        return accountingRepository.findAll();
    }
    // 각 계정 항목 가져오기
    public AccountingDTO getAccountingPageData() {
        List<AccountItemDTO> allAccountItems = accountingRepository.findAllItem();

        List<AccountItemDTO> assetsList = allAccountItems.stream()
                .filter(item -> item.getAccount_type() == AccountType.자산)
                .collect(Collectors.toList());
        List<AccountItemDTO> liabilitiesList = allAccountItems.stream()
                .filter(item -> item.getAccount_type() == AccountType.부채)
                .collect(Collectors.toList());
        List<AccountItemDTO> capitalList = allAccountItems.stream()
                .filter(item -> item.getAccount_type() == AccountType.자본)
                .collect(Collectors.toList());
        List<AccountItemDTO> revenueList = allAccountItems.stream()
                .filter(item -> item.getAccount_type() == AccountType.수익)
                .collect(Collectors.toList());
        List<AccountItemDTO> expenseList = allAccountItems.stream()
                .filter(item -> item.getAccount_type() == AccountType.비용)
                .collect(Collectors.toList());

        long totalDebit = 1000000;
        long totalCredit = 1000000;

        return AccountingDTO.builder()
                .assetsList(assetsList)
                .liabilitiesList(liabilitiesList)
                .capitalList(capitalList)
                .revenueList(revenueList)
                .expenseList(expenseList)
                .totalDebit(totalDebit)
                .totalCredit(totalCredit)
                .build();
    }
    // 기간에 맞는 거래내역 불러오기
    public List<AccoListDTO> findByDate(LocalDate startDate, LocalDate endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);

        return accountingRepository.findByDate(param);
    }
    // 해당 년도에 해당하는 거래내역 불러오기
    public List<AccoListDTO> findByYear(String year) {
        return accountingRepository.findByYear(year);
    }
    // 회계내역이 있는 년도 불러오기
    public List<String> findAccountYear() {
        return accountingRepository.findAccountYear();
    }
}
