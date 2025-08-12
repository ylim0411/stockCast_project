package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AdminDTO;
import com.spring.stockCast.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {
    private final AdminService adminService;
    @GetMapping("login")
    public String loginForm(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("loginedAdminDTO") != null) {
            return "redirect:/main";
        }
        return "login";
    }


    // 실제 게시글을 DB에 저장
    @PostMapping("/login")
    public String login(@ModelAttribute AdminDTO adminDTO, HttpSession session, Model model) {
        AdminDTO loginedAdminDTO = adminService.login(adminDTO);
        if (loginedAdminDTO == null)
        {
            if(!adminService.checkId(adminDTO.getLoginId()))
            {
                model.addAttribute("loginError", "로그인에 실패했습니다. 비밀번호를 확인하세요.");
            }
            else
            {
                model.addAttribute("loginError", "로그인에 실패했습니다. 아이디와 비밀번호를 확인하세요.");
            }
            return "login";
        }
        int selectedStoredId = adminService.getStoredId(loginedAdminDTO.getAdminId());
        session.setAttribute("loginedAdminDTO", loginedAdminDTO);

        session.setAttribute("selectedStoredId", selectedStoredId);
        return "redirect:/main";

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
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        clearSession(request, response);
        return "redirect:/admin/login";
    }
    @PostMapping("/delete")
    public String deleteAdmin(
            @RequestParam("adminId") int adminId,
            HttpSession session,
            RedirectAttributes redirectAttributes,
            HttpServletRequest request, HttpServletResponse response) {

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
        return logout(request, response);
    }
    @PostMapping("/update")
    public String updateAdmin(
            @ModelAttribute AdminDTO adminDTO,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        AdminDTO loginedAdmin = (AdminDTO) session.getAttribute("loginedAdminDTO");

        // 로그인 세션 체크
        if (loginedAdmin == null) {
            redirectAttributes.addFlashAttribute("errorMessage", "로그인이 필요합니다.");
            return "redirect:/admin/login";
        }

        // 본인만 수정 가능하게 adminId 세팅 (파라미터 조작 방지)
        adminDTO.setAdminId(loginedAdmin.getAdminId());

        // 서비스 호출해서 업데이트 수행
        boolean updateResult = adminService.updateAdmin(adminDTO);

        if (!updateResult) {
            redirectAttributes.addFlashAttribute("errorMessage", "정보 수정에 실패했습니다.");
            return "redirect:/mypage/";  // 수정 폼 URL로 변경 가능
        }

        // 업데이트 성공하면 세션 정보도 갱신
        AdminDTO updatedAdmin = adminService.findById(adminDTO.getAdminId());
        session.setAttribute("loginedAdminDTO", updatedAdmin);

        redirectAttributes.addFlashAttribute("successMessage", "정보가 성공적으로 수정되었습니다.");
        return "redirect:/mypage/";  // 수정 후 보여줄 페이지
    }


    private void clearSession(HttpServletRequest request, HttpServletResponse response)
    {
        HttpSession session = request.getSession(false); // 새 세션 생성하지 않음
        if (session != null) {
            session.removeAttribute("loginedAdminDTO"); // 안전하게 속성 제거
            session.invalidate(); // 세션 무효화
        }

        // (선택) 브라우저에 남아있는 JSESSIONID 쿠키 삭제
        Cookie cookie = new Cookie("JSESSIONID", null);
        cookie.setPath(request.getContextPath().isEmpty() ? "/" : request.getContextPath());
        cookie.setMaxAge(0);
        response.addCookie(cookie);
    }
}
