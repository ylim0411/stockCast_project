package com.spring.stockCast.service;


import com.spring.stockCast.dto.ProductDTO;
import com.spring.stockCast.repository.ProductRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductService {
    private final ProductRepository productRepository;

    public List<ProductDTO> findProductList() {
        return productRepository.findProductList();
    }

    public void delete(int productId) {
        productRepository.delete(productId);
    }
}
