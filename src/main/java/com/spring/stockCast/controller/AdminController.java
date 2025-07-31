package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AdminDTO;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.UUID;

@Controller
public class AdminController {
    @GetMapping("login")
    public String loginForm() {
        return "login";
    }

    // 실제 게시글을 DB에 저장
    @PostMapping("/login")
    public String login(@ModelAttribute AdminDTO adminDTO) {
        return "";
    }

    @GetMapping("join")
    public String joinForm() {
        return "join";
    }

    // 실제 게시글을 DB에 저장
    @PostMapping("/join")
    public String join(@ModelAttribute AdminDTO adminDTO) {
        System.out.println(adminDTO);
        return "login";
    }
}
