package com.spring.stockCast.service;



import com.spring.stockCast.dto.AdminDTO;

import com.spring.stockCast.repository.AdminRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AdminService {
    private final AdminRepository adminRepository;

    public int join(AdminDTO adminDTO) {
        return adminRepository.join(adminDTO);
    }

    public boolean login(AdminDTO adminDTO) {
        return adminRepository.login(adminDTO);
    }
}
