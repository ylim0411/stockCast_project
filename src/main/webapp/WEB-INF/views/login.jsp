<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>login</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/static/css/style.css"
    />
  </head>
  <body>
    <div class="container">
      <div class="login">
        <div class="logo">
          <img
            src="${pageContext.request.contextPath}/static/images/logo-b.png"
            alt="logo"
          />
        </div>
        <div class="login-text">
          <form action="/admin/login" method="post">
            <input type="text" name="loginId" placeholder="아이디" />
            <input
              type="password"
              id="loginPw"
              name="loginPw"
              placeholder="비밀번호"
            />
            <button
              type="button"
              onclick="togglePassword()"
              id="togglePwBtn"
              style="
                position: absolute;
                right: 60px;
                top: 268px;
                transform: translateY(-50%);
                background: none;
                border: none;
                cursor: pointer;
                z-index: 9999;
              "
            >
              <img
                id="togglePwIcon"
                src="${pageContext.request.contextPath}/static/images/eye-close.png"
                alt="보기"
                style="width: 20px; height: 20px"
              />
            </button>
            <input type="submit" value="로그인" class="btn submit-btn" />
          </form>
          <div>
            <div class="login-divider">
              <span>또는</span>
            </div>

            <div class="social-login">
              <button class="google-login" onclick="googleJoin()">
                <img
                  src="${pageContext.request.contextPath}/static/images/google.png"
                  alt="Google"
                />
                Google로 로그인
              </button>
            </div>

            <div class="login-links">
              <!-- <a href="#" class="forgot">비밀번호를 잊으셨나요?</a> -->
              <p>
                계정이 없으신가요?
                <a href="#" class="join" onclick="join()">가입하기</a>
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- container -->
    <script>
      function togglePassword() {
        const pwField = document.getElementById("loginPw");
        const icon = document.getElementById("togglePwIcon");

        if (pwField.type === "password") {
          pwField.type = "text";
          icon.src = `${pageContext.request.contextPath}/static/images/eye-open.png`; // 열린 눈

          icon.alt = "숨기기";
        } else {
          pwField.type = "password";
          icon.src = `${pageContext.request.contextPath}/static/images/eye-close.png`; // 닫힌 눈
          icon.alt = "보기";
        }
      }
      // 로그인 실패시 alert 띄우기
      <c:if test="${not empty loginError}">alert('${loginError}');</c:if>;
      const join = () => {
        location.href = "/admin/join";
      };
      const googleJoin = () => {
        location.href =
          "https://accounts.google.com/o/oauth2/v2/auth?" +
          "client_id=731793300974-m255ruf4ph38c1j01nqaesitglj2umu3.apps.googleusercontent.com" +
          "&redirect_uri=http%3A%2F%2Flocalhost%3A8080%2Foauth2callback" +
          "&response_type=code" +
          "&scope=email%20profile" +
          "&access_type=offline";
      };
    </script>
  </body>
</html>
