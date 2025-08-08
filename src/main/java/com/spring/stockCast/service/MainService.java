package com.spring.stockCast.service;

import com.spring.stockCast.dto.TrafficDTO;
import com.spring.stockCast.dto.WeatherDTO;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.stereotype.Service;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.w3c.dom.*;

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

    public TrafficDTO getTraffic() {
        TrafficDTO dto = new TrafficDTO();

        try {
            String apiKey = "c076db842280477d8eaf6a9ff51e08a7";
            String sigunCd = "41194";
            String ym = "202003";

            String apiUrl = "https://openapi.gg.go.kr/IPGDST"
                    + "?KEY=" + apiKey
                    + "&Type=xml"
                    + "&SIGUN_CD=" + sigunCd
                    + "&YM=" + ym;

            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");

            DocumentBuilderFactory dbFactory = DocumentBuilderFactory.newInstance();
            DocumentBuilder dBuilder = dbFactory.newDocumentBuilder();
            Document doc = dBuilder.parse(conn.getInputStream());
            doc.getDocumentElement().normalize();

            NodeList rowList = doc.getElementsByTagName("row");

            double sum10 = 0;
            double sum20 = 0;
            double sum30 = 0;
            double sum40 = 0;
            double sum50 = 0;
            double sum60 = 0;
            double sum70 = 0;

            for (int i = 0; i < rowList.getLength(); i++) {
                Element row = (Element) rowList.item(i);

                double t10m = Double.parseDouble(getTagValue("TYPAGE10_MALE_TOTSUM", row));
                double t10f = Double.parseDouble(getTagValue("TYPAGE10_FEMALE_TOTSUM", row));
                double t20m = Double.parseDouble(getTagValue("TYPAGE20_MALE_TOTSUM", row));
                double t20f = Double.parseDouble(getTagValue("TYPAGE20_FEMALE_TOTSUM", row));
                double t30m = Double.parseDouble(getTagValue("TYPAGE30_MALE_TOTSUM", row));
                double t30f = Double.parseDouble(getTagValue("TYPAGE30_FEMALE_TOTSUM", row));
                double t40m = Double.parseDouble(getTagValue("TYPAGE40_MALE_TOTSUM", row));
                double t40f = Double.parseDouble(getTagValue("TYPAGE40_FEMALE_TOTSUM", row));
                double t50m = Double.parseDouble(getTagValue("TYPAGE50_MALE_TOTSUM", row));
                double t50f = Double.parseDouble(getTagValue("TYPAGE50_FEMALE_TOTSUM", row));
                double t60m = Double.parseDouble(getTagValue("TYPAGE60_MALE_TOTSUM", row));
                double t60f = Double.parseDouble(getTagValue("TYPAGE60_FEMALE_TOTSUM", row));
                double t70m = Double.parseDouble(getTagValue("TYPAGE70_MALE_TOTSUM", row));
                double t70f = Double.parseDouble(getTagValue("TYPAGE70_FEMALE_TOTSUM", row));

                sum10 += t10m + t10f;
                sum20 += t20m + t20f;
                sum30 += t30m + t30f;
                sum40 += t40m + t40f;
                sum50 += t50m + t50f;
                sum60 += t60m + t60f;
                sum70 += t70m + t70f;
            }

            double total = sum10 + sum20 + sum30 + sum40 + sum50 + sum60 + sum70;

            // 각 연령대별 비율(%) 계산
            String age10Percent = total == 0 ? "0" : String.format("%.1f", (sum10 * 100) / total);
            String age20Percent = total == 0 ? "0" : String.format("%.1f", (sum20 * 100) / total);
            String age30Percent = total == 0 ? "0" : String.format("%.1f", (sum30 * 100) / total);
            String age40Percent = total == 0 ? "0" : String.format("%.1f", (sum40 * 100) / total);
            String age50Percent = total == 0 ? "0" : String.format("%.1f", (sum50 * 100) / total);
            String age60Percent = total == 0 ? "0" : String.format("%.1f", (sum60 * 100) / total);
            String age70Percent = total == 0 ? "0" : String.format("%.1f", (sum70 * 100) / total);

            // System.out.println(age10Percent +","+ age20Percent +","+ age30Percent+","+age40Percent +","+ age50Percent+","+age60Percent+","+age70Percent );

            double maxValue = sum10;
            String maxGroup = "10대";

            if (sum20 > maxValue) {
                maxValue = sum20;
                maxGroup = "20대";
            }
            if (sum30 > maxValue) {
                maxValue = sum30;
                maxGroup = "30대";
            }
            if (sum40 > maxValue) {
                maxValue = sum40;
                maxGroup = "40대";
            }
            if (sum50 > maxValue) {
                maxValue = sum50;
                maxGroup = "50대";
            }
            if (sum60 > maxValue) {
                maxValue = sum60;
                maxGroup = "60대";
            }
            if (sum70 > maxValue) {
                maxValue = sum70;
                maxGroup = "70대";
            }

            int percent = (total == 0) ? 0 : (int) Math.round((maxValue * 100) / total);

            dto.setTemperature(percent + "%");
            dto.setRecommendation(getAgeGroupRecommendation(maxGroup));
            dto.setMaxGroup(maxGroup);

            if ("10대".equals(maxGroup)) {
                dto.setIcon("age10");
            } else if ("20대".equals(maxGroup)) {
                dto.setIcon("age20");
            } else if ("30대".equals(maxGroup)) {
                dto.setIcon("age30");
            } else if ("40대".equals(maxGroup)) {
                dto.setIcon("age40");
            } else if ("50대".equals(maxGroup)) {
                dto.setIcon("age50");
            } else if ("60대".equals(maxGroup)) {
                dto.setIcon("age60");
            } else if ("70대".equals(maxGroup)) {
                dto.setIcon("age70");
            } else {
                dto.setIcon("default");
            }

            dto.setAge10(age10Percent + "%");
            dto.setAge20(age20Percent + "%");
            dto.setAge30(age30Percent + "%");
            dto.setAge40(age40Percent + "%");
            dto.setAge50(age50Percent + "%");
            dto.setAge60(age60Percent + "%");
            dto.setAge70(age70Percent + "%");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return dto;
    }


    private static String getTagValue(String tag, Element element) {
        NodeList nlList = element.getElementsByTagName(tag).item(0).getChildNodes();
        Node nValue = (Node) nlList.item(0);
        return nValue.getNodeValue();
    }

    private String getAgeGroupRecommendation(String maxGroup) {
        switch (maxGroup) {
            case "10대":
            case "20대":
                return "간편한 간식, 에너지 드링크, 아이스크림";
            case "30대":
                return "건강 간식, 커피, 과자류";
            case "40대":
                return "과자, 건강 음료";
            case "50대":
                return "따뜻한 음료, 편안한 간식";
            case "60대":
                return "저당 건강 간식, 차";
            case "70대":
                return "영양 간식, 따뜻한 음료";
            default:
                return "기본 상품군을 추천합니다.";
        }
    }


}
