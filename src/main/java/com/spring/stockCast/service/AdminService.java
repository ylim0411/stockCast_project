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

    public AdminDTO login(AdminDTO adminDTO) {
        return adminRepository.login(adminDTO);
    }

    public AdminDTO isJoinedById(String email) {
        return adminRepository.isJoinedById(email);
    }

    public boolean deleteAdminById(int adminId) {
        return adminRepository.deleteAdminById(adminId);
    }

    public boolean checkId(String loginId) {
        return adminRepository.checkId(loginId);
    }
    public boolean updateAdmin(AdminDTO adminDTO) {
        int updatedRows = adminRepository.updateAdmin(adminDTO);
        return updatedRows > 0;
    }

    public AdminDTO findById(int adminId) {
        return adminRepository.findById(adminId);
    }

    public int getStoredId(int adminId) {
        return adminRepository.getStoredId(adminId);
    }
}
