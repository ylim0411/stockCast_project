package com.spring.stockCast.service;


import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.dto.SaleDTO;
import com.spring.stockCast.enums.Gender;
import com.spring.stockCast.repository.ProductRepository;
import com.spring.stockCast.repository.SaleRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
@RequiredArgsConstructor
public class SaleService {
    private final SaleRepository saleRepository;
    private final ProductRepository productRepository;
    // 판매내역이 있는 년도 불러오기
    public List<String> findSaleYear(){
        return saleRepository.findSaleYear();
    }
    // 해당 년도에 해당하는 판매내역 불러오기
    public List<SaleDTO> findByYear(String year) { return saleRepository.findByYear(year); }
    // 이번달 판매목록 불러오기
    public List<SaleDTO> findByMonth(String currentMonth) { return saleRepository.findByMonth(currentMonth); }
    // 기간 판매내역 불러오기
    public List<SaleDTO> findByDate(LocalDate startDate, LocalDate endDate) { return saleRepository.findByDate(startDate,endDate); }
    // 점포 아이디에 맞는 상품목록 가져오기
    public List<ProductDTO> findProductSaleAll(String storeId){ return productRepository.findProductSaleAll(storeId);};
    // 판매내역 중 제일 최신의 saleId 가져오기
    public int findMaxSaleId(){ return saleRepository.findMaxSaleId();}
    // 판매점포 이름 가져오기
    public String findStoreName(String storeId) { return saleRepository.findStoreName(storeId); }
    // 판매실적 상위 5개 물품 조회
    public List<String> findTop5(String storeId){ return saleRepository.findTop5(storeId);}
    // 상품이름으로 상품아이디 찾기
    public int findProductId(String pName, String storeId) {
        Map<String,Object> result = new HashMap<>();
        result.put("pName", pName);
        result.put("storeId",storeId);
        return saleRepository.findProductId(result); }
    // 재고 적을시 수량 반환
    public int findProductStock(String storeId, String productName) { return saleRepository.findProductStock(storeId, productName); }
    // 전체 판매내역의 카테고리 리스트 가져오기(도넛차트 구성용)
    public Map<String, Integer> findCategory(List<SaleDTO> saleList) {
        Map<String, Integer> categorySales = new HashMap<>();
        for (SaleDTO sale : saleList) {
            String categoryName = sale.getCategoryName();
            int saleQty = sale.getSaleQty();

            categorySales.put(categoryName, categorySales.getOrDefault(categoryName, 0) + saleQty);
        }
        return categorySales;
    }
    // 연도별 매출액 일별 조회(꺾은선 그래프 구성용)
    public Map<String, Integer> saleDay(List<SaleDTO> saleList) {
        Map<String, Integer> dayPrice = new LinkedHashMap<>();

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 포맷 지정

        // saleList에 있는 판매 기록을 순회합니다.
        for (SaleDTO sale : saleList) {
            Date saleDate = sale.getSaleDate();
            int price = sale.getSalePrice();
            int quantity = sale.getSaleQty();

            // Date 객체를 지정된 "yyyy-MM-dd" 형식의 문자열로 변환합니다.
            String dateKey = sdf.format(saleDate);

            int currentTotal = dayPrice.getOrDefault(dateKey, 0);
            int newTotal = currentTotal + (price * quantity);

            dayPrice.put(dateKey, newTotal);
        }

        return dayPrice;
    }

