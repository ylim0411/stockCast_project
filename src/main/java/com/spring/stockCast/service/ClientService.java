package com.spring.stockCast.service;


import com.spring.stockCast.dto.ClientDTO;
import com.spring.stockCast.repository.ClientRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class ClientService {
    private final ClientRepository clientRepository;

    public ClientDTO findBySaleId(int id) {
        return clientRepository.findBySaleId(id);
    }
}
