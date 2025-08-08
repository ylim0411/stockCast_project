package com.spring.stockCast.controller;

import com.spring.stockCast.dto.WeatherDTO;
import com.spring.stockCast.service.MainService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

@Controller
public class MainController {

    @Autowired
    private MainService mainService;

    @GetMapping("/")
    public String Home(){
        return "index";
    }

    @GetMapping("/main")
    public String mainPage(Model model) {
        WeatherDTO weather = mainService.getWeather();
        model.addAttribute("weather", weather);
        model.addAttribute("today", LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy.MM.dd")));

        return "main"; // main.jsp
    }
}
