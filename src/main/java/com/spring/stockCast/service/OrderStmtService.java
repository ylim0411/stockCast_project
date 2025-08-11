package com.spring.stockCast.service;

import com.spring.stockCast.dto.OrderStmtDTO;
import com.spring.stockCast.dto.PageDTO;
import com.spring.stockCast.repository.OrderStmtRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.*;

@Service
@RequiredArgsConstructor
public class OrderStmtService {
    private final OrderStmtRepository orderStmtRepository;

    private final int pageLimit = 10;   // 한 페이지 당 표시할 데이터 수
    private final int blockLimit = 5;  // 페이지 번호 블록 수

    // 날짜 검색 + 페이징
    public List<OrderStmtDTO> findByDatePaging(Integer selectedStoreId, LocalDate startDate, LocalDate endDate, int page) {
        int pagingStart = (page - 1) * pageLimit;

        Map<String, Object> param = new HashMap<>();
        param.put("storeId", selectedStoreId);
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        param.put("start", pagingStart);
        param.put("limit", pageLimit);

        List<OrderStmtDTO> list = orderStmtRepository.findByDatePaging(param);
        return list;
    }

    // 발주번호 검색 + 페이징
    public List<OrderStmtDTO> findByNoPaging(Integer selectedStoreId, String orderStmtId, int page) {
        int pagingStart = (page - 1) * pageLimit;

        Map<String, Object> param = new HashMap<>();
        param.put("storeId", selectedStoreId);
        param.put("orderStmtId", orderStmtId);
        param.put("start", pagingStart);
        param.put("limit", pageLimit);

        List<OrderStmtDTO> list = orderStmtRepository.findByNoPaging(param);
        return list;
    }

    // 전체 목록 페이징
    public List<OrderStmtDTO> pagingList(Integer selectedStoreId, int page) {
        int pagingStart = (page - 1) * pageLimit;

        Map<String, Object> pagingParams = new HashMap<>();
        pagingParams.put("storeId", selectedStoreId);
        pagingParams.put("start", pagingStart);
        pagingParams.put("limit", pageLimit);

        return orderStmtRepository.pagingList(pagingParams);
    }

    // 전체 수(페이징)
    public int countAll(Integer selectedStoreId) {
        return orderStmtRepository.orderCount(selectedStoreId);
    }

    // 날짜 검색 수
    public int countByDate(Integer selectedStoreId, LocalDate startDate, LocalDate endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("storeId", selectedStoreId);
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        return orderStmtRepository.countByDate(param);
    }

    // 발주번호 검색 수
    public int countByNo(Integer selectedStoreId, String orderStmtId) {
        Map<String, Object> param = new HashMap<>();
        param.put("storeId", selectedStoreId);
        param.put("orderStmtId", orderStmtId);
        return orderStmtRepository.countByNo(param);
    }

    // 페이징 계산
    public PageDTO pagingParamWithSearch(int page, int totalCount) {
        int maxPage = (int) Math.ceil((double) totalCount / pageLimit);
        int startPage = (((int) Math.ceil((double) page / blockLimit)) - 1) * blockLimit + 1;
        int endPage = startPage + blockLimit - 1;
        if (endPage > maxPage) endPage = maxPage;

        PageDTO pageDTO = new PageDTO();
        pageDTO.setPage(page);
        pageDTO.setMaxPage(maxPage);
        pageDTO.setStartPage(startPage);
        pageDTO.setEndPage(endPage);
        return pageDTO;
    }

    // 발주 id 조회
    public int getLastOrderId(Integer storeId) {
        Integer lastId = orderStmtRepository.getLastOrderId(storeId);
        return lastId != null ? lastId : 0;
    }

        // 발주서 저장
    public void saveOrder(Integer selectedStoreId, int clientId, int orderSubnum, String orderDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("storeId", selectedStoreId);
        param.put("orderSubnum", orderSubnum);
        param.put("clientId", clientId);
        param.put("orderDate", orderDate);
        orderStmtRepository.insertOrder(param);
    }

    // 발주서 상세 조회
    public OrderStmtDTO findById(Integer selectedStoreId, int orderId) {
        Map<String, Object> param = new HashMap<>();
        param.put("storeId", selectedStoreId);
        param.put("orderId", orderId);
        return orderStmtRepository.findById(param);
    }

    // 발주서 수정
    public void updateOrder(Integer selectedStoreId, int clientId, int orderId, String orderDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("storeId", selectedStoreId);
        param.put("clientId", clientId);
        param.put("orderId", orderId);
        param.put("orderDate", orderDate);
        orderStmtRepository.updateOrder(param);
    }

    // 발주서 삭제
    public void deleteOrder(Integer selectedStoreId, int orderId) {
        Map<String, Object> param = new HashMap<>();
        param.put("storeId", selectedStoreId);
        param.put("orderId", orderId);

        OrderStmtDTO orderInfo = orderStmtRepository.findById(param);
        if (orderInfo == null) {
            throw new IllegalArgumentException("권한이 없거나 존재하지 않는 발주입니다.");
        }
        if ("완료".equals(orderInfo.getStatus())) {
            throw new IllegalStateException("완료된 발주서는 삭제할 수 없습니다.");
        }
        orderStmtRepository.deleteOrder(param);
    }

    // 발주서 status 변경
    public void updateStatus(Integer selectedStoreId, int orderId, String status) {
        Map<String, Object> param = new HashMap<>();
        param.put("storeId", selectedStoreId);
        param.put("orderId", orderId);
        param.put("status", status);
        orderStmtRepository.updateStatus(param);
    }

    // 연도별 발주비용 월별 조회(꺾은선 그래프 구성용) ho
    public Map<String, Integer> orderMonth(List<OrderStmtDTO> orderList) {
        Map<String, Integer> monthPrice = new LinkedHashMap<>();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // 날짜 포맷 지정

        // saleList에 있는 판매 기록을 순회합니다.
        for (OrderStmtDTO sale : orderList) {
            Date saleDate = sale.getOrderDate();
            int price = sale.getTotalPrice();
            int quantity = sale.getTotalCount();

            // Date 객체를 지정된 "yyyy-MM-dd" 형식의 문자열로 변환합니다.
            String dateKey = sdf.format(saleDate);

            int currentTotal = monthPrice.getOrDefault(dateKey, 0);
            int newTotal = currentTotal + (price * quantity);

            monthPrice.put(dateKey, newTotal);
        }

        return monthPrice;
    }

    // 이번달 발주내역 가져오기
    public List<OrderStmtDTO> findByMonth(String currentMonth) {
        return orderStmtRepository.findByMonth(currentMonth);
    }
    // 발주번호 제일 큰거 가져오기
    public int findLastOrderId() {
        return orderStmtRepository.findLastOrderId();
    }
}
