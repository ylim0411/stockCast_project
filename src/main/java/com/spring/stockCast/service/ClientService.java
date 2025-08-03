package com.spring.stockCast.service;


import com.spring.stockCast.dto.ClientDTO;
import com.spring.stockCast.repository.ClientRepository;
import com.spring.stockCast.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

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

    // 거래처만 전체 조회
    public List<Map<String, Object>> getAllClients() {
        return clientRepository.findAll();
    }
}
