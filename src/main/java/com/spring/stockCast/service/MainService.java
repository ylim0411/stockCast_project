package com.spring.stockCast.service;

import com.spring.stockCast.dto.TrafficDTO;
import com.spring.stockCast.dto.WeatherDTO;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.XML;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.net.URLEncoder;

@Service
public class MainService {

    // 날씨 API 연동, 데이터
    public WeatherDTO getWeather() {
        WeatherDTO dto = new WeatherDTO();
        try {
            LocalDateTime now = LocalDateTime.now();
            int hour = now.getHour();

            String baseTime;
            if (hour < 2)       { now = now.minusDays(1); baseTime = "2300"; }
            else if (hour < 5)  { baseTime = "0200"; }
            else if (hour < 8)  { baseTime = "0500"; }
            else if (hour < 11) { baseTime = "0800"; }
            else if (hour < 14) { baseTime = "1100"; }
            else if (hour < 17) { baseTime = "1400"; }
            else if (hour < 20) { baseTime = "1700"; }
            else                { baseTime = "2000"; }

            String baseDate = now.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            String serviceKey = "0U3ztuA%2BE%2BnvAZyNncZDE2KBcBpS1TtWBP8ykzqSFb3hCnTXbzDqk%2F2inKQA3qvE%2BZgF69gXD4vGk%2F%2BO50aROw%3D%3D";
            String nx = "62", ny = "133";

            String url = "https://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst"
                    + "?serviceKey=" + serviceKey
                    + "&numOfRows=1000&pageNo=1&dataType=JSON"
                    + "&base_date=" + baseDate
                    + "&base_time=" + baseTime
                    + "&nx=" + nx + "&ny=" + ny;

            HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
            conn.setRequestMethod("GET");

            StringBuilder sb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                String line; while ((line = br.readLine()) != null) sb.append(line);
            }

            JSONObject json = new JSONObject(sb.toString());
            JSONArray items = json.getJSONObject("response").getJSONObject("body").getJSONObject("items").getJSONArray("item");

            String targetDate = LocalDate.now().plusDays(3).format(DateTimeFormatter.ofPattern("yyyyMMdd"));

            boolean hasTMP=false, hasSKY=false, hasPTY=false, hasPOP=false;
            for (int i=0;i<items.length();i++){
                JSONObject it = items.getJSONObject(i);
                if (!targetDate.equals(it.getString("fcstDate"))) continue;
                String cat = it.getString("category");
                String val = it.getString("fcstValue");
                switch(cat){
                    case "TMP": if(!hasTMP){ dto.setTemperature(val); hasTMP=true; } break;
                    case "SKY": if(!hasSKY){ dto.setSky(val);         hasSKY=true; } break;
                    case "PTY": if(!hasPTY){ dto.setPty(val);         hasPTY=true; } break;
                    case "POP": if(!hasPOP){ dto.setPop(val);         hasPOP=true; } break;
                }
                if(hasTMP && hasSKY && hasPTY && hasPOP) break;
            }
        } catch (Exception e) {
            System.out.println("[WEATHER] API 호출/파싱 실패: " + e.getMessage());
        }

