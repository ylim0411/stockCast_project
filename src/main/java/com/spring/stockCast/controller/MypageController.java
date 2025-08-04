package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AdminDTO;
import com.spring.stockCast.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;

@Controller
@RequiredArgsConstructor
@RequestMapping("/mypage")
public class MypageController {
    private final AdminService adminService;
    @GetMapping("/")
    public String mypageForm() {
        return "mypage";
    }

    // 실제 게시글을 DB에 저장
    @PostMapping("/login")
    public String login(@ModelAttribute AdminDTO adminDTO, HttpSession session) {
        AdminDTO loginedAdminDTO = adminService.login(adminDTO);
        if (loginedAdminDTO != null)
        {
            session.setAttribute("loginedAdminDTO", loginedAdminDTO);
            return "main";
        }
        return "redirect:/admin/login";
    }
}
