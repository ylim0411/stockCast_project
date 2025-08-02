package com.spring.stockCast.service;


import com.spring.stockCast.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepository productRepository;

    public List<Map<String, Object>> getAllProducts() {
        return productRepository.findAll();
    }

    public Map<String, Object> getProductById(int id) {
        return productRepository.findById(id);
    }
}
