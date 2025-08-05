package com.spring.stockCast.service;

import com.spring.stockCast.dto.OrderStmtDTO;
import com.spring.stockCast.dto.PageDTO;
import com.spring.stockCast.enums.OrderStatus;
import com.spring.stockCast.repository.OrderStmtRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class OrderStmtService {
    private final OrderStmtRepository orderStmtRepository;

    private final int pageLimit = 10;   // 한 페이지 당 표시할 데이터 수
    private final int blockLimit = 5;  // 페이지 번호 블록 수

    // 날짜 검색 + 페이징
    public List<OrderStmtDTO> findByDatePaging(LocalDate startDate, LocalDate endDate, int page) {
        int pagingStart = (page - 1) * pageLimit;

        Map<String, Object> param = new HashMap<>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        param.put("start", pagingStart);
        param.put("limit", pageLimit);

        List<OrderStmtDTO> list = orderStmtRepository.findByDatePaging(param);
        setOrderStatus(list);
        return list;
    }

    // 발주번호 검색 + 페이징
    public List<OrderStmtDTO> findByNoPaging(String orderStmtId, int page) {
        int pagingStart = (page - 1) * pageLimit;

        Map<String, Object> param = new HashMap<>();
        param.put("orderStmtId", orderStmtId);
        param.put("start", pagingStart);
        param.put("limit", pageLimit);

        List<OrderStmtDTO> list = orderStmtRepository.findByNoPaging(param);
        setOrderStatus(list);
        return list;
    }

    // 전체 목록 페이징
    public List<OrderStmtDTO> pagingList(int page) {
        int pagingStart = (page - 1) * pageLimit;

        Map<String, Integer> pagingParams = new HashMap<>();
        pagingParams.put("start", pagingStart);
        pagingParams.put("limit", pageLimit);

        List<OrderStmtDTO> list = orderStmtRepository.pagingList(pagingParams);
        setOrderStatus(list);
        return list;
    }

    // 전체 수(페이징)
    public int countAll() {
        return orderStmtRepository.orderCount();
    }

    // 날짜 검색 수
    public int countByDate(LocalDate startDate, LocalDate endDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("startDate", startDate);
        param.put("endDate", endDate);
        return orderStmtRepository.countByDate(param);
    }

    // 발주번호 검색 수
    public int countByNo(String orderStmtId) {
        return orderStmtRepository.countByNo(orderStmtId);
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

    // 발주 상태 계산
    private void setOrderStatus(List<OrderStmtDTO> list) {
        LocalDate today = LocalDate.now();
        for (OrderStmtDTO dto : list) {
            LocalDate orderDate = dto.getOrderDate().toInstant()
                    .atZone(ZoneId.systemDefault())
                    .toLocalDate();
            dto.setStatus(!orderDate.plusDays(3).isBefore(today) ? OrderStatus.진행중 : OrderStatus.완료);
        }
    }

    // 발주 id 조회
    public int getLastOrderId() {
        Integer lastId = orderStmtRepository.getLastOrderId();
        return lastId != null ? lastId : 0;
    }

    // 발주서 저장
    public void saveOrder(int clientId, int orderId, String orderDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("orderId", orderId);
        param.put("clientId", clientId);
        param.put("orderDate", orderDate);
        orderStmtRepository.insertOrder(param);
    }

    // 발주서 상세 조회
    public OrderStmtDTO findById(int orderId) {
        return orderStmtRepository.findById(orderId);
    }

    // 발주서 수정
    public void updateOrder(int clientId, int orderId, String orderDate) {
        Map<String, Object> param = new HashMap<>();
        param.put("clientId", clientId);
        param.put("orderId", orderId);
        param.put("orderDate", orderDate);
        orderStmtRepository.updateOrder(param);
    }

    // 발주서 삭제
    public void deleteOrder(int orderId) {
        orderStmtRepository.deleteOrder(orderId);
    }
}
