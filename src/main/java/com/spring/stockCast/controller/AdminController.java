package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AdminDTO;
import com.spring.stockCast.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {
    private final AdminService adminService;
    @GetMapping("login")
    public String loginForm() {
        return "login";
    }

    // 실제 게시글을 DB에 저장
    @PostMapping("/login")
    public String login(@ModelAttribute AdminDTO adminDTO) {
        if (adminService.login(adminDTO))
        {
            return "main";
        }
        return "redirect:/admin/login";
    }

    @GetMapping("join")
    public String joinForm() {
        return "join";
    }

    // 실제 게시글을 DB에 저장
    @PostMapping("/join")
    public String join(@ModelAttribute AdminDTO adminDTO) {
        System.out.println(adminDTO);
        int joinResult = adminService.join(adminDTO);
        if (joinResult == 0)
        {
            return "redirect:/admin/join";
        }
        return "login";
    }
    @GetMapping("googleJoin")
    public String googleJoinForm() {


        return "join";
    }

}
