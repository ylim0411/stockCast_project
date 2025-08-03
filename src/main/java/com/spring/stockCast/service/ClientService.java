package com.spring.stockCast.service;


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

    // 거래처만 전체 조회
    public List<Map<String, Object>> getAllClients() {
        return clientRepository.findAll();
    }
}
