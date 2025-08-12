package com.spring.stockCast.service;


import com.spring.stockCast.dto.StoreDTO;
import com.spring.stockCast.repository.StoreRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class StoreService {
    private final StoreRepository storeRepository;

    public List<StoreDTO> selectAll(int adminId) {
        return storeRepository.selectAll(adminId);
    }

    public void update(StoreDTO storeDTO) {
        storeRepository.update(storeDTO);
    }

    public void save(StoreDTO storeDTO) {
        storeRepository.save(storeDTO);
    }

    public int countByAdminId(int adminId, String searchKeyword) {
        return storeRepository.countByAdminId(adminId,searchKeyword);
    }

    public List<StoreDTO> selectPageByAdminId(int adminId, int offset, int limit, String searchKeyword) {
        return storeRepository.selectPageByAdminId(adminId, offset, limit, searchKeyword);
    }
}