        int t=0; try{ t=Integer.parseInt(dto.getTemperature()); } catch(Exception ignore){ dto.setTemperature("0"); }
        dto.setRecommendation(getRecommendation(dto.getSky(), dto.getPty(), t));
        dto.setIcon(getWeatherIcon(dto.getSky(), dto.getPty()));
        return dto;
    }

    // 날씨 아이콘
    private String getWeatherIcon(String sky, String pty) {
        if (sky == null || pty == null) return "default";
        if ("1".equals(sky) && "0".equals(pty)) return "sun";
        if ("3".equals(sky) && "0".equals(pty)) return "cloud";
        if ("4".equals(sky) && "0".equals(pty)) return "overcast";
        if ("1".equals(pty)) return "rain";
        if ("2".equals(pty)) return "sleet";
        if ("3".equals(pty)) return "snow";
        return "default";
    }

    // 날씨 상품 추천 텍스트
    private String getRecommendation(String sky, String pty, int temp) {
        if (pty != null && !"0".equals(pty)) return "우산, 핫팩, 컵라면";
        if ("1".equals(sky)) return "아이스크림, 시원한 음료, 선글라스";
        if ("4".equals(sky)) return "간식류 (쿠키, 스낵), 따뜻한 음료";
        if (temp <= 5) return "따뜻한 음료, 핫팩, 장갑";
        if (temp >= 30) return "할인 상품, 아이스크림 묶음 판매";
        return "우산, 간식류 (쿠키, 스낵)";
    }

    // 유동인구 API 연동, 데이터
    public TrafficDTO getTraffic() {
        return getTrafficByArvlDot("41800");
    }

    public TrafficDTO getTrafficByArvlDot(String arvlDotCode) {
        final String YM_FIXED = "202003";
        final String BGPT_CD = "50110";
        final int PAGE_SIZE = 1000;

        TrafficDTO dto = new TrafficDTO();

        try {
            String apiKey = "c076db842280477d8eaf6a9ff51e08a7";
            String url = "https://openapi.gg.go.kr/IPGDST"
                    + "?KEY=" + URLEncoder.encode(apiKey, "UTF-8")
                    + "&Type=xml"
                    + "&pIndex=1"
                    + "&pSize=" + PAGE_SIZE
                    + "&YM=" + YM_FIXED
                    + "&BGPT_CD=" + BGPT_CD
                    + "&ARVL_REGION_NM=N&BGNG_REGION_NM=N";

            HttpURLConnection conn = (HttpURLConnection) new URL(url).openConnection();
            conn.setRequestMethod("GET");

            StringBuilder sb = new StringBuilder();
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"))) {
                String line;
                while ((line = br.readLine()) != null) sb.append(line);
            }
            String xmlBody = sb.toString();

            JSONObject jsonResponse = XML.toJSONObject(xmlBody);

            if (!jsonResponse.has("IPGDST")) {
                System.err.println("[TRAFFIC] API 응답에 'IPGDST' 키가 없습니다. 전체 응답: " + xmlBody);
                return dto;
            }

            JSONObject ipgdstObject = jsonResponse.getJSONObject("IPGDST");

            Object rowObject = ipgdstObject.opt("row");
            if (rowObject == null) {
                System.err.println("[TRAFFIC] 'row' 데이터가 없습니다. IPGDST 객체: " + ipgdstObject.toString());
                return dto;
            }

            JSONArray rows;
            if (rowObject instanceof JSONArray) {
                rows = (JSONArray) rowObject;
            } else {
                rows = new JSONArray().put(rowObject);
            }

            for (int i = 0; i < rows.length(); i++) {
                JSONObject row = rows.getJSONObject(i);
                String dotCodeFromApi = normalizeCode(row.get("ARVL_DOT_CD").toString());

                if (arvlDotCode.equals(dotCodeFromApi)) {
                    double totalTraffic = 0;
                    double[] ageSums = new double[7];

                    for (int age = 10; age <= 70; age += 10) {
                        double male = parseDouble(row.optString("TYPAGE" + age + "_MALE_TOTSUM", "0"));
                        double female = parseDouble(row.optString("TYPAGE" + age + "_FEMALE_TOTSUM", "0"));
                        ageSums[age / 10 - 1] = male + female;
                        totalTraffic += ageSums[age / 10 - 1];
                    }

                    int maxAgeIndex = 0;
                    double maxTraffic = 0;
                    if (totalTraffic > 0) {
                        for (int j = 0; j < ageSums.length; j++) {
                            if (ageSums[j] > maxTraffic) {
                                maxTraffic = ageSums[j];
                                maxAgeIndex = j;
                            }
                        }
                    }

                    int maxAge = (maxAgeIndex + 1) * 10;

                    dto.setTemperature(String.format("%.2f", maxTraffic)+"%");
                    dto.setMaxGroup(maxAge + "대");
                    dto.setRecommendation(getAgeGroupRecommendation(maxAge + "대"));
                    dto.setIcon("age" + maxAge); // 유동인구 아이콘
                    return dto;
                }
            }
        } catch (Exception e) {
            System.err.println("[TRAFFIC] 데이터 처리 실패: " + e.getMessage());
            e.printStackTrace();
        }

        // 오류 발생 시 기본값 설정
        dto.setTemperature("0.00");
        dto.setMaxGroup("정보 없음");
        dto.setRecommendation("유동인구 데이터 없음");
        dto.setIcon("age20");
        return dto;
    }

    // 문자열을 double형 실수로 변환
    private double parseDouble(String s) {
        try {
            return Double.parseDouble(s.trim());
        } catch (Exception e) {
            return 0;
        }
    }

    // 유동인구 상품 추천 텍스트
    private String getAgeGroupRecommendation(String ageGroup) {
        switch (ageGroup) {
            case "10대":
            case "20대": return "간편한 간식, 에너지 드링크, 아이스크림";
            case "30대": return "건강 간식, 커피, 과자류";
            case "40대": return "과자, 건강 음료";
            case "50대": return "따뜻한 음료, 편안한 간식";
            case "60대": return "저당 건강 간식, 차";
            case "70대": return "영양 간식, 따뜻한 음료";
            default: return "기본 상품군을 추천합니다.";
        }
    }

    // 숫자만 남기고 나머지 문자를 제거
    private String normalizeCode(String s) {
        if (s == null) return "";
        return s.replaceAll("[^0-9]", "");
    }
}