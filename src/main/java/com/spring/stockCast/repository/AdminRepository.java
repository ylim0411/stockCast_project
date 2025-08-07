package com.spring.stockCast.repository;

import com.spring.stockCast.dto.AdminDTO;
import lombok.RequiredArgsConstructor;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class AdminRepository {
    private final SqlSessionTemplate sql;

    public int join(AdminDTO adminDTO) {
        return sql.insert("Admin.join", adminDTO);
    }

    public AdminDTO login(AdminDTO adminDTO) {
        AdminDTO result = sql.selectOne("Admin.login", adminDTO);
        return result;
    }

    public AdminDTO isJoinedById(String email) {
        return sql.selectOne("Admin.isJoinedById", email);
    }

    public boolean deleteAdminById(int adminId) {
        return sql.delete("Admin.deleteAdminById", adminId) > 0;
    }
}
