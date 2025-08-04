package com.spring.stockCast.controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeTokenRequest;
import com.google.api.client.googleapis.auth.oauth2.GoogleTokenResponse;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.http.HttpRequestInitializer;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.services.oauth2.Oauth2;
import com.google.api.services.oauth2.model.Userinfo;

import com.spring.stockCast.service.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
@RequiredArgsConstructor
public class GoogleController {
    private final AdminService adminService;

    // Google OAuth 설정값
    private static final String CLIENT_ID = "731793300974-m255ruf4ph38c1j01nqaesitglj2umu3.apps.googleusercontent.com";
    private static final String CLIENT_SECRET = "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";
    private static final String REDIRECT_URI = "http://localhost:8080/oauth2callback";

    @GetMapping("/oauth2callback")
    public String oauth2callback(@RequestParam("code") String code, HttpSession session, Model model) throws Exception {
        GoogleTokenResponse tokenResponse = new GoogleAuthorizationCodeTokenRequest(
                new NetHttpTransport(),
                JacksonFactory.getDefaultInstance(),
                "https://oauth2.googleapis.com/token",
                CLIENT_ID,
                CLIENT_SECRET,
                code,
                REDIRECT_URI
        ).execute();

        // 액세스 토큰을 이용해 인증 헤더 셋팅
        HttpRequestInitializer requestInitializer = request -> {
            request.getHeaders().setAuthorization("Bearer " + tokenResponse.getAccessToken());
        };

        Oauth2 oauth2 = new Oauth2.Builder(new NetHttpTransport(), JacksonFactory.getDefaultInstance(), requestInitializer)
                .setApplicationName("YourAppName")
                .build();

        Userinfo userInfo = oauth2.userinfo().get().execute();
        System.out.println("GoogleController :  "+userInfo);

        if (adminService.isJoinedById(userInfo.getEmail()))
        {
            return "main";
        }


        model.addAttribute("email", userInfo.getEmail());
        model.addAttribute("name", userInfo.getName());

        return "join";
    }

}