    public Map<String, Integer> saleMonth(List<SaleDTO> saleList) {
        Map<String, Integer> monthPrice = new LinkedHashMap<>();
        for (int i = 1; i <= 12; i++) {
            monthPrice.put(i + "월", 0);
        }
        for (SaleDTO sale : saleList) {
            int monthNumber = sale.getSaleDate().getMonth() + 1;
            String monthKey = monthNumber + "월";
            int currentTotal = monthPrice.get(monthKey);
            int newTotal = currentTotal + (sale.getSalePrice() * sale.getSaleQty());
            monthPrice.put(monthKey, newTotal);
        }

        return monthPrice;
    }
    // 판매실적 컨트롤러
    public Map<String,Object> saleController(LocalDate startDate, LocalDate endDate, String year) {
        String findDate="";
        List<SaleDTO> sales;
        // 날짜 필터가 있을 때만 검색
        if (startDate != null && endDate != null) {
            sales = findByDate(startDate, endDate); // 기간 판매내역 불러오기
            findDate = startDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"))+"~"+endDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        }
        // 연도 선택시에만 검색
        else if(year != null && !year.isEmpty()){
            sales = findByYear(year); // 해당 년도에 해당하는 판매내역 불러오기
            findDate = year;
        }else {
            LocalDate today = LocalDate.now(); // 오늘날짜 불러오기
            String currentYear = String.valueOf(today.getYear()); // 오늘날짜의 연도 추출
            sales = findByYear(currentYear); // 올해 거래내역 불러오기
        }
        Map<String,Object> result = new HashMap<>();
        result.put("findDate",findDate); // 화면에 표시될 선택된 날짜
        result.put("saleList", sales); // 판매 건수에대한 전체 정보
        result.put("saleCategory", findCategory(sales)); // 판매된 카테고리 및 가격
        result.put("monthPrice", saleMonth(sales)); // 판매된 월, 매출액 맵으로 전달
        result.put("saleYear", findSaleYear()); // 판매내역이 있는 년도 리스트로 전달

        return result;
    }
    // 실제 판매 컨트롤러
    public Map<String, Object> saleOrderController(HttpSession session) {

        String storeId = session.getAttribute("selectedStoredId").toString(); // StoreController 에서 저장한 id 받아오기
        List<ProductDTO> products = findProductSaleAll(storeId); // 점포 id를 통해 점포 상품들 불러오기

        Map<String,Object> result = new HashMap<>();
        for(ProductDTO dto : products){
            result.put(dto.getProductName(),dto.getPrice()); // 상품명(key), 가격(value) 입력
        }
        result.put("today",LocalDate.now()); // 오늘날짜 전달
        result.put("products",products); // 점포 id를 통해 점포 상품들 불러오기
        result.put("maxSaleId",(findMaxSaleId()+1)); // 주문번호 표시
        result.put("storeName",findStoreName(storeId)); // 점포이름 전달
        return result;
    }

    // 판매상품을 등록할 수 있는 목록 생성
    public void saleCreateStmt(String saleId, String storeId, LocalDate today) {
        saleRepository.saleCreateStmt(saleId,storeId,today);
    }

    // 판매상품 DB에 저장
    public void saleSave(String saleId, LocalDate today, int productId, Integer qty) {
        Map<String, Object> param = new HashMap<>();
        param.put("saleId", saleId);
        param.put("today", today);
        param.put("productId",productId);
        param.put("qty",qty);

        saleRepository.saleSave(param);
    }

    // 판매 이후 회계 (accounting) 연동 및 재고 증가
    public void linkAccounting(String saleId, LocalDate today, int productId, Integer qty) {
        Map<String, Object> param = new HashMap<>();
        param.put("saleId", saleId);
        param.put("today", today);
        param.put("productId", productId);
        param.put("qty", qty);

        saleRepository.linkAccounting(param);
    }
    // 구매자등록
    public void insertCustomer(String gender, String age, String storeId) {
        Map<String, Object> param = new HashMap<>();
        Gender resultGender = null;
        int resultAge = 0;
        switch (gender){
            case "man":
                resultGender = Gender.남;
                break;
            case "woman":
                resultGender = Gender.여;
                break;
        }
        switch (age){
            case "10s":
                resultAge = 15;
                break;
            case "20s":
                resultAge = 25;
                break;
            case "30s":
                resultAge = 35;
                break;
            case "40s":
                resultAge = 45;
                break;
            case "atc":
                resultAge = 75;
                break;
        }
        param.put("gender",resultGender);
        param.put("age",resultAge);
        param.put("storeId",storeId);
        saleRepository.insertCustomer(param);
    }
}
