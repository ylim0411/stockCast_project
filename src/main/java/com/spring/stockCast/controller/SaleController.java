package com.spring.stockCast.controller;

import com.spring.stockCast.service.SaleService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Controller
@RequiredArgsConstructor
@RequestMapping("/sale")
public class SaleController {
    private final SaleService service;

    // 임시라 나중에 지워야함
    @GetMapping("/main")
    private String mainForm(){
        return "main";
    }
    // 판매실적 화면 이동
    @GetMapping("/")
    public String chartForm(){
        return "sale";
    }
}
@RestController
@RequestMapping("/sale")
class test{
    @GetMapping("/hello")
    public String test(){
        System.out.println("Wlrg");
        return "<div class=\"container\">\n" +
                "        <div class=\"sale-header\"></div>\n" +
                "            <h1>판매실적</h1>\n" +
                "        <div class=\"sale-header\"></div>\n" +
                "        <div class=\"chart-container\">\n" +
                "            <div class=\"doughnut-chart\">\n" +
                "                <canvas id=\"itemsChart\"></canvas>\n" +
                "            </div>\n" +
                "            <div class=\"line-chart\">\n" +
                "                <canvas id=\"salesChart\"></canvas>\n" +
                "            </div>\n" +
                "        </div>\n" +
                "    </div>\n" +
                "\n" +
                "    <script>\n" +
                "        // 도넛 차트 (판매 항목별 비율)\n" +
                "        var itemCtx = document.getElementById('itemsChart').getContext('2d');\n" +
                "        var itemsChart = new Chart(itemCtx, {\n" +
                "            type: 'doughnut',  // 도넛 차트 유형\n" +
                "            data: {\n" +
                "                labels: ['전자제품', '의류', '식품', '도서', '가구', '기타'], // 라벨 예시\n" +
                "                datasets: [{\n" +
                "                    label: '판매 항목별 비율', // 데이터셋 라벨\n" +
                "                    data: [12, 19, 3, 5, 2, 3], // 실제 데이터 값\n" +
                "                    backgroundColor: [\n" +
                "                        'rgba(255, 99, 132, 0.7)', // 색상 투명도 조정\n" +
                "                        'rgba(54, 162, 235, 0.7)',\n" +
                "                        'rgba(255, 206, 86, 0.7)',\n" +
                "                        'rgba(75, 192, 192, 0.7)',\n" +
                "                        'rgba(153, 102, 255, 0.7)',\n" +
                "                        'rgba(255, 159, 64, 0.7)'\n" +
                "                    ],\n" +
                "                    borderColor: [\n" +
                "                        'rgba(255, 99, 132, 1)',\n" +
                "                        'rgba(54, 162, 235, 1)',\n" +
                "                        'rgba(255, 206, 86, 1)',\n" +
                "                        'rgba(75, 192, 192, 1)',\n" +
                "                        'rgba(153, 102, 255, 1)',\n" +
                "                        'rgba(255, 159, 64, 1)'\n" +
                "                    ],\n" +
                "                    borderWidth: 1\n" +
                "                }]\n" +
                "            },\n" +
                "            options: { // options 객체가 data 객체와 같은 레벨에 있어야 합니다.\n" +
                "                responsive: true, // 컨테이너 크기에 맞춰 캔버스 크기 조절\n" +
                "                maintainAspectRatio: false, // 컨테이너 크기에 맞춰 종횡비 유지 안함\n" +
                "                plugins: {\n" +
                "                    legend: {\n" +
                "                        display: true,\n" +
                "                        position: 'right' // 범례 위치\n" +
                "                    },\n" +
                "                    title: {\n" +
                "                        display: true,\n" +
                "                        text: '판매 항목별 비율' // 차트 제목\n" +
                "                    }\n" +
                "                }\n" +
                "            }\n" +
                "        });\n" +
                "\n" +
                "        // 꺾은선 차트 (월별 판매 추이)\n" +
                "        var salesCtx = document.getElementById('salesChart').getContext('2d');\n" +
                "        var salesChart = new Chart(salesCtx, {\n" +
                "            type: 'line',  // 꺾은선 차트 유형\n" +
                "            data: {\n" +
                "                labels: ['1월', '2월', '3월', '4월', '5월', '6월'], // 월별 라벨\n" +
                "                datasets: [{\n" +
                "                    label: '월별 판매량', // 데이터셋 라벨\n" +
                "                    data: [120, 190, 300, 250, 400, 350], // 실제 데이터 값\n" +
                "                    backgroundColor: 'rgba(54, 162, 235, 0.2)', // 선 아래 영역 배경색\n" +
                "                    borderColor: 'rgba(54, 162, 235, 1)', // 선 색상\n" +
                "                    borderWidth: 2, // 선 두께\n" +
                "                    fill: true, // 선 아래 영역 채우기\n" +
                "                    tension: 0.3, // 선의 부드러움 정도\n" +
                "                    pointBackgroundColor: 'rgba(54, 162, 235, 1)', // 데이터 포인트 배경색\n" +
                "                    pointBorderColor: '#fff', // 데이터 포인트 테두리 색상\n" +
                "                    pointHoverBackgroundColor: '#fff',\n" +
                "                    pointHoverBorderColor: 'rgba(54, 162, 235, 1)'\n" +
                "                }]\n" +
                "            },\n" +
                "            options: {\n" +
                "                responsive: true,\n" +
                "                maintainAspectRatio: false,\n" +
                "                scales: {\n" +
                "                    y: { // y축 설정\n" +
                "                        beginAtZero: true, // 0부터 시작\n" +
                "                        title: {\n" +
                "                            display: true,\n" +
                "                            text: '판매량' // y축 제목\n" +
                "                        }\n" +
                "                    },\n" +
                "                    x: { // x축 설정\n" +
                "                        title: {\n" +
                "                            display: true,\n" +
                "                            text: '월' // x축 제목\n" +
                "                        }\n" +
                "                    }\n" +
                "                },\n" +
                "                plugins: {\n" +
                "                    legend: {\n" +
                "                        display: true,\n" +
                "                        position: 'top'\n" +
                "                    },\n" +
                "                    title: {\n" +
                "                        display: true,\n" +
                "                        text: '월별 판매 추이' // 차트 제목\n" +
                "                    }\n" +
                "                }\n" +
                "            }\n" +
                "        });";
    }
}
