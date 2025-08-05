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
}
