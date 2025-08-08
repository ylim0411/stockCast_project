<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>login</title>
    <style>
      body {
        position: relative;
        width: 100%;
        height: 100vh;
        margin: 0;
        padding: 0;
        background-color: #f5f5f5;
        font-family: "Arial", sans-serif;
      }

      .container {
        position: absolute;
        left: 50%;
        top: 50%;
        transform: translate(-50%, -50%);
        width: 400px;
        background-color: white;
        padding: 80px 50px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        display: flex;
        flex-direction: column;
        gap: 15px;
      }

      h2 {
        text-align: center;
        color: #333;
        margin-bottom: 30px;
      }

      form {
        display: flex;
        flex-direction: column;
        gap: 15px;
      }

      input[type="text"] {
        padding: 20px 10px;
        border: 1px solid #ccc;
        border-radius: 4px;
        font-size: 14px;
        resize: none;
        transition: border-color 0.2s;
      }

      /* 포커스 시 포인트 컬러 */
      .form-row input[type="text"]:focus:not([readonly]),
      .form-row textarea:focus {
        border-color: #007bff;
        outline: none;
      }

      input[type="submit"] {
        padding: 20px;
        font-size: 14px;
        cursor: pointer;
        border: none;
        border-radius: 4px;
        transition: 0.2s;
      }

      input[type="submit"] {
        border-color: #007bff;
        color: white;
      }

      input[type="submit"]:hover {
        border-color: #007bff;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h2>로그인</h2>
      <form action="/admin/login" method="post">
        <input type="text" name="loginId" placeholder="아이디" />
        <input type="text" name="loginPw" placeholder="비밀번호" />
        <input type="submit" value="로그인" class="btn" />
      </form>
      <button onclick="join()">회원가입</button>
      <button onclick="googleJoin()">구글 계정으로 연동</button>
    </div>
    <script>
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
