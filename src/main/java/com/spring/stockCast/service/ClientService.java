package com.spring.stockCast.service;


import com.spring.stockCast.dto.ClientDTO;
import com.spring.stockCast.dto.PageDTO;
import com.spring.stockCast.repository.ClientRepository;
import com.spring.stockCast.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ClientService {
    private final ClientRepository clientRepository;
    // 발주번호에 일치하는 거래처 조회
    public ClientDTO findBySaleId(int id) {
        return clientRepository.findBySaleId(id);
    }

    // 해당 storeId의 모든 거래처 목록 조회 young
    public List<ClientDTO> findByStoreId(int storeId) {
        return clientRepository.selectByStoreId(storeId);
    }

    // 해당 clientId가 존재하는지 여부 조회 young
    public boolean existsByStoreIdAndClientId(int storeId, int clientId) {
        return clientRepository.countByStoreIdAndClientId(storeId, clientId) > 0;
    }

    public List<ClientDTO> selectByAdminId(int adminId) {
        return clientRepository.selectByAdminId(adminId);
    }

    public boolean update(ClientDTO clientDTO) {
        return clientRepository.update(clientDTO);
    }

    public ClientDTO selectByClientId(int clientId) {
        return clientRepository.selectByClientId(clientId);
    }

    public boolean insert(ClientDTO clientDTO) {
        return clientRepository.insert(clientDTO);
    }

    public PageDTO pagingParamWithSearch(int page, int total) {
        int pageLimit = 10;    // 하단에 보여줄 페이지 수 (예: 1 ~ 10)
        int boardLimit = 10;   // 한 페이지에 보여줄 항목 수

        int maxPage = (int) Math.ceil((double) total / boardLimit);
        int startPage = ((page - 1) / pageLimit) * pageLimit + 1;
        int endPage = startPage + pageLimit - 1;

        if (endPage > maxPage) {
            endPage = maxPage;
        }

        PageDTO pageDTO = new PageDTO();
        pageDTO.setPage(page);
        pageDTO.setMaxPage(maxPage);
        pageDTO.setStartPage(startPage);
        pageDTO.setEndPage(endPage);

        return pageDTO;
    }

    public List<ClientDTO> selectPagingByAdminId(int adminId, int start, int limit) {
        Map<String, Object> param = new HashMap<>();
        param.put("adminId", adminId);
        param.put("start", start);
        param.put("limit", limit);
        return clientRepository.selectPagingByAdminId(param);
    }

    public int countByAdminId(int adminId) {
        return clientRepository.countByAdminId(adminId);
    }
    public List<ClientDTO> searchClientsWithPaging(int adminId, String keyword, int start, int limit) {
        Map<String, Object> param = new HashMap<>();
        param.put("adminId", adminId);
        param.put("keyword", "%" + keyword + "%");
        param.put("start", start);
        param.put("limit", limit);
        return clientRepository.searchClientsWithPaging(param);
    }

    // 검색 키워드 기반 거래처 총 개수 조회
    public int countClientsByKeyword(int adminId, String keyword) {
        Map<String, Object> param = new HashMap<>();
        param.put("adminId", adminId);
        param.put("keyword", "%" + keyword + "%");
        return clientRepository.countClientsByKeyword(param);
    }

}
