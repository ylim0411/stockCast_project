package com.spring.stockCast.service;

import com.spring.stockCast.dto.AccoListDTO;
import com.spring.stockCast.repository.OrderingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
@RequiredArgsConstructor
public class OrderingService {
    private final OrderingRepository orderingRepository;

    public List<AccoListDTO> findById(int id) {
        return orderingRepository.findById(id);
    }
}
