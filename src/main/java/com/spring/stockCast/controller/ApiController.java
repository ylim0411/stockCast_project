package com.spring.stockCast.controller;

import com.spring.stockCast.dto.TrafficDTO;
import com.spring.stockCast.dto.WeatherDTO;
import com.spring.stockCast.service.MainService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ApiController {

    @Autowired
    private MainService mainService;

    @GetMapping("/api/weather")
    public WeatherDTO getWeatherData() {
        return mainService.getWeather();
    }

    @GetMapping("/api/traffic")
    public TrafficDTO traffic(@RequestParam(value="dot", defaultValue="") String dot) {
        String dotParam = dot.trim();
        return dotParam.isEmpty()
                ? mainService.getTraffic()
                : mainService.getTrafficByArvlDot(dotParam);
    }
}
