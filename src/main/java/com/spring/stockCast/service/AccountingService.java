package com.spring.stockCast.service;

import com.spring.stockCast.dto.AccoListDTO;
import com.spring.stockCast.dto.AccountItemDTO;
import com.spring.stockCast.dto.AccountingDTO;
import com.spring.stockCast.enums.AccountType;
import com.spring.stockCast.enums.Direction;
import com.spring.stockCast.repository.AccountingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AccountingService {
    private final AccountingRepository accountingRepository;

    // 판매발주 목록 전체가져오기
    public List<AccountingDTO> findAll(String storeId) {
        return accountingRepository.findAll(storeId);
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

        return AccountingDTO.builder()
                .assetsList(assetsList)
                .liabilitiesList(liabilitiesList)
                .capitalList(capitalList)
                .revenueList(revenueList)
                .expenseList(expenseList)
                .build();
    }

    // 기간에 맞는 거래내역 불러오기
    public List<AccoListDTO> findByDate(LocalDate startDate, LocalDate endDate, String storeId) {
        Map<String, Object> param = new HashMap<>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        param.put("storeId", storeId);

        return accountingRepository.findByDate(param);
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
    // 불러오기 실행 메서드
    public Map<String, Integer> AccountLoad(){
        List<Map<String, Object>> rawData = accountingRepository.AccountLoad();
        Map<String, Integer> result = new HashMap<>();

        if (rawData != null && !rawData.isEmpty()) {
            for (Map<String, Object> row : rawData) {
                String name = (String) row.get("name");
                Object valueObj = row.get("value");
                Integer value = 0;

                // Object 타입을 Integer로 안전하게 변환
                if (valueObj instanceof Number) {
                    value = ((Number) valueObj).intValue();
                }

                if (name != null) {
                    result.put(name, value);
                }
            }
        }
        return result;
    }
    // 컨트롤러 작업
    public Map<String,Object> controller(LocalDate startDate, LocalDate endDate, String year, String btn,String action, HttpSession session) {
        AccountingDTO pageData = getAccountingPageData(); // 존재하는 모든 계정 불러오기
        String findDate="";
        List<AccoListDTO> accounts;
        String storeId = session.getAttribute("selectedStoredId").toString(); // 로그인된 계정의 점포 id 불러오기
        // 최초 진입시 isLoad null을 false(점포매출)로 변경
        if (session.getAttribute("isLoad") == null) {
            session.setAttribute("isLoad", false);
        }
        String sessionYear = (String) session.getAttribute("selectedYear"); // 당월, 분기 등 선택시 적용
        // 세션에 year 있으면 가져와서 적용
        if (year != null && !year.isEmpty()) {
            session.setAttribute("selectedYear", year);
        }
        else if (sessionYear == null) {
            year = String.valueOf(LocalDate.now().getYear());
            session.setAttribute("selectedYear", year);
        }
        else {
            year = sessionYear;
        }
        // 불러오기 버튼 클릭시 session 업로드
        if ("load".equals(action)) {
            session.setAttribute("isLoad", true);
        } else if ("store".equals(action)) {
            session.setAttribute("isLoad", false);
        }

        // 당월, 분기 등 버튼 선택시 적용
        if(btn != null && !btn.isEmpty()){
            int currentYear = Integer.parseInt(year);

            switch (btn){
                case "cMonth": // 당월
                    LocalDate now = LocalDate.now();
                    startDate = now.withDayOfMonth(1);
                    endDate = now.withDayOfMonth(now.lengthOfMonth());
                    break;
                case "1q": // 1분기
                    startDate = LocalDate.of(currentYear, 1, 1);
                    endDate = LocalDate.of(currentYear, 3, 31);
                    break;
                case "2q": // 2분기
                    startDate = LocalDate.of(currentYear, 4, 1);
                    endDate = LocalDate.of(currentYear, 6, 30);
                    break;
                case "3q": // 3분기
                    startDate = LocalDate.of(currentYear, 7, 1);
                    endDate = LocalDate.of(currentYear, 9, 30);
                    break;
                case "4q": // 4분기
                    startDate = LocalDate.of(currentYear, 10, 1);
                    endDate = LocalDate.of(currentYear, 12, 31);
                    break;
                case "first": // 상반기
                    startDate = LocalDate.of(currentYear, 1, 1);
                    endDate = LocalDate.of(currentYear, 6, 30);
                    break;
                case "second": // 하반기
                    startDate = LocalDate.of(currentYear, 7, 1);
                    endDate = LocalDate.of(currentYear, 12, 31);
                    break;
            }
        }

        // 날짜 필터가 있을 때만 검색
        if (startDate != null && endDate != null) {
            accounts = findByDate(startDate, endDate,storeId); // 기간 거래내역 불러오기
            findDate = startDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd")) + "~" + endDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }else {
            // 연도가 null이거나 비어있으면 현재 연도로 설정
            if (year == null || year.isEmpty()) {
                year = String.valueOf(LocalDate.now().getYear());
            }
            startDate = LocalDate.of(Integer.parseInt(year), 1, 1);
            endDate = LocalDate.of(Integer.parseInt(year), 12, 31);
            accounts = findByDate(startDate, endDate,storeId); // findByYear 대신 findByDate 사용
            findDate = year; // 화면 표시용은 연도만 표기
        }
        Map<String, Integer> accountValues = findValue(accounts); // 계정이름(key),가격(value) 들은 맵 전달
        // 불러오기에 따른 데이터 삽입 및 삭제
        if((boolean) session.getAttribute("isLoad")){
            accountValues.putAll(AccountLoad());
        }
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
