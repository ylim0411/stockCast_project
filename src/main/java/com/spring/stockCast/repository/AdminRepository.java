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

    public boolean login(AdminDTO adminDTO) {
        AdminDTO result = sql.selectOne("Admin.login", adminDTO);
        if (result != null)
        {
            return true;
        }
        return false;
    }

    public boolean isJoinedById(String email) {
        AdminDTO result = sql.selectOne("Admin.isJoinedById", email);
        if (result != null)
        {
            return true;
        }
        return false;
    }
}
