package com.spring.stockCast.service;

import com.spring.stockCast.dto.AccoListDTO;
import com.spring.stockCast.dto.AccountItemDTO;
import com.spring.stockCast.dto.AccountingDTO;
import com.spring.stockCast.dto.SaleListDTO;
import com.spring.stockCast.enums.AccountType;
import com.spring.stockCast.enums.Direction;
import com.spring.stockCast.repository.AccountingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
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

    // 동일한 이름의 value 더해서 맵으로 뽑기
    public Map<String, Integer> findValue(List<AccoListDTO> accounts) {
        Map<String, Integer> result = new HashMap<>();
        Map<Integer, String> accountItemMap = new HashMap<>();
        List<AccountItemDTO> allAccountItems = accountingRepository.findAllItem();
        int totalDebit = 0, totalCredit =0;
        // item에 있던 id와 name을 key value로 전환
        for (AccountItemDTO item : allAccountItems) {
            accountItemMap.put(item.getItemId(), item.getName());
        }
        // item 이름(key)에 acco 값(value) 저장
        for (AccoListDTO acco : accounts) {
            String itemName = accountItemMap.get(acco.getItemId());
            if (itemName != null) {
                result.put(itemName, result.getOrDefault(itemName, 0) + acco.getValue());
                if(acco.getDirection().equals(Direction.차변)){
                    totalDebit+=acco.getValue();
                }else if(acco.getDirection().equals(Direction.대변)){
                    totalCredit+=acco.getValue();
                }
            }
        }

        result.put("totalDebit",totalDebit);
        result.put("totalCredit",totalCredit);
        return result;
    }

    // 컨트롤러 작업
    public Map<String,Object> controller(LocalDate startDate, LocalDate endDate, String year) {
        AccountingDTO pageData = getAccountingPageData(); // 존재하는 모든 계정 불러오기
        String findDate="";
        List<AccoListDTO> accounts;

        // 날짜 필터가 있을 때만 검색
        if (startDate != null && endDate != null) {
            accounts = findByDate(startDate, endDate); // 기간 거래내역 불러오기
            findDate = startDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))+"~"+endDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }
        // 연도 선택시에만 검색
        else if(year != null && !year.isEmpty()){
            accounts = findByYear(year); // 해당 년도에 해당하는 판매내역 불러오기
            findDate = year;
        }else {
            LocalDate today = LocalDate.now(); // 오늘날짜 불러오기
            String currentYear = String.valueOf(today.getYear()); // 오늘날짜의 연도 추출
            accounts = findByYear(currentYear); // 올해 거래내역 불러오기
        }
        Map<String, Integer> accountValues = findValue(accounts); // 계정이름(key),가격(value) 들은 맵 전달

        Map<String,Object> result = new HashMap<>();
        result.put("valueData",accounts); // 회계날짜, 계정아이디, 값 각 기간별 구분됨
        result.put("pageData", pageData); // AccountingDTO 모음
        result.put("startDate", startDate); // 2025-07-30
        result.put("endDate", endDate); // 2025-08-06
        result.put("findDate",findDate); // 화면에 표시될 선택된 날짜
        result.put("accountYear",findAccountYear()); // 회계내역이 있는 년도 리스트로 전달 2024,2025 등
        result.put("accountValues",accountValues); // 계정이름(key),가격(value) 들은 맵 전달
        return result;
    }
}
