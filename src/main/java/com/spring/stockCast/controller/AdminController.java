package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AdminDTO;
import com.spring.stockCast.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
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
    public String login(@ModelAttribute AdminDTO adminDTO, HttpSession session, Model model) {
        AdminDTO loginedAdminDTO = adminService.login(adminDTO);
        if (loginedAdminDTO == null)
        {
            model.addAttribute("loginError", "로그인에 실패했습니다. 아이디와 비밀번호를 확인하세요.");
            return "login";
        }
        session.setAttribute("loginedAdminDTO", loginedAdminDTO);
        session.setAttribute("selectedStoredId", 1);
        return "main";

    }

    @GetMapping("join")
    public String joinForm() {
        return "join";
    }

    // 실제 게시글을 DB에 저장
    @PostMapping("/join")
    public String join(@ModelAttribute AdminDTO adminDTO, Model model) {
        System.out.println(adminDTO);
        if (!adminService.checkId(adminDTO.getLoginId()))
        {
            model.addAttribute("joinError", "아이디가 중복됩니다. 회원가입을 다시 해주세요");
            return "join";
        }
        int joinResult = adminService.join(adminDTO);
        if (joinResult == 0)
        {
            model.addAttribute("joinError", "회원가입에 실패했습니다. 정보들을 확인해주세요");
            return "join";
        }
        return "login";
    }
    @GetMapping("googleJoin")
    public String googleJoinForm() {
        return "join";
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "login";
    }
    @PostMapping("/delete")
    public String deleteAdmin(
            @RequestParam("adminId") int adminId,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        // 세션에서 로그인된 관리자 확인
        AdminDTO loginedAdmin = (AdminDTO) session.getAttribute("loginedAdminDTO");

        // 보안 체크: 세션 admin과 파라미터 adminId 일치하는지 확인
        if (loginedAdmin == null || loginedAdmin.getAdminId() != adminId) {
            redirectAttributes.addFlashAttribute("errorMessage", "잘못된 요청입니다.");
            return "redirect:/";
        }

        // 탈퇴 처리
        if (!adminService.deleteAdminById(adminId))
        {
            return "redirect:/";
        }

        // 로그인 페이지로 리디렉션
        return logout(session);
    }
}
