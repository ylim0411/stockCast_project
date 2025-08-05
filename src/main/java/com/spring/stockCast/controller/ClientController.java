package com.spring.stockCast.controller;

import com.spring.stockCast.dto.AdminDTO;
import com.spring.stockCast.dto.ClientDTO;
import com.spring.stockCast.dto.StoreDTO;
import com.spring.stockCast.service.ClientService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/client")
public class ClientController {
    private final ClientService clientService;

    @GetMapping("/")
    public String clientForm(HttpSession session, Model model) {
        AdminDTO adminDTO = (AdminDTO) session.getAttribute("loginedAdminDTO");
        List<ClientDTO> tmpClientDTOs = clientService.selectByAdminId(adminDTO.getAdminId());
        model.addAttribute("clientList", tmpClientDTOs);
        System.out.println(tmpClientDTOs);
        return "client";
    }
}
