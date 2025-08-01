package com.spring.stockCast.service;

import com.spring.stockCast.repository.OrderingRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class OrderingService {
    private final OrderingRepository orderingRepository;
}
