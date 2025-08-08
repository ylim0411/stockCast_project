package com.spring.stockCast.service;

import com.spring.stockCast.dto.WeatherDTO;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Service
public class MainService {
    public WeatherDTO getWeather() {
        WeatherDTO dto = new WeatherDTO();

        try {
            LocalDateTime now = LocalDateTime.now();
            int hour = now.getHour();

            String baseTime;
            if (hour < 3) {
                now = now.minusDays(1);
                baseTime = "2300";
            } else if (hour < 6) {
                baseTime = "0200";
            } else if (hour < 9) {
                baseTime = "0500";
            } else if (hour < 12) {
                baseTime = "0800";
            } else if (hour < 15) {
                baseTime = "1100";
            } else if (hour < 18) {
                baseTime = "1400";
            } else if (hour < 21) {
                baseTime = "1700";
            } else {
                baseTime = "2000";
            }

            String baseDate = now.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            // baseTime = now.format(DateTimeFormatter.ofPattern("HH")) + "00";
            String serviceKey = "0U3ztuA+E+nvAZyNncZDE2KBcBpS1TtWBP8ykzqSFb3hCnTXbzDqk/2inKQA3qvE+ZgF69gXD4vGk/+O50aROw==";
            String nx = "60";
            String ny = "127";

            StringBuilder urlBuilder = new StringBuilder("https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst");
            urlBuilder.append("?serviceKey=").append(URLEncoder.encode(serviceKey, "UTF-8"));
            urlBuilder.append("&numOfRows=1000");
            urlBuilder.append("&pageNo=1");
            urlBuilder.append("&dataType=JSON");
            urlBuilder.append("&base_date=").append(baseDate);
            urlBuilder.append("&base_time=").append(baseTime);
            urlBuilder.append("&nx=").append(nx);
            urlBuilder.append("&ny=").append(ny);

            URL url = new URL(urlBuilder.toString());
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            BufferedReader br = new BufferedReader(
                    new InputStreamReader(conn.getInputStream(), "UTF-8")
            );

            StringBuilder result = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                result.append(line);
            }

            br.close();
            conn.disconnect();

            JSONObject json = new JSONObject(result.toString());
            JSONArray items = json
                    .getJSONObject("response")
                    .getJSONObject("body")
                    .getJSONObject("items")
                    .getJSONArray("item");

            boolean hasTMP = false, hasSKY = false, hasPTY = false, hasPOP = false;

            for (int i = 0; i < items.length(); i++) {
                JSONObject item = items.getJSONObject(i);
                String category = item.getString("category");
                String fcstDate = item.getString("fcstDate");
                String fcstValue = item.getString("fcstValue");

                String targetDate = LocalDate.now().plusDays(3).format(DateTimeFormatter.ofPattern("yyyyMMdd"));
                if (!fcstDate.equals(targetDate)) continue;

                dto.setFcstDate(fcstDate); // 날짜는 항상 설정

                switch (category) {
                    case "TMP":
                        if (!hasTMP) {
                            dto.setTemperature(fcstValue);
                            hasTMP = true;
                        }
                        break;
                    case "SKY":
                        if (!hasSKY) {
                            dto.setSky(fcstValue);
                            hasSKY = true;
                        }
                        break;
                    case "PTY":
                        if (!hasPTY) {
                            dto.setPty(fcstValue);
                            hasPTY = true;
                        }
                        break;
                    case "POP":
                        if (!hasPOP) {
                            dto.setPop(fcstValue);
                            hasPOP = true;
                        }
                        break;
                }

                if (hasTMP && hasSKY && hasPTY && hasPOP) break; // 4개 모두 채워졌으면 종료
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        String population = "많음"; // 임시 하드코딩

        int temperature = 0;
        try {
            temperature = Integer.parseInt(dto.getTemperature());
        } catch (NumberFormatException e) {
            System.out.println("[에러] 기온 데이터가 null이거나 파싱 불가능합니다. 기본값 0 사용");
        }

        String recommendation = getRecommendation(dto.getSky(), dto.getPty(), temperature, population);
        dto.setRecommendation(recommendation);

        System.out.println("temperature: " + dto.getTemperature());
        System.out.println("sky: " + dto.getSky());
        System.out.println("pty: " + dto.getPty());
        System.out.println("pop: " + dto.getPop());

        String icon = getWeatherIcon(dto.getSky(), dto.getPty());
        dto.setIcon(icon);

        return dto;
    }

    private String getWeatherIcon(String sky, String pty) {
        if ("1".equals(sky) && "0".equals(pty)) return "sun";
        if ("3".equals(sky) && "0".equals(pty)) return "cloud";
        if ("4".equals(sky) && "0".equals(pty)) return "overcast";
        if ("1".equals(pty)) return "rain";
        if ("2".equals(pty)) return "sleet";
        if ("3".equals(pty)) return "snow";
        return "default";
    }

    private String getRecommendation(String sky, String pty, int temp, String population) {
        if ("1".equals(sky) && "많음".equals(population)) {
            return "아이스크림, 시원한 음료";
        } else if ("4".equals(sky) && "보통".equals(population)) {
            return "간식류 (쿠키, 스낵)";
        } else if (!"0".equals(pty) && "적음".equals(population)) {
            return "우산, 핫팩";
        } else if (temp <= 5 && "보통".equals(population)) {
            return "따뜻한 음료, 핫팩, 장갑";
        } else if (temp >= 30 && "적음".equals(population)) {
            return "할인 상품, 아이스크림 묶음 판매";
        } else if ("많음".equals(population)) {
            return "간식, 스낵, 아이스크림";
        } else {
            return "기본 상품군을 추천합니다.";
        }
    }
}
